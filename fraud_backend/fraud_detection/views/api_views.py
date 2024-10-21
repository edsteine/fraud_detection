from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from fraud_detection.models.transaction import Transaction
from fraud_detection.serializers import TransactionSerializer
from django.shortcuts import get_object_or_404
from django.views import View

class HomeView(View):
    template_name = 'index.html'  # Ensure this template exists in your templates directory


# List all transactions for the authenticated user
class TransactionListView(generics.ListAPIView):
    """
    View to list all transactions for a specific authenticated user.
    """
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Return all transactions belonging to the authenticated user
        return Transaction.objects.filter(user=self.request.user)


# Create a new transaction for the authenticated user
class TransactionCreateView(generics.CreateAPIView):
    """
    View to create a new transaction for the authenticated user.
    """
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        # Pass the user object instead of the username
        serializer.save(user=self.request.user)  # Ensure the user is saved as a User object


# Retrieve details of a specific transaction
class TransactionDetailView(generics.RetrieveAPIView):
    """
    View to retrieve the details of a specific transaction for an authenticated user.
    """
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Ensure the transaction belongs to the authenticated user
        return Transaction.objects.filter(user=self.request.user)
   

class CheckFraudView(APIView):
    """
    View to check if a specific transaction is fraudulent.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, pk):
        # Retrieve the transaction by ID and ensure it belongs to the authenticated user
        transaction = get_object_or_404(Transaction, id=pk, user=request.user)
        
        print(f"transaction.is_fraud {transaction.is_fraud}")
        # Check if the transaction is marked as fraudulent
        is_fraudulent = transaction.is_fraud
        
        return Response({'is_fraudulent': is_fraudulent}, status=status.HTTP_200_OK)

    

class TransactionProcessView(APIView):
    """
    Custom view to process a transaction.
    """
    permission_classes = [IsAuthenticated]
    
    def post(self, request, pk=None):  # Accept pk as an argument
        # Assuming that the request body contains the transaction data
        serializer = TransactionSerializer(data=request.data)

        if serializer.is_valid():
            # If pk is provided, update an existing transaction; otherwise, create a new one
            if pk:
                transaction = get_object_or_404(Transaction, pk=pk)
                serializer.update(transaction, request.data)
            else:
                # Create a new transaction
                transaction = serializer.save()

            # Return the serialized transaction data including the ID
            return Response(
                {
                    "message": "Transaction processed successfully",
                    "transaction": TransactionSerializer(transaction).data  # Return serialized transaction
                },
                status=status.HTTP_201_CREATED  # 201 for a successful creation
            )
        
        # If serializer is not valid, return the errors
        return Response(
            {"errors": serializer.errors},
            status=status.HTTP_400_BAD_REQUEST  # 400 for bad request
        )

