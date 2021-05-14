from .user import User
from .activationTokens import accountActivationToken
from .notification import notification
from .mobileActivation import mobileActivation
from .termsAndConditions import termsAndConditions
from .company import company
from .pointMultiplier import pointMultiplier
from .estimatedTax import estimatedTax
from .GeneralSettings import GeneralSettings

__all__ = [
    'User',
    'accountActivationToken',
    'notification',
    'mobileActivation',
    'termsAndConditions',
    'companyPosition',
    'pointMultiplier',
    'estimatedTax',
    'GeneralSettings'
]
try:
    if not termsAndConditions.objects.exists():
        termsAndConditions.objects.create(terms="Lorem")
except Exception:
    pass

try:
    if not pointMultiplier.objects.exists():
        pointMultiplier.objects.create(multiplier=0.5)
except Exception:
    pass

try:
    if not estimatedTax.objects.exists():
        estimatedTax.objects.create(taxPercentage=3)
except Exception:
    pass

try:
    if not GeneralSettings.objects.exists():
        GeneralSettings.objects.create()
except Exception:
    pass