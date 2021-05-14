from appConf.models.estimatedTax import estimatedTax
from appConf.models.company import company
from appConf.models.pointMultiplier import pointMultiplier
from django.contrib import admin
from .models.user import User
from .models.activationTokens import accountActivationToken
from .models.passwordResetTokens import passwordResetToken
from .models.notification import notification
from .models.mobileActivation import mobileActivation
from .models.termsAndConditions import termsAndConditions
from .models.GeneralSettings import GeneralSettings

from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.forms import UserChangeForm

# Register your models here.

class MyUserChangeForm(UserChangeForm):
    class Meta(UserChangeForm.Meta):
        model = User

class newUser(UserAdmin):
    form = MyUserChangeForm

    fieldsets = UserAdmin.fieldsets + (
            (None, {'fields': ('phoneNumber', 
                                'userPic', 
                                'points', 
                                'billingAdress', 
                                'deliveryAdress', 
                                'billingCity',
                                'billingState',
                                'billingZipCode',
                                'billingCountry',
                                'deliveryCity',
                                'deliveryState',
                                'deliveryZipCode',
                                'deliveryCountry',
                                'billingMobileNumber',
                                'deliveryMobileNumber')}),
    )

admin.site.register(User, newUser)
admin.site.register(accountActivationToken)
admin.site.register(passwordResetToken)
admin.site.register(notification)
admin.site.register(mobileActivation)


class termsAndConditionsModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        base_has_permission = super(termsAndConditionsModelAdmin, self).has_add_permission(request)
        return base_has_permission and not termsAndConditions.objects.exists()

admin.site.register(termsAndConditions, termsAndConditionsModelAdmin)


class pointMultiplierModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        base_has_permission = super(pointMultiplierModelAdmin, self).has_add_permission(request)
        return base_has_permission and not pointMultiplier.objects.exists()

admin.site.register(pointMultiplier, pointMultiplierModelAdmin)

class companyPositionModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        base_has_permission = super(companyPositionModelAdmin, self).has_add_permission(request)
        return base_has_permission and not company.objects.exists()

admin.site.register(company, companyPositionModelAdmin)


class estimatedTaxModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        base_has_permission = super(estimatedTaxModelAdmin, self).has_add_permission(request)
        return base_has_permission and not estimatedTax.objects.exists()

admin.site.register(estimatedTax, estimatedTaxModelAdmin)

class generalSettingsModelAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        base_has_permission = super(generalSettingsModelAdmin, self).has_add_permission(request)
        return base_has_permission and not GeneralSettings.objects.exists()

admin.site.register(GeneralSettings, generalSettingsModelAdmin)
