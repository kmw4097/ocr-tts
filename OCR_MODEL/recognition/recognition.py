import torch
import torchvision.transforms as transforms
import math
from PIL import Image
import torch.nn.functional as F
import torch.utils.data


class NormalizePAD(object):

    def __init__(self, max_size, PAD_type='right'):
        self.toTensor = transforms.ToTensor()
        self.max_size = max_size
        self.max_width_half = math.floor(max_size[2] / 2)
        self.PAD_type = PAD_type

    def __call__(self, img):
        img = self.toTensor(img)
        img.sub_(0.5).div_(0.5)
        c, h, w = img.size()
        Pad_img = torch.FloatTensor(*self.max_size).fill_(0)
        Pad_img[:, :, :w] = img  # right pad
        if self.max_size[2] != w:  # add border Pad
            Pad_img[:, :, w:] = img[:, :, w - 1].unsqueeze(2).expand(c, h, self.max_size[2] - w)

        return Pad_img

class AlignCollate(object):

    def __init__(self, imgH=32, imgW=100, keep_ratio_with_pad=False):
        self.imgH = imgH
        self.imgW = imgW
        self.keep_ratio_with_pad = keep_ratio_with_pad

    def __call__(self, batch):
        batch = filter(lambda x: x is not None, batch)
        images = batch
        if self.keep_ratio_with_pad:
            resized_max_w = self.imgW
            input_channel = 1
            transform = NormalizePAD((input_channel, self.imgH, resized_max_w))

            resized_images = []
            for image in images:
                w, h = image.size
                ratio = w / float(h)

                if math.ceil(self.imgH * ratio) > self.imgW:
                    resized_w = self.imgW
                else:
                    resized_w = math.ceil(self.imgH * ratio)

                resized_image = image.resize((resized_w, self.imgH), Image.BICUBIC)
                resized_images.append(transform(resized_image))

            image_tensors = torch.cat([t.unsqueeze(0) for t in resized_images], 0)

        return image_tensors

class ListDataset(torch.utils.data.Dataset):

    def __init__(self, image_list):
        self.image_list = image_list
        self.nSamples = len(image_list)

    def __len__(self):
        return self.nSamples

    def __getitem__(self, index):
        img = self.image_list[index]
        return Image.fromarray(img, 'L')


def cumprod(arr):
    result = [arr[0]]
    for num in arr[1:]:
        result.append(result[-1] * num)
    return result
def text_inference(crop_img_list, recognizer, converter, img_height, batch_size, device):


    coord = [item[0] for item in crop_img_list]  # text가 존재하는 bounding box((x1,y1),(x2,y1),(x2,y2),(x1,y2))
    img_list = [item[1] for item in crop_img_list]  # 실제 이미지

    #data loader
    AlignCollate_demo = AlignCollate(imgH=img_height, imgW=600, keep_ratio_with_pad=True)
    demo_data=ListDataset(img_list)
    demo_loader=torch.utils.data.DataLoader(
        demo_data,batch_size=batch_size,shuffle=False,num_workers=int(0), collate_fn=AlignCollate_demo, pin_memory=True
    )


    #text_inference
    result_with_box=[]
    result=[]

    recognizer.eval()
    with torch.no_grad():
        for img_tensor in demo_loader:
            batch_size= img_tensor.size(0)
            image= img_tensor.to(device)
            text_for_pred = torch.LongTensor(batch_size, 25 + 1).fill_(0).to(device)

            preds=recognizer(image, text_for_pred) #(배치, 시퀀스 길이, 각 위치에서 class에 대한 확률(로짓 값))
            preds_size = torch.IntTensor([preds.size(1)] * batch_size)

            #decoding
            _, preds_index = preds.max(2)
            preds_str = converter.decode(preds_index, preds_size)

            # 각 예측에 대해 확률 추출
            preds_prob = F.softmax(preds, dim=2)
            preds_max_prob, _ = preds_prob.max(dim=2)

            # 각 문자열의 신뢰점수 계산
            for pred, pred_max_prob in zip(preds_str, preds_max_prob):
                confidence_score = cumprod(pred_max_prob)[-1]
                result.append([pred, confidence_score])

    for i, zipped in enumerate(zip(coord, result)):
        box, pred = zipped
        result_with_box.append((box, pred[0], pred[1]))

    return result_with_box

