// ---- Authentication middleware -----

var authMiddleware = new TykJS.TykMiddleware.NewMiddleware({});

/*
  requestObj: json formatted request as specified in Tyk docs

  returns a parsed JSON response object
*/
function handleTykRequest(requestObj) {

    var encodedResponse = TykMakeHttpRequest(JSON.stringify(requestObj));
    var decodedResponse = JSON.parse(encodedResponse);

    // need to parse a valid response body
    try {
       var decodedBody = JSON.parse(decodedResponse.Body);
    } catch(err) {
       var decodedBody = {}
    }

    return decodedBody
}

/*
  body: json object of parameters to send along
  spec: json object containing config details set in Tyk Dashboard under advanced settings

  returns a parsed JSON object with keycloak token information 
*/
function getOIDCToken(body, spec) {
    
    // default token request domain/headers
    tokenRequest = {
        "Method": "POST",
        "FormData": body, 
        "Headers": {"Content-Type": "application/x-www-form-urlencoded"},
        "Domain": spec.config_data.keycloak_host,
        "Resource": "/auth/realms/"+spec.config_data.keycloak_realm+"/protocol/openid-connect/token"
    }

    return handleTykRequest(tokenRequest)
}

function logoutOIDC(request, spec) {

    var requestBody = JSON.parse(request.Body)
    var access = requestBody["access"]
    var refresh = requestBody["refresh"]

    delete requestBody["access"]
    delete requestBody["refresh"]

    body = {
        "refresh_token" : refresh,
        "client_id" : spec.config_data.keycloak_client,
        "client_secret" : spec.config_data.keycloak_secret
    }

    headers = {
        "Authorization" : "Bearer "+access,
        "Content-Type" : "application/x-www-form-urlencoded"
    }

    logoutRequest = {
        "Method": "POST",
        "FormData": body,
        "Headers": headers,
        "Domain": spec.config_data.keycloak_host,
        "Resource": "/auth/realms/"+spec.config_data.keycloak_realm+"/protocol/openid-connect/logout"
    }

    return handleTykRequest(logoutRequest)
}

/*
  body: query parameter string found in response body

  returns a parsed object mapping param keys to values
*/
function parseRequestBody(body) {

    var parsedBody = {}
    body.replace(
        new RegExp("([^=&]+)(=([^&]*))?", "g"), 
        function(w, x, y, z) { parsedBody[x] = z; }
    );
    return parsedBody
}

/*
  request: the incoming request object
  session_id=id_token

  return the id token portion of the cookie to use in the gateway
*/
function extractTokenCookie(request) {

    var splitCookie = request.Headers["Cookie"][0].split("; ");
    var tokenCookie = _.find(splitCookie, function(cookie) {
        if (cookie.indexOf("session_id=") > -1) {
            return cookie
        }
    });

    return tokenCookie
}

function isTokenExpired(idToken) {

    // parse token
    // compare exp times
    tokenPayload = idToken.split(".")[1]
    padding = tokenPayload.length % 4

    if (padding != 0) {
        _.times(4-padding, function() {
            tokenPayload += "="
        })
    }

    decodedPayload = JSON.parse(b64dec(tokenPayload))
    tokenExpires = decodedPayload["exp"]
    sysTime = (new Date).getTime()/1000 | 0;

    return sysTime>tokenExpires
}

/*
  Bulk of the authentication validation middleware
  This runs as a "PRE" middleware

  request: incoming request object
  session: tyk session object (undefined pre authentication)
  spec: json object containing config details set in Tyk Dashboard under advanced settings

  returns the processed request object
*/
authMiddleware.NewProcessRequest(function(request, session, spec) {

    log("Running Authorization JSVM middleware")

    // prepare auth/redirect urls
    var baseUrl = spec.config_data.tyk_host + spec.config_data.tyk_listen
    var loginUri = '/login_oidc'
    var tokenUri = spec.config_data.tyk_listen + '/token'
    var returnUri = spec.config_data.tyk_host + request.URL

    // if no auth header, try to get a token
    if (request.Headers["Authorization"] == undefined) {

        // Checking for browser access or login code
        try {    
            var tokenCookie = extractTokenCookie(request)
        } catch(err) {
            log(err)
            var tokenCookie = undefined
        }

        try {
            var parsedBody = parseRequestBody(request.Body)
            var code = _.has(parsedBody, "code") ? parsedBody["code"] : undefined
        } catch(err) {
            log(err)
            var code = undefined
        } 
        
        // check for cookie token (browser access)
        if (tokenCookie != undefined) {

            // set header to be able to pass through tyk gateway
            var idToken = tokenCookie.split("=")[1];

            // attach to header if token still valid
            if (isTokenExpired(idToken)) {
                // if keycloak server session active, loginUri will auto-refresh id token
                request.URL = loginUri

            } else {
                request.SetHeaders["Authorization"] = "Bearer " + idToken;
            }

        // convert code to token (initial login - browser access)
        } else if (code != undefined) {

            // set url to redirect to after successful login
            request.AddParams["returnUri"] = returnUri

            body = {
                "client_id": spec.config_data.keycloak_client,
                "client_secret": spec.config_data.keycloak_secret,
                "grant_type": "authorization_code",
                "redirect_uri": baseUrl+loginUri,
                "code": code
            }

            var decodedBody = getOIDCToken(body, spec);

            // obtain tokens if available
            if (_.has(decodedBody, "id_token")) {
                // get the token
                var idToken = decodedBody["id_token"]
                var accessToken = decodedBody["access_token"]
                var refreshToken = decodedBody["refresh_token"]

                // set header to be able to pass through tyk gateway
                request.SetHeaders["Authorization"] = "Bearer " + idToken;

                // pass additional tokens to dataserver for session management
                request.SetHeaders["KC-Refresh"] = refreshToken
                request.SetHeaders["KC-Access"] = accessToken

            // log errors and redirect to login
            } else {
                
                if (_.has(decodedBody, "error")) {
                    log(decodedBody["error"] + ":" + decodedBody["error_description"])
                } else {
                    log(JSON.stringify(decodedBody))
                }
                // redirect request back to login
                request.URL = loginUri
            }


        // handle authentication end point (REST API access)
        // username and password must be passed as a dict -d '{"username": "john", "password": "doe"}
        } else if (request.URL == tokenUri) {
            
           try {
                var requestBody = JSON.parse(request.Body)
                var username = requestBody["username"]
                var password = requestBody["password"]

                // remove credentials from request
                delete requestBody["password"]
                request.Body = JSON.stringify(requestBody)

                body = {
                    "username": username,
                    "password": password,
                    "grant_type": "password",
                    "scope": "openid",
                    "client_id": spec.config_data.keycloak_client,
                    "client_secret": spec.config_data.keycloak_secret
                }

                var decodedBody = getOIDCToken(body, spec)

                // Check for login errors
                if (decodedBody["error"] == undefined) {

                    // get the token
                    var idToken = decodedBody["id_token"]
            
                    // set header
                    request.SetHeaders["Authorization"] = "Bearer " + idToken;

                
                } else {
                    request.Body = decodedBody["error_description"]
                }

            } catch(err) {
                log("Error while parsing request body: "+err)
                request.Body = "no credentials detected"
            }
         
        // no attempt at providing credentials, redirect to login endpoint
        } else {
	    
            log("Authentication not attempted");
        
            request.AddParams["returnUri"] = returnUri
            request.URL = loginUri
        }
    }
    
    // MUST return both the request and session  
    return authMiddleware.ReturnData(request, session.meta_data);
});
    
log("Authorization middleware initialised");
