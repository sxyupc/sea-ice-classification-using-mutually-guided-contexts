# -*- coding:utf-8 -*-
import torch
import numpy as np
from scipy.io import loadmat
def find(condition):
    res = np.nonzero(condition)
    return res[0]

def Traindata_v2(Img, Label, Rate, n):
    [Row, Column, Bands] = Img.shape#获取输入图像三维
    SamNum = Row * Column#像素总数
    ImgRow = np.reshape(Img, [SamNum, Bands], order='F')#将三维图像矩阵重塑为二维 Row * Column行 Bands列 reshape函数重塑矩阵 重塑之后，每一列代表一个波段上的整幅图像

    LabelRow = np.reshape(Label, [SamNum, 1], order='F')#3维标签矩阵重塑为2维 Row * Column行 1列 按列重新组合
    UniqueLabel = np.unique(LabelRow)#返回数据，但是不包含重复项,升序排列。找到每个不重复的数据
    nUniqueLabel = UniqueLabel.shape[0]#不同的标签数目
    NumEveryClass = np.zeros([nUniqueLabel])#初始化每一类的数量
    for i in range (nUniqueLabel):      #统计每一类别的个数
        NumEveryClass[i]= np.sum(LabelRow==UniqueLabel[i])
    RateEveryClass = NumEveryClass / min(NumEveryClass)#除以每一类别个数的最小值
    RateEveryClass[RateEveryClass > 3] = 3#将大于3的都设为3 防止数量差距过大
    TrainNum = np.ceil(min(NumEveryClass) * RateEveryClass)#获得每一类别像素个数的矩阵
    TrainData = np.zeros([1, Bands])#初始化用于训练的数据
    TrainPos_All = np.zeros([1, 1])#初始化用于存放位置的矩阵
    TrainLabel = np.zeros([1, 1])#初始化用于训练数据的标签
    if min(NumEveryClass)>100:
        TrainNum =np.ceil(TrainNum * Rate) #每一类中取百分之0.2作为用于训练的数据
    for i in range(nUniqueLabel):#分别对每一类别进行挑选
        Position = find(LabelRow == UniqueLabel[i])# 找到第i类所有标签在整个标签中的位置
        Temp = torch.randperm(int(NumEveryClass[i]))#randperm将一列序号随机打乱，序号必须是整数。 获得当前类别的随机序号获取第i类像素点的随机排列

        #Temp=np.sort(Temp)###############################################################

        Train = np.sort(Temp[0:int(TrainNum[i])])#Train为取第i类的前0.2 % 进行升序排列
        TrainPos = Position[Train]#获取第i类选取的0.2 % 数据在整幅图像中的位置
        a = ImgRow[TrainPos,:]
        TrainData=np.vstack((TrainData, ImgRow[TrainPos,:]))# 拼接得到第i类用于训练的数据#######################

        TrainLabel = np.vstack((TrainLabel, LabelRow[TrainPos,:])) #拼接得到第i类用于训练的数据的标签
        TrainPos_All = np.append(TrainPos_All, TrainPos)

    TrainData = TrainData[1:,:]#得到最终的用于训练的数据
    TrainLabel = TrainLabel[1:,:]#得到最终的训练的数据所对应的标签
    TrainPos_All = TrainPos_All[1:]#
    NumAllClass = TrainData.shape[0]#得到所有用于训练的像素点的个数
    Temp = torch.randperm(NumAllClass)#产生用于训练的数据的随机排列
    TrainData = TrainData[Temp,:]# 再将用于训练的数据随机打乱
    TrainLabel = TrainLabel[Temp,:]# 再将用于训练的数据所对应的标签随机打乱
    TrainPos_All = TrainPos_All[Temp]# 得到打乱后的对应的位置
    return TrainData,TrainLabel,UniqueLabel,TrainPos_All