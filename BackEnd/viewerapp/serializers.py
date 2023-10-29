from rest_framework import serializers
from .models import Convert

class ConvertSerializer(serializers.ModelSerializer):
    class Meta:
        model = Convert
        fields = ['fileName','pdfFilePath','mp3FilePath']