from django.urls import path
from .views.auth_views import UserRegistrationView, LogoutView, LoginView, UserProfileView
from .views.api_views import TransactionListView, TransactionDetailView, TransactionCreateView, TransactionProcessView, CheckFraudView

urlpatterns = [
    # User authentication
    path('register/', UserRegistrationView.as_view(), name='user_registration'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    # URL patterns for transaction management
    # Route for listing all transactions
    path('transactions/', TransactionListView.as_view(), name='transaction_list'),

    # Route for creating a new transaction
    path('transactions/create/', TransactionCreateView.as_view(), name='transaction_create'),

    # Route for viewing details of a specific transaction
    path('transactions/<int:pk>/', TransactionDetailView.as_view(), name='transaction_detail'),

    # Route for processing a specific transaction
    path('transactions/<int:pk>/process/', TransactionProcessView.as_view(), name='transaction_process'),

    # Route for checking fraud on a specific transaction
    path('transactions/<int:pk>/check_fraud/', CheckFraudView.as_view(), name='check_fraud'),
]
