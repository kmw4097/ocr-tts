from utils.general import *
from data.image_preprocessing import Load_Image

def text_detection(img, device, detection_model):
    img_size,confidence,iou= 640, 0.25, 0.25
    stride = int(detection_model.stride.max())
    img_size= check_img_size(img_size, s=stride) #stride가 2이상인 conv나 pooling layer를 거칠 때 발생하는 차원축소를 올바르게 처리하기 위해서 적용

    #이미지 로드
    image_loader= Load_Image(img, img_size, stride)
    image, img_o= image_loader.set_img()
    box_list= detection(detection_model, image, img_o, device, img_size, confidence, iou)
    return box_list, img_o


def detection(model, image, img_o, device, img_size, confidence, iou):

    # 이미지 정규화
    # numpy 배열을 tensor로 변환하고 device로 이동시킴
    img = torch.from_numpy(image).to(device)
    img = img.float()
    img /= 255.0
    if img.ndimension() == 3:
        img = img.unsqueeze(0)  # 이미지의 차원을 4차원으로 확장 [1, 채널, 높이, 너비], 4차원 배치형태의 이미지를 사용

    prediction = model(img)[0] #bounding box(x,y,w,h,confidence_score, class)

    # 중복 상자 제거
    prediction = non_max_suppression(prediction, confidence, iou, classes=None)
    detect = None
    for _, det in enumerate(prediction):
        det[:, :4] = scale_coords(img.shape[2:], det[:, :4], img_o.shape).round() #bounding box 위치 조정

    box_list = []

    for *box, conf, cls in det:

        box_list.append([int(box[0]), int(box[2]), int(box[1]), int(box[3])])  # bounding box의 좌표를 (x1,x2,y1,y2)로 바꿔서 저장

    return box_list


