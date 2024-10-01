from django import forms
from .models.user import User  # Import your User model
from .models.transaction import Transaction  # Import your Transaction model

class UserRegistrationForm(forms.ModelForm):
    """Form for user registration."""
    password = forms.CharField(widget=forms.PasswordInput)
    confirm_password = forms.CharField(widget=forms.PasswordInput)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'confirm_password']

    def clean(self):
        """Check if the passwords match."""
        cleaned_data = super().clean()
        password = cleaned_data.get("password")
        confirm_password = cleaned_data.get("confirm_password")

        if password != confirm_password:
            raise forms.ValidationError("Passwords do not match.")

class TransactionForm(forms.ModelForm):
    """Form for submitting a transaction."""
    class Meta:
        model = Transaction
        fields = ['amount', 'description', 'transaction_date', 'transaction_type']

        widgets = {
            'transaction_date': forms.DateInput(attrs={'type': 'date'}),
        }
