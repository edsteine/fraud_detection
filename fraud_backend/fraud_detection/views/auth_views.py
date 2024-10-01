from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated

from fraud_detection.serializers import UserProfileSerializer


UserModel = get_user_model()

class UserRegistrationView(APIView):
    permission_classes = [AllowAny]  # Allow registration for any user

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email')

        if not username or not password or not email:
            return Response({"error": "Username, password, and email are required."},
                            status=status.HTTP_400_BAD_REQUEST)

        # Check if the user already exists
        if UserModel.objects.filter(username=username).exists():
            return Response({"error": "User with this username already exists."},
                            status=status.HTTP_400_BAD_REQUEST)

        # Create a new user
        user = UserModel(username=username, email=email)
        user.set_password(password)  # Hash the password
        user.save()

        # Optionally create an auth token for the user
        token = Token.objects.create(user=user)

        return Response({
            "message": "User registered successfully",
            "token": token.key  # Return the token to the client
        }, status=status.HTTP_201_CREATED)


class LogoutView(APIView):
    """
    Handles user logout by deleting the auth token.
    """
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def post(self, request):
        if request.user.is_authenticated:
            try:
                request.user.auth_token.delete()
                return Response({"message": "Logout successful."}, status=status.HTTP_200_OK)
            except Token.DoesNotExist:
                return Response({"error": "Token not found."}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "User is not authenticated."}, status=status.HTTP_401_UNAUTHORIZED)


class LoginView(ObtainAuthToken):
    """
    View for user login and token generation.
    """
    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)
        
        if user:
            token, created = Token.objects.get_or_create(user=user)
            return Response({'token': token.key}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        # Serialize the user data (you can include other fields as necessary)
        serializer = UserProfileSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)


