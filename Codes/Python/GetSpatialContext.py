# -*- coding:utf-8 -*-
import numpy as np
from  GetPosLab import GetPosLab
from  GetAccomCoef import GetAccomCoef
def GetSpatialContext(Label,step):    #label:1200*1200
    print('GetSpatialContext')
    [Pos, Lab, MinPos, MinDisLab] = GetPosLab(Label, step)
    [Area, Boundary, ShallBoundary, ShallArea] = GetAccomCoef(Pos, Lab, MinDisLab)
    MaxArea = 8 * (step + 1) * 2 * (step + 1) * 2 / 2
    AreaNorm = Area / MaxArea
    BoundaryNorm = Boundary

    arrayA = np.zeros(Boundary.shape)
    #idxNonZeros1 = np.where(Boundary != 0)
    #idxZeros1 = np.where(Boundary == 0)
    #arrayA[idxNonZeros1] = 1 / Boundary[idxNonZeros1]
    #arrayA[idxZeros1] = 1###############################??????????????
    #ShallNorm =arrayA*ShallBoundary

    arrayA=1 / Boundary
    ShallNorm = arrayA * ShallBoundary

    arrayB = np.zeros(Area.shape)
   # idxNonZeros2 = np.where(Area != 0)  # 得到一个2x7的矩阵，分别对应了7个非零元素的位置
    #idxZeros2 = np.where(Area == 0)
    #arrayB[idxNonZeros2] = 1 / Area[idxNonZeros2]
    #arrayB[idxZeros2] = 1##########################?????????????
    #ShallAreaNorm = arrayB * ShallArea

    arrayB = 1 / Area
    ShallAreaNorm= arrayB * ShallArea


    MinPosNorm = MinPos / ((step + 1) * 2)
    [Row, Col] = Label.shape
    SpatialNorm = np.zeros([Row, Col, 6])
    SpatialNorm[:,:, 0] = MinPosNorm
    SpatialNorm[:,:, 1] = MinDisLab
    SpatialNorm[:,:, 4] = AreaNorm
    SpatialNorm[:,:, 5] = ShallAreaNorm
    SpatialNorm[:,:, 3] = ShallNorm
    SpatialNorm[:,:, 2] = BoundaryNorm
    print('GetSpatialContext end')
    return SpatialNorm