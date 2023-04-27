# -*- coding:utf-8 -*-
def FindPosi(Posi, OrienNo, StepLen):
    NextPosiPoint = Posi
    if OrienNo==0:
        NextPosiPoint[1] = Posi[1] + StepLen
    elif OrienNo == 1:
        NextPosiPoint[0] = Posi[0] - StepLen
        NextPosiPoint[1] = Posi[1] + StepLen
    elif OrienNo == 2:
        NextPosiPoint[0] = Posi[0] - StepLen
    elif OrienNo == 3:
        NextPosiPoint[0] = Posi[0] - StepLen
        NextPosiPoint[1] = Posi[1] - StepLen
    elif OrienNo == 4:
        NextPosiPoint[1] = Posi[1] - StepLen
    elif OrienNo == 5:
        NextPosiPoint[1] = Posi[1] - StepLen
        NextPosiPoint[0] = Posi[0] + StepLen
    elif OrienNo == 6:
        NextPosiPoint[0] = Posi[0] + StepLen
    elif OrienNo == 7:
        NextPosiPoint[0] = Posi[0] + StepLen
        NextPosiPoint[1] = Posi[1] + StepLen

    return NextPosiPoint