VAR='{
      "api_definition": {
  "session_provider": {
    "meta": {},
    "name": "",
    "storage_engine": ""
  },
  "domain": "",
  "cache_options": {
    "enable_upstream_cache_control": false,
    "cache_all_safe_requests": false,
    "enable_cache": false,
    "cache_control_ttl_header": "",
    "cache_response_codes": [],
    "cache_timeout": 0
  },
  "do_not_track": false,
  "enable_signature_checking": false,
  "auth_provider": {
    "meta": {},
    "name": "",
    "storage_engine": ""
  },
  "jwt_policy_field_name": "",
  "basic_auth": {
    "disable_caching": false,
    "cache_ttl": 0
  },
  "jwt_disable_issued_at_validation": false,
  "tag_headers": [],
  "proxy": {
    "target_url": "'"${CANDIG_SERVER}"'",
    "service_discovery": {
      "target_path": "",
      "endpoint_returns_list": false,
      "use_nested_query": false,
      "use_discovery_service": false,
      "data_path": "",
      "parent_data_path": "",
      "port_data_path": "",
      "query_endpoint": "",
      "use_target_list": false,
      "cache_timeout": 0
    },
    "enable_load_balancing": false,
    "strip_listen_path": true,
    "target_list": [],
    "listen_path": "/'"${TYK_LISTEN_PATH#/}"'",
    "preserve_host_header": false,
    "check_host_against_uptime_tests": false,
    "transport": {
      "ssl_ciphers": [],
      "ssl_min_version": 0,
      "proxy_url": ""
    }
  },
  "enable_jwt": false,
  "disable_quota": false,
  "response_processors": [],
  "id": "",
  "uptime_tests": {
    "check_list": [],
    "config": {
      "expire_utime_after": 0,
      "recheck_wait": 0,
      "service_discovery": {
        "target_path": "",
        "endpoint_returns_list": false,
        "use_nested_query": false,
        "use_discovery_service": false,
        "data_path": "",
        "parent_data_path": "",
        "port_data_path": "",
        "query_endpoint": "",
        "use_target_list": false,
        "cache_timeout": 60
      }
    }
  },
  "base_identity_provided_by": "",
  "enable_ip_blacklisting": false,
  "oauth_meta": {
    "auth_login_redirect": "",
    "allowed_authorize_types": [],
    "allowed_access_types": []
  },
  "global_rate_limit": {
    "rate": 0,
    "per": 0
  },
  "tags": [],
  "jwt_disable_expires_at_validation": false,
  "jwt_client_base_field": "",
  "jwt_signing_method": "",
  "use_standard_auth": false,
  "dont_set_quota_on_create": false,
  "version_data": {
    "not_versioned": true,
    "default_version": "",
    "versions": {
      "Default": {
        "global_headers": {},
        "paths": {
          "ignored": [],
          "white_list": [],
          "black_list": []
        },
        "extended_paths": {
          "ignored": [
            {
              "path": "'"${KC_LOGIN_REDIRECT_PATH}"'",
              "method_actions": {
                "GET": {
                  "action": "no_action",
                  "headers": {},
                  "code": 200,
                  "data": ""
                }
              }
            }
          ]
        },
        "name": "Default",
        "expires": "",
        "global_headers_remove": [],
        "global_size_limit": 0,
        "use_extended_paths": true,
        "override_target": ""
      }
    }
  },
  "jwt_disable_not_before_validation": false,
  "jwt_skip_kid": false,
  "strip_auth_data": false,
  "session_lifetime": 0,
  "disable_rate_limit": false,
  "custom_middleware_bundle": "",
  "custom_middleware": {
    "pre": [
        {
          "name": "authMiddleware",
          "path": "/opt/tyk-gateway/middleware/authMiddleware.js",
          "require_session": false
        }
     ],
    "id_extractor": {
      "extract_with": "",
      "extract_from": "",
      "extractor_config": {}
    },
    "driver": "",
    "auth_check": {
      "path": "",
      "require_session": false,
      "name": ""
    },
    "post_key_auth": [],
    "post": [],
    "response": []
  },
  "api_id": "",
  "allowed_ips": [],
  "notifications": {
    "oauth_on_keychange_url": "",
    "shared_secret": ""
  },
  "use_oauth2": false,
  "config_data": {
    "tyk_host": "'"${TYK_SERVER}"'",
    "keycloak_realm": "'"${KC_REALM}"'",
    "keycloak_client": "'"${KC_CLIENT_ID}"'",
    "tyk_listen": "'"${TYK_LISTEN_PATH}"'",
    "keycloak_host": "'"${KC_SERVER}"'",
    "keycloak_secret": "'"${KC_SECRET}"'"
  },
  "openid_options": {
    "segregate_by_client": false,
    "providers": []
  },
  "CORS": {
    "max_age": 0,
    "enable": false,
    "allowed_methods": [],
    "options_passthrough": false,
    "allowed_headers": [],
    "debug": false,
    "exposed_headers": [],
    "allowed_origins": [],
    "allow_credentials": false
  },
  "active": true,
  "enable_context_vars": false,
  "slug": "candig",
  "enable_ip_whitelisting": false,
  "definition": {
    "strip_path": false,
    "location": "header",
    "key": "x-api-version"
  },
  "expire_analytics_after": 0,
  "jwt_source": "",
  "name": "'"${API_NAME}"'",
  "jwt_identity_base_field": "",
  "client_certificates": [],
  "use_keyless": false,
  "enable_batch_request_support": false,
  "upstream_certificates": {},
  "org_id": "'"${ORG_ID}"'",
  "pinned_public_keys": {},
  "use_mutual_tls_auth": false,
  "use_basic_auth": false,
  "use_openid": true,
  "hmac_allowed_clock_skew": -1,
  "auth": {
    "param_name": "",
    "use_certificate": false,
    "auth_header_name": "",
    "cookie_name": "",
    "use_cookie": false,
    "use_param": false
  },
  "blacklisted_ips": [],
  "event_handlers": {
    "events": {}
  },
  "enable_coprocess_auth": false
}
}'


echo CREATING A TYK API 
ret_val=$(curl -H "Authorization: $USER_AUTH" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d "${VAR}" http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/ 2>&1)

export API_DB_ID=$(echo $ret_val | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')
export API_DEF=$(curl --silent --header "authorization: $USER_AUTH" http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/$API_DB_ID |  python -c 'import json,sys;obj=json.load(sys.stdin);print json.dumps(obj["api_definition"])')
export API_ID=$(echo $API_DEF |  python -c 'import json,sys;obj=json.load(sys.stdin);print obj["api_id"]')

echo API ID: $API_ID




