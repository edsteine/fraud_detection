from django.urls import path
from .views.auth_views import UserRegistrationView
from .views.auth_views import  LogoutView
from .views.auth_views import LoginView
from .views.auth_views import UserProfileView
from .views.api_views import TransactionListView
from .views.api_views import TransactionDetailView
from .views.api_views import  TransactionCreateView
from .views.api_views import  TransactionProcessView
from .views.api_views import  TransactionCreateView
from .views.api_views import  CheckFraudView

urlpatterns = [
    # User authentication
    path('register/', UserRegistrationView.as_view(), name='user_registration'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('profile/', UserProfileView.as_view(), name='user_profile'),
    # URL patterns for transaction management
  
    # Route for listing all transactions
    # GET /transactions/ 
    path('transactions/', TransactionListView.as_view(), name='transaction_list'),

    # Route for creating a new transaction
    # POST /transactions/create/
    path('transactions/create/', TransactionCreateView.as_view(), name='transaction_create'),

    # Route for viewing details of a specific transaction
    # GET /transactions/<int:pk>/ 
    path('transactions/<int:pk>/', TransactionDetailView.as_view(), name='transaction_detail'),

    # Route for processing a specific transaction
    # POST /transactions/<int:pk>/process/
    path('process/<int:pk>/', TransactionProcessView.as_view(), name='transaction_process'),

    # Route for checking fraud on a specific transaction
    # GET /checkFraud/<int:pk>/
    path('checkfraud/<int:pk>/', CheckFraudView.as_view(), name='check_fraud'),


    # Additional transaction-related API views can be added here
]
