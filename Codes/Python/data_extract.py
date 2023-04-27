# -*- coding:utf-8 -*-
import numpy as np
def data_extract(Img, Label,Position):
    [Row, Column, Bands] = Img.shape  # 获取输入图像三维
    SamNum = Row * Column  # 像素总数
    ImgRow = np.reshape(Img, [SamNum, Bands], order='F')# 将三维图像矩阵重塑为二维Row * Column行Bands列reshape函数重塑矩阵重塑之后，每一列代表一个波段上的整幅图像
    LabelRow = np.reshape(Label, [SamNum, 1], order='F')
    Position_int=np.array([Position], np.int32)
    Position=Position_int[0,:,0]
    #Position = list(map(lambda x: x - 1, Position))
    Traindata = ImgRow[Position-1,:]
    Trainlabel = LabelRow[Position-1,:]
    return Traindata,Trainlabel