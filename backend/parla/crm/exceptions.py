from rest_framework.exceptions import APIException
from django.conf import settings
class UpgradeRequired(APIException):
    status_code = 426
    default_detail = settings.UPGRADE_REQUIRED_MESSAGE
    default_code = 'upgrade_required'