import sys
import os
import subprocess

from detect.detection import text_detection
from recognition.model import RecogModel
from TTS.tts import run_tts, make_ssml
from utils.util import sorting_bounding_box
from utils.general import *
from data.image_preprocessing import Load_Image
import glob

from pathlib import Path
model_dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(model_dir)
try:
    import torch

    # if not work [pip install pdf2image] code, you have to use this code first;
    # [brew install poppler] or [conda install -c conda-forge poppler]
    from pdf2image import convert_from_path
    from pyssml.PySSML import PySSML
    from yolov5.models.experimental import attempt_load
except:
    subprocess.run([sys.executable, '-m', 'pip', 'install',
                    'torch', 'pdf2image', 'pyssml', 'yolov5'])
    import torch
    from pdf2image import convert_from_path
    from pyssml.PySSML import PySSML
    from yolov5.models.experimental import attempt_load



def run():
    #device 설정
    device = torch.device(0 if torch.cuda.is_available() else 'cpu')

    # pdf,img 디렉토리
    model_dir = os.path.dirname(os.path.realpath(__file__))
    top_dir = Path(model_dir).parent

    pdf_dir= str(top_dir) + '/PDF'
    img_dir= model_dir + '/images'

    #pdf->image
    for pdf in os.listdir(pdf_dir):
        if pdf =='.DS_Store':
            continue
        pages = convert_from_path(os.path.join(pdf_dir,pdf), dpi=600, poppler_path=model_dir+'/poppler-23.08.0/Library/bin')
        for j, page in enumerate(pages):
            page.save(f'{img_dir}/{os.path.basename(pdf)[:-4]}_page{j + 1:0>2d}.png')


    #detection model setting
    detection_weight= Path(model_dir +'/detect/best.pt')
    detection_model = attempt_load(detection_weight,device)


    #recognition model setting
    recognition_weight= Path(model_dir +'/recognition/iter_150000_aihub_4000_pretrained.pth')
    recognition_model=RecogModel(recognition_weight)



    #Inference
    for img_o in os.listdir(img_dir):
        bbox_list = []
        pred_list = []
        #detection
        box_list, img=text_detection(os.path.join(img_dir,img_o), device, detection_model)

        #recognition
        result= recognition_model.recognize(img, box_list)

        if result is None:
            print('no result for {img_o}')
            continue

        log = open(model_dir +'/log_demo_result.txt', 'a')
        dashed_line = '-' * 80
        head = f'\t{"predicted_labels":25s}\tconfidence score'

        #print(f'{dashed_line}\n{head}\n{dashed_line}')
        log.write(f'{dashed_line}\n{head}\n{dashed_line}\n')


        for item in result:
            bbox, pred, confidence_score= item
            bbox_list.append([pred, bbox])
            pred_list.append(pred)
            #print(f'{pred:25s}\t{confidence_score:0.4f}\n')
            #log.write(f'{pred:25s}\t{confidence_score:0.4f}\n')

        sorted_bbox_list = sorting_bounding_box(bbox_list)
        # print(sorted_bbox_list)

        # tts ssml version
        ssml_doc = make_ssml(sorted_bbox_list)
        # print(ssml_doc)
        # run_tts(ssml_doc, str(top_dir)+'/MP3/'+img_o[:-4]+'_ssml' + '.mp3')


    for file in os.listdir(img_dir):
        os.remove(img_dir+"/{}".format(file))

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    run()
# See PyCharm help at https://www.jetbrains.com/help/pycharm/
