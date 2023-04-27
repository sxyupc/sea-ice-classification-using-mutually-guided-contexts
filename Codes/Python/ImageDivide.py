# -*- coding:utf-8 -*-
import numpy as np
def makecellX(X,numcellRow,numcellCol,RowSize, ColSize):
    numcell=numcellRow*numcellCol
    z=X.shape[-1]
    Sub = np.zeros([numcell,RowSize*ColSize,z])
    for m in range(z):
        for i in range(numcell):
            for j in range(RowSize):
                for k in range(ColSize):
                    p=int(j * RowSize + k)
                    q=int((i//6)*RowSize+j)
                    w=int((i%6)*ColSize+k)
                    Sub[i,p,m] = X[q,w,m]
    return Sub

def makecellY(X,numcellRow,numcellCol,RowSize, ColSize):
    numcell=numcellRow*numcellCol
    Sub = np.zeros([numcell,RowSize*ColSize])
    for i in range(numcell):
        for j in range(RowSize):
            for k in range(ColSize):
                p=int(j * RowSize + k)
                q=int((i//6)*RowSize+j)
                w=int((i%6)*ColSize+k)
                Sub[i,p] = X[q,w]
    return Sub

def Integrate(Edge,Step,Size):
    if Edge<Step:
        Size[-1]=Step+Edge
    else:
        Size=[Size,Edge]
    return Size

def ImageDivide(X, Y, BatchSize):
    print('divide')
    Offset = [0, 0]
    [Row, Col, XBands] = np.shape(X)
    RowStep = BatchSize[0]
    ColStep = BatchSize[1]
    NumRow = int((Row - Offset[0]) / RowStep)
    NumCol = int((Col - Offset[1]) / ColStep)
    RowSize=RowStep * np.ones([1,NumRow])
    ColSize = ColStep * np.ones([1,NumCol])
    RowEdge = Row - (NumRow * RowStep + Offset[0])
    ColEdge = Col - (NumCol * ColStep + Offset[1])
    RowSize = Integrate(RowEdge, RowStep, RowSize)
    ColSize = Integrate(ColEdge, ColStep, ColSize)
    if Offset[0] == 0 and Offset[1] != 0:
        ColSize = [Offset[1], ColSize]
    elif Offset[1] == 0 and Offset[0]!= 0:
        RowSize = [Offset[0], RowSize]
    elif Offset[1]!= 0 and Offset[0]!= 0:
        ColSize = [Offset[1], ColSize]
        RowSize = [Offset[0], RowSize]
    numcellcol=ColSize.shape[1]
    numcellrow=RowSize.shape[1]
    SubX=makecellX(X,numcellrow,numcellcol,RowStep,ColStep)
    SubY = makecellY(Y, numcellrow,numcellcol,RowStep,ColStep)
    SubY=SubY.astype(int)
    print('divide end')
    return SubX, SubY,numcellrow,numcellcol,RowStep,ColStep


