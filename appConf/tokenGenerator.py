from django.contrib.auth.tokens import PasswordResetTokenGenerator
import six
import string
import random

class TokenGenerator(PasswordResetTokenGenerator):
    def _make_hash_value(self, user, timestamp):
        return (
            six.text_type(user.pk) + six.text_type(timestamp) +
            six.text_type(user.is_active)
        )
account_activation_token = TokenGenerator()

def generatePasswordResetToken():
    return ''.join(random.choices(string.digits, k=6))

def generatePhoneVerificationCode():
    return ''.join(random.choices(string.digits, k=6))
