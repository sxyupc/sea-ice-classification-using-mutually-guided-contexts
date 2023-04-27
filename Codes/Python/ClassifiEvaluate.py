# -*- coding:utf-8 -*-
import numpy as np
from sklearn.metrics import confusion_matrix
def ClassifiEvaluate(PreLabelTensor,SubLabel,nIt):
    Final_Kappa = np.zeros([1, 10])
    Final_CorrectRate = np.zeros([1, 10])
    for j in range(nIt):
        PreLabel = PreLabelTensor[:,:, j]
        Row= SubLabel.shape[0]
        Column = SubLabel.shape[1]
        VectLabel = SubLabel.reshape([Row * Column, 1], order='F')#真实值
        VectPreLabel = PreLabel.reshape( [Row * Column, 1], order='F')# 预测值
        MatrixClassTable = np.uint8([VectLabel, VectPreLabel])
        ClassNum = np.unique(VectLabel).shape[0]
        ConfuMatrix = np.zeros([ClassNum, ClassNum])
        ConfusionMatrix = np.zeros([ClassNum + 2, ClassNum + 2])
        RowSum = np.zeros([ClassNum, 1])
        ColSum = np.zeros([1, ClassNum])
        NumSample = Row * Column
        for i in range(NumSample):
            a = ConfuMatrix[MatrixClassTable[ 0,i,0], MatrixClassTable[ 1,i,0]] + 1
            ConfuMatrix[MatrixClassTable[0,i,0] , MatrixClassTable[1,i,0] ]= a


        RowSum =np.sum(ConfuMatrix, axis=1)# 按行求和，每类真实值
        ColSum =np.sum(ConfuMatrix, axis=0)# 按列求和，每类预测值
        temp1 = 0
        for k in range(len(ConfuMatrix)):
            temp1 += ConfuMatrix[k,k]
        temp2 = np.dot(ColSum, RowSum)/ (NumSample * NumSample)
        arrayA = np.zeros(RowSum.shape)
        idxNonZeros1 = np.where(RowSum != 0)
        idxZeros1 = np.where(RowSum == 0)
        arrayA[idxNonZeros1] = 1 / RowSum[idxNonZeros1]
        arrayA[idxZeros1] = 0
        RowCorrectRate = arrayA * np.diag(ConfuMatrix) # 每类PA，列向量
        arrayB = np.zeros(ColSum.shape)
        idxNonZeros2 = np.where(ColSum != 0)  # 得到一个2x7的矩阵，分别对应了7个非零元素的位置
        idxZeros2 = np.where(ColSum == 0)
        arrayB[idxNonZeros2] = 1 / ColSum[idxNonZeros2]
        arrayB[idxZeros2] = 0
        ColCorrectRate = arrayB * np.transpose(np.diag(ConfuMatrix)) #每类UA，行向量
        CorrectRate = temp1 / NumSample#总精度
        ConfusionMatrix[0: ClassNum, 0: ClassNum] = ConfuMatrix
        ConfusionMatrix[0: ClassNum, ClassNum] = RowSum
        ConfusionMatrix[0: ClassNum, ClassNum + 1] = RowCorrectRate
        ConfusionMatrix[ClassNum , 0: ClassNum] = ColSum
        ConfusionMatrix[ClassNum + 1, 0: ClassNum] = ColCorrectRate
        ConfusionMatrix[ClassNum , ClassNum ] = NumSample
        ConfusionMatrix[ClassNum + 1, ClassNum + 1] = CorrectRate
        Kappa = (CorrectRate - temp2) / (1 - temp2)# Kappa系数

        Final_Kappa[0, j] = Kappa
        Final_CorrectRate[0, j] = CorrectRate
    return Final_Kappa,Final_CorrectRate