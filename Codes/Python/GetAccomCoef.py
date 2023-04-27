# -*- coding:utf-8 -*-
import numpy as np
from FindPosi import FindPosi
from IsSameLabel import IsSameLabel
from getarea import getarea
def GetAccomCoef(Pos, Lab, MinDisLab):
    [Row, Col, B] = Pos.shape
    Area = np.zeros([Row, Col])
    Boundary = np.zeros([Row, Col])
    ShallBoundary = np.zeros([Row, Col])
    ShallArea = np.zeros([Row, Col])
    for i in range(Row):
        for j in range(Col):
            PosCur = FindPosi([0, 0], 0, Pos[i, j, 0])
            PosCur = list(map(abs, PosCur))
            CoefCur = IsSameLabel(Lab[i, j, 0], MinDisLab[i, j])
            for k in range(2,B+1):
                PosNext = FindPosi([0, 0], k-1, Pos[i, j, k-1])
                PosNext = list(map(abs, PosNext))
                Area[i, j] = Area[i, j] + 0.5 * abs(getarea(PosNext, PosCur))
                Boundary[i, j] = Boundary[i, j] + np.linalg.norm([a-b for a,b in zip(PosNext,PosCur)], 2)
                CoefNext = IsSameLabel(Lab[i, j, k-1], MinDisLab[i, j])
                ShallBoundary[i, j] = ShallBoundary[i, j] + 0.5 * (CoefCur + CoefNext) * np.linalg.norm([a-b for a,b in zip(PosNext,PosCur)], 2)
                ShallArea[i, j] = ShallArea[i, j] + 0.5 * (CoefCur + CoefNext) * 0.5 * abs(getarea(PosNext, PosCur))
                PosCur = PosNext
                CoefCur = CoefNext
            PosNext = FindPosi([0, 0], 0, Pos[i, j, 0])
            PosNext = list(map(abs, PosNext))
            Area[i, j] = Area[i, j] + 0.5 * abs(getarea(PosNext, PosCur))
            Boundary[i, j] = Boundary[i, j] + np.linalg.norm([a-b for a,b in zip(PosNext,PosCur)], 2)
            CoefNext = IsSameLabel(Lab[i, j, 0], MinDisLab[i, j])
            ShallBoundary[i, j] = ShallBoundary[i, j] + 0.5 * (CoefCur + CoefNext) * np.linalg.norm([a-b for a,b in zip(PosNext,PosCur)], 2)
            ShallArea[i, j] = ShallArea[i, j] + 0.5 * (CoefCur + CoefNext) * 0.5 * abs(getarea(PosNext, PosCur))
    return Area, Boundary, ShallBoundary, ShallArea
