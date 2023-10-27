import sys
import subprocess
import os
import shutil

try:
  #import aspose.words as aw
  #import aspose.slides as slides
  from docx2pdf import convert

except:
  subprocess.run(['pip', 'install', 'docx2pdf'])
  #import aspose.words as aw
  #import aspose.slides as slides
  from docx2pdf import convert

class Viewer:

  def __init__(self, path : str = ''):
    self.fPath = path
    self.fName = ''
    self.fFullName = ''
    self.fExtension = ''

  def get_file_info(self):
    if os.path.isdir(self.fPath):
      raise Exception("'path' must be file type, not directory")
    self.fFullName = os.path.split(self.fPath)[1]
    self.fName, self.fExtension = os.path.splitext(self.fFullName)

  def file_convert(self):
    if self.fExtension == '.pdf':
      shutil.move('./'+self.fFullName,'./PDF/'+self.fFullName)
    elif (self.fExtension == '.doc') | (self.fExtension == '.docx'):
      #doc = aw.Document(self.fPath)
      #doc.save('./PDF/'+os.path.join(self.fName,'.pdf'))
      inputFile = self.fPath
      outputFile = os.path.dirname(os.path.realpath(__file__))+'/PDF/'+self.fName+'.pdf'
      file = open(outputFile, "w")
      file.close()

      convert(inputFile, outputFile)
    elif (self.fExtension == '.ppt') | (self.fExtension == '.pptx'):
      print("it's PPT!!!!!!!!!!!")
      #pres = slides.Presentation(self.fPath)
      #pres.save('./PDF/'+os.path.join(self.fName,'.pdf'), slides.export.SaveFormat.PDF)
    else:
      raise Exception("Not Available File Type(Can Convert PDF,Word,PPT Type)")

  def __call__(self, path : str = ''):
    self.fPath = path
    self.get_file_info()
    self.file_convert()

  
viewer = Viewer()
viewer(path = '/Users/ryu/Desktop/정보/Korea_study_plan.docx')


