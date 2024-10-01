from rest_framework import serializers
import logging
from .models.transaction import Transaction
from django.contrib.auth import get_user_model

User = get_user_model()
logger = logging.getLogger(__name__)

class UserSerializer(serializers.ModelSerializer):
    """
    Serializer for the User model.
    """
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name')


class TransactionSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Transaction
        fields = ['id','amount', 'transaction_type', 'description', 'username', 'category', 'is_fraud']

    def create(self, validated_data):
        # Check if the request context is present
        request = self.context.get('request')
        
        # If the user is authenticated, use the authenticated user
        if request and request.user.is_authenticated:
            validated_data['user'] = request.user
        else:
            # Extract the username from validated data
            username = validated_data.pop('username', None)
            if username:
                try:
                    # Get the User object based on the provided username
                    user = User.objects.get(username__iexact=username)
                    validated_data['user'] = user  # Assign the User object to validated data
                except User.DoesNotExist:
                    raise serializers.ValidationError("User with this username does not exist.")
        
        # Create the transaction with the validated data
        return super().create(validated_data)  # Call the create method of the ModelSerializer

# Optional: If you need a separate serializer just for creating transactions (without username)
class TransactionCreateSerializer(serializers.ModelSerializer):
    """
    Serializer for creating new transactions.
    """
    class Meta:
        model = Transaction
        fields = ('amount', 'description', 'category')  # 'user' field is not needed here

    def create(self, validated_data):
        # Retrieve the user from the request (assuming it's passed in the context)
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            validated_data['user'] = request.user  # Set the user to the authenticated user
        else:
            raise serializers.ValidationError("User must be authenticated to create a transaction.")
        
        return super().create(validated_data)

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']