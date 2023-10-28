import subprocess
import os
import shutil
import platform

USER_OS = platform.system()

# On MacOS
if USER_OS == 'Darwin':
  try:
    from docx2pdf import convert

  except:
    # if not work [pip install docx2pdf] code, you have to use this code first;
    # [brew install aljohri/-/docx2pdf]
    subprocess.run(['pip', 'install', 'docx2pdf'])
    from docx2pdf import convert

# On Windows or Linux
else:  
  try:
    import aspose.words as aw
    import aspose.slides as slides

  except:
    subprocess.run(['pip', 'install', 'aspose-words', 'aspose.slides'])
    import aspose.words as aw
    import aspose.slides as slides


class Viewer:

  def __init__(self, path : str = ''):
    self.rootDirPath = os.path.dirname(os.path.realpath(__file__))
    self.fPath = path
    self.fName = ''
    self.fFullName = ''
    self.fExtension = ''

  def get_file_info(self):
    if os.path.isdir(self.fPath):
      raise Exception("'path' must be file type, not directory")
    self.fFullName = os.path.split(self.fPath)[1]
    self.fName, self.fExtension = os.path.splitext(self.fFullName)

  def file_convert_Windows_or_Linux(self):
    if self.fExtension == '.pdf':
      shutil.move(self.rootDirPath+self.fFullName,self.rootDirPath+'/PDF/'+self.fFullName)
    elif (self.fExtension == '.doc') | (self.fExtension == '.docx'):
      doc = aw.Document(self.fPath)
      doc.save(self.rootDirPath+'/PDF/'+self.fName+'.pdf')
    elif (self.fExtension == '.ppt') | (self.fExtension == '.pptx'):
      pres = slides.Presentation(self.fPath)
      pres.save(self.rootDirPath+'/PDF/'+self.fName+'.pdf', slides.export.SaveFormat.PDF)
    else:
      raise Exception("Not Available File Type(Can Convert PDF,Word,PPT Type)")

  def file_convert_MacOS(self):
    if self.fExtension == '.pdf':
      shutil.move(self.rootDirPath+self.fFullName,self.rootDirPath+'/PDF/'+self.fFullName)
    elif (self.fExtension == '.doc') | (self.fExtension == '.docx'):
      inputFile = self.fPath
      outputFile = self.rootDirPath+'/PDF/'+self.fName+'.pdf'
      file = open(outputFile, "w")
      file.close()

      convert(inputFile, outputFile)
      
    elif (self.fExtension == '.ppt') | (self.fExtension == '.pptx'):
      raise Exception("This Function will be develped!!!!")
    else:
      raise Exception("Not Available File Type(Can Convert PDF,Word Type)")

  def __call__(self, path : str = ''):
    self.fPath = path
    self.get_file_info()
    if USER_OS == 'Darwin':
      self.file_convert_MacOS()
    else:
      self.file_convert_Windows_or_Linux()

if __name__ == '__main__':

  viewer = Viewer()
  viewer(path='')