from django.shortcuts import render
from rest_framework import viewsets
from .models import Convert
from .serializers import ConvertSerializer


# Create your views here.
class ConvertView(viewsets.ModelViewSet):
    queryset = Convert.objects.all()
    serializer_class = ConvertSerializer
    