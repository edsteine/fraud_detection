from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('fraud_detection.urls')),  # Include URLs from the fraud_detection app
]
