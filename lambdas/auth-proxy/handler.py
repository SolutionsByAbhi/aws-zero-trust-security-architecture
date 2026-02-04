 import  json
 import  os
import  base64
 import  logging
 from typing  import  Dict,  Any
 
logger  =  logging.getLogger()
 logger.setLevel(logging.INFO)
 
EXPECTED_ISSUER  =  os.environ.get("EXPECTED_ISSUER",  "https://example.com/")
 EXPECTED_AUDIENCE =  os.environ.get("EXPECTED_AUDIENCE",  "zt-api")
 
 def parse_jwt(token:  str)  ->  Dict[str,  Any]:
        try:
               header_b64,  payload_b64, _  =  token.split(".")
               payload_b64  +=  "="  * (-len(payload_b64)  %  4)
               payload_json  =  base64.urlsafe_b64decode(payload_b64.encode("utf-8")).decode("utf-8")
               return  json.loads(payload_json)
        except  Exception as  e:
               logger.error(f"Failed  to  parse  JWT:  {e}")
               return  {}

 def  is_authorized(claims:  Dict[str,  Any]) ->  bool:
        if  not  claims:
               return  False
        if  claims.get("iss") !=  EXPECTED_ISSUER:
               return  False
        aud  =  claims.get("aud")
        if  isinstance(aud, list):
                return EXPECTED_AUDIENCE  in  aud
        return  aud  == EXPECTED_AUDIENCE
 
 def  lambda_handler(event,  context):
        logger.info(f"Event: {json.dumps(event)}")
 
        headers  =  event.get("headers")  or {}
        auth  =  headers.get("authorization")  or  headers.get("Authorization")

        if  not  auth  or  not auth.lower().startswith("bearer  "):
               return  {
                       "isAuthorized": False,
                       "context":  {"reason": "missing_token"}
                }

        token  =  auth.split("  ",  1)[1]
        claims =  parse_jwt(token)
 
        if  not  is_authorized(claims):
               return  {
                      "isAuthorized":  False,
                      "context":  {"reason":  "invalid_token"}
               }
 
        user  = claims.get("sub",  "unknown")
 
        return  {
               "isAuthorized":  True,
               "context":  {
                      "user":  user,
                      "roles":  ",".join(claims.get("roles",  []))
               }
        }
