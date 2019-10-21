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
    "target_url": "'"${LOCAL_CANDIG_SERVER}"'",
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
     "post": [
        {
          "name": "oidcDistributedClaimsConduitMiddleware",
          "path": "/opt/tyk-gateway/middleware/oidcDistributedClaimsConduitMiddleware.js",
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
    "SESSION_ENDPOINTS": [
        "/",
        "/gene_search",
        "/patients_overview",
        "/sample_analysis",
        "/custom_visualization",
        "/api_info",
        "/serverinfo"
      ],
      "TYK_SERVER": "'"${CANDIG_PUBLIC_URL}${CD_PUB_PORT}"'"
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

export API_DB_ID=$(echo $ret_val | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["Meta"])')
export API_DEF=$(curl --silent --header "authorization: $USER_AUTH" \
  http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/$API_DB_ID \
  |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(json.dumps(obj["api_definition"]))')
export API_ID=$(echo $API_DEF |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["api_id"])')
export API_ID=$(echo $API_DEF |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["api_id"])')

echo API ID: $API_ID


VARAUTHAPI='{
  "api_model": {},
  "api_definition": {
    "api_id": "",
    "jwt_issued_at_validation_skew": 0,
    "upstream_certificates": {},
    "use_keyless": true,
    "enable_coprocess_auth": false,
    "base_identity_provided_by": "",
    "custom_middleware": {
      "pre": [],
      "post": [],
      "post_key_auth": [],
      "auth_check": {
        "name": "",
        "path": "",
        "require_session": false
      },
      "response": [],
      "driver": "",
      "id_extractor": {
        "extract_from": "",
        "extract_with": "",
        "extractor_config": {}
      }
    },
    "disable_quota": false,
    "custom_middleware_bundle": "",
    "cache_options": {
      "cache_timeout": 60,
      "enable_cache": true,
      "cache_all_safe_requests": false,
      "cache_response_codes": [],
      "enable_upstream_cache_control": false,
      "cache_control_ttl_header": ""
    },
    "enable_ip_blacklisting": false,
    "tag_headers": [],
    "pinned_public_keys": {},
    "expire_analytics_after": 0,
    "domain": "",
    "openid_options": {
      "providers": [],
      "segregate_by_client": false
    },
    "jwt_policy_field_name": "",
    "jwt_default_policies": [],
    "active": true,
    "jwt_expires_at_validation_skew": 0,
    "config_data": {
      "KC_RTYPE": "code",
      "KC_REALM": "'"${KC_REALM}"'",
      "KC_CLIENT_ID": "'"${KC_CLIENT_ID}"'",
      "KC_SERVER": "'"${KC_PUBLIC_URL}${KC_PUB_PORT}"'",
      "KC_SCOPE": "openid+email",
      "KC_RMODE": "query",
      "USE_SSL": false,
      "KC_SECRET": "'"${KC_SECRET}"'",
      "TYK_SERVER": "'"${CANDIG_PUBLIC_URL}${CD_PUB_PORT}"'",
      "MAX_TOKEN_AGE": 43200
    },
    "notifications": {
      "shared_secret": "",
      "oauth_on_keychange_url": ""
    },
    "jwt_client_base_field": "",
    "auth": {
      "use_param": false,
      "param_name": "",
      "use_cookie": false,
      "cookie_name": "",
      "auth_header_name": "",
      "use_certificate": false,
      "validate_signature": false,
      "signature": {
        "algorithm": "",
        "header": "",
        "secret": "",
        "allowed_clock_skew": 0,
        "error_code": 0,
        "error_message": ""
      }
    },
    "check_host_against_uptime_tests": false,
    "auth_provider": {
      "name": "",
      "storage_engine": "",
      "meta": {}
    },
    "blacklisted_ips": [],
    "hmac_allowed_clock_skew": -1,
    "dont_set_quota_on_create": false,
    "uptime_tests": {
      "check_list": [],
      "config": {
        "expire_utime_after": 0,
        "service_discovery": {
          "use_discovery_service": false,
          "query_endpoint": "",
          "use_nested_query": false,
          "parent_data_path": "",
          "data_path": "",
          "cache_timeout": 60
        },
        "recheck_wait": 0
      }
    },
    "enable_jwt": false,
    "do_not_track": false,
    "name": "Authentication",
    "slug": "authentication",
    "oauth_meta": {
      "allowed_access_types": [],
      "allowed_authorize_types": [],
      "auth_login_redirect": ""
    },
    "CORS": {
      "enable": false,
      "max_age": 24,
      "allow_credentials": false,
      "exposed_headers": [],
      "allowed_headers": [],
      "options_passthrough": false,
      "debug": false,
      "allowed_origins": [],
      "allowed_methods": []
    },
    "event_handlers": {
      "events": {}
    },
    "proxy": {
      "target_url": "'"${LOCAL_CANDIG_SERVER}/auth/login"'",
      "service_discovery": {
        "endpoint_returns_list": false,
        "cache_timeout": 0,
        "parent_data_path": "",
        "query_endpoint": "",
        "use_discovery_service": false,
        "_sd_show_port_path": false,
        "target_path": "",
        "use_target_list": false,
        "use_nested_query": false,
        "data_path": "",
        "port_data_path": ""
      },
      "check_host_against_uptime_tests": false,
      "transport": {
        "ssl_insecure_skip_verify": false,
        "ssl_ciphers": [],
        "ssl_min_version": 0,
        "proxy_url": ""
      },
      "target_list": [],
      "preserve_host_header": false,
      "strip_listen_path": false,
      "enable_load_balancing": false,
      "listen_path": "/auth/",
      "disable_strip_slash": false
    },
    "client_certificates": [],
    "use_basic_auth": false,
    "version_data": {
      "not_versioned": true,
      "default_version": "",
      "versions": {
        "Default": {
          "name": "Default",
          "expires": "",
          "paths": {
            "ignored": [],
            "white_list": [],
            "black_list": []
          },
          "use_extended_paths": true,
          "global_headers": {},
          "global_headers_remove": [],
          "global_size_limit": 0,
          "override_target": "",
          "extended_paths": {
            "virtual": [
              {
                "response_function_name": "logoutHandler",
                "function_source_type": "file",
                "function_source_uri": "middleware/virtualLogout.js",
                "path": "logout",
                "method": "GET",
                "use_session": false,
                "proxy_on_error": false
              },
              {
                "response_function_name": "tokenHandler",
                "function_source_type": "file",
                "function_source_uri": "middleware/virtualToken.js",
                "path": "token",
                "method": "POST",
                "use_session": false,
                "proxy_on_error": false
              },
              {
                "response_function_name": "loginHandler",
                "function_source_type": "file",
                "function_source_uri": "middleware/virtualLogin.js",
                "path": "login",
                "method": "GET",
                "use_session": false,
                "proxy_on_error": false
              }
            ],
            "do_not_track_endpoints": [
              {
                "path": "token",
                "method": "POST"
              }
            ]
          }
        }
      }
    },
    "use_standard_auth": false,
    "session_lifetime": 0,
    "hmac_allowed_algorithms": [],
    "disable_rate_limit": false,
    "definition": {
      "location": "header",
      "key": "x-api-version",
      "strip_path": false
    },
    "use_oauth2": false,
    "jwt_source": "",
    "jwt_signing_method": "",
    "jwt_not_before_validation_skew": 0,
    "jwt_identity_base_field": "",
    "allowed_ips": [],
    "org_id": "'"${ORG_ID}"'",
    "enable_ip_whitelisting": false,
    "global_rate_limit": {
      "rate": 0,
      "per": 0
    },
    "enable_context_vars": true,
    "tags": [],
    "basic_auth": {
      "disable_caching": false,
      "cache_ttl": 0,
      "extract_from_body": false,
      "body_user_regexp": "",
      "body_password_regexp": ""
    },
    "session_provider": {
      "name": "",
      "storage_engine": "",
      "meta": {}
    },
    "strip_auth_data": false,
    "id": "5dae06162c83a60001144058",
    "certificates": [],
    "enable_signature_checking": false,
    "use_openid": false,
    "internal": false,
    "jwt_skip_kid": false,
    "enable_batch_request_support": false,
    "response_processors": [],
    "use_mutual_tls_auth": false
  },
  "hook_references": [],
  "is_site": false,
  "sort_by": 0,
  "user_group_owners": [],
  "user_owners": []
}'



echo CREATING TYK AUTHENTICATION API 
ret_val=$(curl -H "Authorization: $USER_AUTH" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d "${VARAUTHAPI}" http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/ 2>&1)

export API_DB_ID=$(echo $ret_val | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["Meta"])')
export API_DEF=$(curl --silent --header "authorization: $USER_AUTH" \
  http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/$API_DB_ID \
  |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(json.dumps(obj["api_definition"]))')
export API_ID=$(echo $API_DEF |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["api_id"])')
export API_ID=$(echo $API_DEF |  python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["api_id"])')

echo API ID: $API_ID

