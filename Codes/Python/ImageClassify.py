# -*- coding:utf-8 -*-
import numpy as np
from SVMClassifier import SVMClassifier
from libsvm.python.libsvm.svmutil import *
from libsvm.python.libsvm.svm import *
def makearr(PreSubLabel,numcellRow,numcellCol,RowSize, ColSize):
    print('makearr')
    numcell=numcellRow*numcellCol
    arr= np.zeros([numcellRow*RowSize,numcellCol*ColSize])
    for i in range(numcell):
        for j in range(RowSize):
            for k in range(ColSize):
                p=int(j * RowSize + k)
                q=int((i//6)*RowSize+j)
                w=int((i%6)*ColSize+k)
                arr[q,w]=PreSubLabel[i,p]
    print('makearrend')
    return arr


def ImageClassify(SubImage,SubLabel,Mdl):
    print('classify')
    SubImgSize = SubImage.shape
    SubImgNum = SubImage.shape[0]
    SamNum=SubImage.shape[1]
    Bands=SubImage.shape[2]
    PreSubLabel=np.zeros([SubImgNum,SamNum])
    for k in range(SubImgNum):
        i = int((k ) / SubImgSize[1]) + 1
        j = (k % SubImgSize[1]) + 1
        #TempImage = SubImage[k,:,:]
        no=(i - 1) * 6 + (j - 1)
        TempImage = SubImage[no, :, :]
        TempLabel=SubLabel[no, :]
        #PreSubLabel[k,:] = SVMClassifier(TempImage, Mdl)
        PreSubLabel[k,:], p_acc, p_val = svm_predict(TempLabel, TempImage, Mdl)
    classify=PreSubLabel
    print('classify end')
    return classify