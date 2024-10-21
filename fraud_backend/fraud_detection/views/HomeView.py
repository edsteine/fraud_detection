from django.views.generic import TemplateView

class HomeView(TemplateView):
    template_name = 'index.html'  # Point to your home template

