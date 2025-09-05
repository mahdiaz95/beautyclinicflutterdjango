from rest_framework_simplejwt.authentication import JWTAuthentication
from .exceptions import UpgradeRequired
from django.conf import settings

class AppVersionJWTAuthentication(JWTAuthentication):
    def authenticate(self, request):
       
        user_auth_tuple = super().authenticate(request)
        if user_auth_tuple is not None:
            user, token = user_auth_tuple
            
            payload = token.payload
            
            token_version = payload.get('version')
    
            if token_version is None or token_version != settings.APP_VERSION:
                raise UpgradeRequired()
            return user_auth_tuple
        return None