from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Convert
from .serializers import ConvertSerializer
import os
import sys

# 상위 디렉토리 모듈 접근하기 위해 경로 추가
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))

from viewer import Viewer
from OCR_MODEL import main


# Create your views here.
class ConvertView(viewsets.ModelViewSet):
    queryset = Convert.objects.all()
    serializer_class = ConvertSerializer
    my_viewer = Viewer()

    def UserFileToPDF(self, path=''):
        self.my_viewer(path = path)
        return {'fileName' : self.my_viewer.fName, 'pdfFilePath' : self.my_viewer.outputPath}
    
    def PdfFileToMp3(self, fileName = ''):
        main.run(file_name = fileName)
        return {'mp3FilePath' : main.MP3_PATH}

    # url : http://localhost:8000/convert/ConvertFile
    @action(detail=False, methods=['POST'])
    def ConvertFile(self, request):
        file_info = request.data
        filePath = file_info['filePath']
        pdfFileInfo = self.UserFileToPDF(path=filePath)
        mp3FileInfo = self.PdfFileToMp3(fileName = pdfFileInfo['fileName'])
        
        Convert.objects.create(
            fileName = pdfFileInfo['fileName'],
            pdfFilePath = pdfFileInfo['pdfFilePath'],
            mp3FilePath = mp3FileInfo['mp3FilePath']
        )

        return Response({'message' : f"File '{pdfFileInfo['fileName']}' is successfully converted"}, status=200)
    
    #http://localhost:8000/convert/GetPath
    @action(detail = False, methods=['GET'])
    def GetPath(self, request):
        request_file = request.GET['fileName']
        file_info = self.queryset.filter(fileName = request_file)
        serializer = self.get_serializer(file_info, many=True)

        return Response(serializer.data)