# -*- coding:utf-8 -*-

import os
import numpy as np
import h5py
from Traindata_v2 import Traindata_v2
from data_extract import data_extract
from SVMTrain import SVMTrain
from ImageDivide import ImageDivide
from ImageClassify import ImageClassify
from ImageClassify import makearr
from GetSpatialContext import GetSpatialContext
from ClassifiEvaluate import ClassifiEvaluate
import scipy


from scipy.io import loadmat
os.environ["CUDA_VISIBLE_DEVICES"] = '1'
def main():
    data_path="./dataclipno3.mat"#.mat文件路径
    data = h5py.File(data_path)#使用h5py读取文件内数据
    SubLabel=data.get('SubLabel')#取出字典里的label
    Label=np.transpose(SubLabel)#矩阵转置，与MATLAB中的矩阵保持一致
    SubImage=data.get('SubImage')#取出字典里的data
    Img=np.transpose(SubImage)#矩阵转置，与MATLAB中的矩阵保持一致
    Submap=data.get('map')#取出字典里的map
    map=np.transpose(Submap)#矩阵转置，与MATLAB中的矩阵保持一致
    [Row,Col,B]=Img.shape#获取Image中的行数 、列数以及波段数

  #  ImgContext = np.random.rand(Row, Col, B+6)#初始化输入向量

  #  ImgContext[:,:,0:B] = Img#拼接原始图像至输入向量 输入向量前三维代表原始的图像 后六维的每一维代表整幅图像的每个像素点当前的参数值
    n=20#n没用到
    nIt =1#迭代次数10******************************************************************************************
    PreLabelTensor = np.zeros([Row, Col, nIt])#初始化预测得到的标签
    ImgContextTensor = np.zeros([Row, Col, B+6, nIt])#初始化预测得到的图像
    step = 20
    BatchSize = [200,200]#图像切分大小\
 #   [TrainData_All,TrainLabel_All,UniqueLabel,TrainPos_All] = Traindata_v2(ImgContext, Label, 0.02, n)#从上一代预测得到的输入向量中抽取用于训练的数据 参数n无用√

    data_path2 = "D:\desktop\TrainPos_All.mat"  # .mat文件路径
    data2 =scipy.io.loadmat(data_path2)
    TrainPos_All = data2.get('TrainPos_All')  # 取出字典里的label

    data_path3 = "D:\desktop\ImgContext.mat"  # .mat文件路径
    data3 = scipy.io.loadmat(data_path3)
    ImgContext = data3.get('ImgContext')  # 取出字典里的label

    data_path4 = "D:\desktop/UniqueLabel.mat"  # .mat文件路径
    data4 = scipy.io.loadmat(data_path4)
    UniqueLabel = data4.get('UniqueLabel')  # 取出字典里的label

    #TrainPos_All = np.array(TrainPos_All).reshape([len(TrainPos_All), 1], order='F')
#需要做的是在每一代中将提出的训练All的十分之一的六参数更新为context中六个参数
    TrainPos_1=TrainPos_All[(2542*(1-1)):2542*5]
    TrainPos_1 =np.array(TrainPos_1).reshape([len(TrainPos_1), 1], order='F')
    TrainPos_2=TrainPos_All[(2542*(6-1)):2542*10]
    TrainPos_2 = np.array(TrainPos_2).reshape([len(TrainPos_2), 1], order='F')
    for i in range(nIt):
        print('nIt=',i)
        if (i+1)%2==1 :
            [TrainData_1, TrainLabel_1] = data_extract(ImgContext, Label, TrainPos_1)
            svc= SVMTrain(TrainData_1, TrainLabel_1, i)#得到训练的ECOC分类模型
        elif (i+1)%2==0:
            [TrainData_2, TrainLabel_2] = data_extract(ImgContext, Label, TrainPos_2)
            svc = SVMTrain(TrainData_2, TrainLabel_2, UniqueLabel)#得到训练的ECOC分类模型
        [SubImage, SubLabel,numcellrow,numcellcol,RowStep,ColStep]=ImageDivide(ImgContext, Label, BatchSize)
        PreSubLabel = ImageClassify(SubImage, SubLabel,svc )
        PreSubLabel = PreSubLabel.astype(int)
        PreLabel=makearr(PreSubLabel,numcellrow,numcellcol,RowStep, ColStep)
        #PreLabel = makearr(SubLabel, numcellrow, numcellcol, RowStep, ColStep)#############################
        PreLabel=PreLabel.astype(int)
        PreLabelTensor[:,:,i]=PreLabel
        ImgContext[:,:, B: B + 6] = GetSpatialContext(PreLabelTensor[:,:, i], step)#d


    Final_Kappa,Final_CorrectRate=ClassifiEvaluate(PreLabelTensor, Label,nIt)
    print(Final_Kappa)
    print(Final_CorrectRate)

   # print(ConfuMatrix)
    print(Final_CorrectRate)

if __name__ == '__main__':
    main()
