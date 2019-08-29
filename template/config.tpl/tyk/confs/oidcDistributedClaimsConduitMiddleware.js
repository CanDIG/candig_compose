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
        //log(JSON.stringify(decodedPayload));
        //log(tokenPayload);
        
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
                claimSources[item] = _claim_sources[claim];  // get the URL
            } catch(err) {
                log("Claim item is missing in either _claim_names or _claim_sources");
            }
        }
        //log(JSON.stringify(claimSources));

        var claimResponses = {};
        for (var item in claimSources) {
            var claimRequest = {
                "Method": "GET",
                "Domain": "http://172.17.202.192:12666",  // TODO: Pass this dynamically or do some munging with the URLs
                "Resource": claimSources[item]
            };
            
            // TODO: exception handling here, the domain or resource maybe missing
            var encodedResponse = TykMakeHttpRequest(JSON.stringify(claimRequest));
            var decodedResponse = JSON.parse(encodedResponse);
            claimResponses[item] = decodedResponse;
        }
        //log("claim responses "+JSON.stringify(claimResponses));
        
        for (var item in claimResponses) {
            request.SetHeaders["X-Claim-"+item.replace(/_/g, "-").toUpperCase()] = claimResponses[item].Body;
        }
        request.SetHeaders["AWESOME"] = "POSSUM";
        request.Headers["HAWESOME"] = "HPOSSUM";
        log("request headers "+JSON.stringify(request.Headers));
    }
    
    // MUST return both the request and session
    return oidcDistributedClaimsConduitMiddleware.ReturnData(request, session.meta_data);
});

log("OIDC Distributed Claims Conduit middleware initialised");