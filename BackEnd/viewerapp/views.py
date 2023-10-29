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

import viewer



# Create your views here.
class ConvertView(viewsets.ModelViewSet):
    queryset = Convert.objects.all()
    serializer_class = ConvertSerializer
    my_viewer = viewer.Viewer()
    def UserFileToPDF(self, path=''):
        self.my_viewer(path)

        return {'fileName' : self.my_viewer.fName, 'pdfFilePath' : self.my_viewer.outputPath}
    
    def PdfFileToMp3(self):
        return {'mp3FilePath' : ''}

    @action(detail=False, methods=['GET'])
    def ConvertFile(self, request):
        file_info = request.data
        filePath = file_info['filePath']
        print('file path : {}'.format(filePath))
        pdfFileInfo = self.UserFileToPDF(path=filePath)
        mp3FileInfo = self.PdfFileToMp3()
        serializer = ConvertSerializer({
            'fileName' : pdfFileInfo['fileName'],
            'pdfFilePath' : pdfFileInfo['pdfFilePath'],
            'mp3FilePath' : mp3FileInfo['mp3FilePath']
        }, many=True)

        return Response(serializer.data)