import numpy as np
import cv2

class Load_Image:

    def __init__(self, path, img_size, stride):
        img_binary=np.fromfile(path, np.uint8)
        img=cv2.imdecode(img_binary, cv2.IMREAD_COLOR)
        self.img_original= img
        self.img_size= img_size
        self.stride= stride
        self.img=self.img_torch(img)

    def img_torch(self, img):
        img = letterbox(img, self.img_size, stride=self.stride)
        # 이미지의 색상순서를 bgr에서 rgb로 변경하고 (height, width, channels) -> (channels, height, width)로 변환
        img = img[:, :, ::-1].transpose(2, 0, 1)


        img = np.ascontiguousarray(img)
        return img

    def set_img(self):
        return self.img, self.img_original

def letterbox(img, new_shape=(640, 640), color=(114, 114, 114), auto=True, scaleFill=False, scaleup=True, stride=32):
    #원본 이미지의 비율을 유지하면서 원하는 이미지 크기에 맞게 조정하고 나머지 부분에 패딩 추가
    #변환된 이미지, 리사이징 비율, 패딩 값 반환
    shape = img.shape[:2]

    #모델 통과시 지장없는 이미지 사이즈, max_stride 받음
    if isinstance(new_shape, int): #만약에 new_shape가 int이면
        new_shape = (new_shape, new_shape)

    r = min(new_shape[0] / shape[0], new_shape[1] / shape[1]) #(새 높이/원래 이미지 높이) ,(새 너비/원래 이미지 너비)
    #ex 이미지의 원래 크기가 800*1000이면 min((640/800),(640/1000)) , r= 0.3..
    if not scaleup:
        r = min(r, 1.0)

    #패딩 계산
    ratio = r, r  # width, height ratios
    new_unpad = int(round(shape[1] * r)), int(round(shape[0] * r))
    dw, dh = new_shape[1] - new_unpad[0], new_shape[0] - new_unpad[1]  # wh padding
    dw, dh = np.mod(dw, stride), np.mod(dh, stride)  # wh padding
    dw /= 2  # divide padding into 2 sides
    dh /= 2

    if shape[::-1] != new_unpad:  # resize
        #shape[::-1], (height, width) -> (width, height)
        img = cv2.resize(img, new_unpad, interpolation=cv2.INTER_LINEAR)
    top, bottom = int(round(dh - 0.1)), int(round(dh + 0.1))
    left, right = int(round(dw - 0.1)), int(round(dw + 0.1))
    img = cv2.copyMakeBorder(img, top, bottom, left, right, cv2.BORDER_CONSTANT, value=color)  # add border
    return img
