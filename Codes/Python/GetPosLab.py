# -*- coding:utf-8 -*-
import numpy as np
from scipy import stats
from itertools import chain
from FindPosi import FindPosi
def ordfilt2(Img, no):
    img_h = Img.shape[0]
    img_w = Img.shape[1]
    m, n = 3, 3
    #kernalMean = np.ones((m, n), np.float32)  # 生成盒式核
    # 边缘填充
    hPad = int((m - 1) / 2)
    wPad = int((n - 1) / 2)
    imgPad = np.pad(Img, ((hPad, m - hPad - 1), (wPad, n - wPad - 1)), mode="symmetric")
    Filter = np.zeros(Img.shape)
    for i in range(img_h):
        for j in range(img_w):
            pad = imgPad[i:i + m, j:j + n]
            pad = list(chain.from_iterable(pad))
            pad.sort()
            Filter[i, j] = pad[no]
    return Filter

def ModeFilt2(Img):
    [Row, Col] = Img.shape
    TensorModeLabel = np.ones([Row, Col, 9])

    for i in range(9):
        TensorModeLabel[:,:, i] = ordfilt2(Img, i)
    ModeLabel = stats.mode(TensorModeLabel,2)[0]###############################???????????????????????
    ModeLabel1=ModeLabel[:,:,0]
    return ModeLabel1

def IsOutImgRange(PosiPoint,ImgRange):
    if  (PosiPoint[0]+1) >=1 and (PosiPoint[0]+1) <= ImgRange[0] and (PosiPoint[1]+1) >=1 and (PosiPoint[1]+1) <= ImgRange[1]:
        OffLimits = 1
  #      return OffLimits
    else:
        OffLimits = 0
    return OffLimits

def FindDiffPoint(PosiOrien,MaxDist,Img,ModeImg):
    Posi=PosiOrien[:2]
    PosiLabel=Img[Posi[0],Posi[1]]
    OrienNo=PosiOrien[2]
    StepLen=2
   # ImgRange =np.ones([2])
    ImgRange=np.array(Img.shape)
    FrontPosi=Posi
    for i in range(MaxDist):
        NextPosi = FindPosi(FrontPosi, OrienNo, StepLen)
        OffLimits = IsOutImgRange(NextPosi, ImgRange)
        if OffLimits != 1:
            DistPoint = (MaxDist + 1) * StepLen
            LabelPoint = PosiLabel
            return DistPoint,LabelPoint
        if ModeImg[NextPosi[0], NextPosi[1]] != PosiLabel:
            DistPoint = (i+1) * StepLen
            LabelPoint = ModeImg[NextPosi[0], NextPosi[1]]
            return DistPoint,LabelPoint
        FrontPosi = NextPosi
    DistPoint = (MaxDist + 1) * StepLen
    LabelPoint = PosiLabel
    return DistPoint, LabelPoint

def GetPosLab(Img, MaxDist):
    [Row, Col] = Img.shape
    MinDis = np.ones([Row, Col])
    MinDisLab = np.ones([Row, Col])
    OrienNum = 8
    ModeImg = ModeFilt2(Img)
    AccomPosi = np.ones([Row, Col, OrienNum])
    AccomLabel = np.uint8(np.zeros([Row, Col, OrienNum]))##########################################################
    for i in range(Row):
        for j in range(Col):
            for k in range(OrienNum):
                PosiOrien=np.array([i, j, k])
                [AccomPosi[i, j, k], AccomLabel[i, j, k]] = FindDiffPoint(PosiOrien, MaxDist, Img, ModeImg)
            ind = AccomPosi[i, j, :].argsort()
            tmp = np.sort(AccomPosi[i, j, :])
            MinDis[i, j] = tmp[0]
            MinDisLab[i, j] = AccomLabel[i, j, ind[0]]
    return AccomPosi, AccomLabel, MinDis, MinDisLab