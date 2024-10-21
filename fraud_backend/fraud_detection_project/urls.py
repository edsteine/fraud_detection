from django.contrib import admin
from django.urls import path, include
from fraud_detection.views.api_views import HomeView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', HomeView.as_view(), name='home'), 
    path('api/', include('fraud_detection.urls')),  # Include URLs from the fraud_detection app
]
