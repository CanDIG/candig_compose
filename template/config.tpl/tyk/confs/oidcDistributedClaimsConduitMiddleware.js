// ---- OIDC Distributed Claims Conduit middleware -----

// TODO: refactor this codebase for all that is holy.


var version = "0.0.100";

var oidcDistributedClaimsConduitMiddleware = new TykJS.TykMiddleware.NewMiddleware({});

oidcDistributedClaimsConduitMiddleware.NewProcessRequest(function(request, session, spec) {

    log("Running OIDC Distributed Claims Conduit JSVM middleware");

    
    if (request.Headers["Authorization"] != undefined) {
        try {
            var token = request.Headers["Authorization"][0].split(" ")[1];
            var tokenPayload = token.split(".")[1];
        } catch(err) {
            var tokenPayload = {}
            log("Could not fetch the Authorization token"+err);
        }

        var padding = tokenPayload.length % 4;
        if (padding != 0) {
            _.times(4-padding, function() {
                tokenPayload += "="
            })
        }
        var decodedPayload = JSON.parse(b64dec(tokenPayload))
        
        try {
            var _claim_names = decodedPayload["_claim_names"];
        } catch(err) {
            log("Cannot find _claim_names in the token payload");
        }
        
        try {
            var _claim_sources = decodedPayload["_claim_sources"];
        } catch(err) {
            log("Cannot find _claim_sources in the token payload");
        }
        
        var claimSources = {};  // store map of URLs
        for (var item in _claim_names) {
            try {
                var claim = _claim_names[item];
                claimSources[item] = _claim_sources[claim]["endpoint"];  // get the URL
            } catch(err) {
                log("Claim item is missing in either _claim_names or _claim_sources");
            }
        }

        var claimResponses = {};
        for (var item in claimSources) {
            var url = claimSources[item];
            
            try {
                // as disgusting as this looks, I have no other option
                // this was the simplest way to parse the URL
                var splitUrl = url.split("/");
                var urlDomain = splitUrl.slice(0, 3).join("/").toString();
                var urlSegments = "/" + splitUrl.slice(3).join("/").toString();
    
                var claimRequest = {
                    "Method": "GET",
                    "Domain": urlDomain,
                    "Resource": urlSegments
                };
                log("CLAIM STUFF: "+JSON.stringify(claimRequest));
            } catch(err) {
                log("sweet lord jesus");
            }

            try {
                var encodedResponse = TykMakeHttpRequest(JSON.stringify(claimRequest));
            } catch(err) {
                log("Request to "+claimRequest.Domain+claimSources[item]+" failed.");
            }

            try {
                var decodedResponse = JSON.parse(encodedResponse);
                claimResponses[item] = decodedResponse;
            } catch(err) {
                log("JSON parsing failed for the response");
            }
        }
        
        for (var item in claimResponses) {
            // adds header like 
            // X-Claim-Profyle-Member: <...JWT token...>
            try {
                var distributedClaimToken = claimResponses[item].Body;
                request.SetHeaders["X-Claim-"+item.replace(/_/g, "-").toUpperCase()] = distributedClaimToken;
            } catch(err) {
                log("Could not add X-Claim- headers to the request. Check the responses type.");
            }
            
        }
        //log("request headers "+JSON.stringify(request.Headers));
    }
    
    // MUST return both the request and session
    return oidcDistributedClaimsConduitMiddleware.ReturnData(request, session.meta_data);
});

log("OIDC Distributed Claims Conduit middleware initialised");