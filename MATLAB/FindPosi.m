function NextPosiPoint = FindPosi(Posi, OrienNo, StepLen)
NextPosiPoint = Posi;
switch OrienNo
    case 1
        NextPosiPoint(2) = Posi(2) + StepLen;
    case 2
        NextPosiPoint(1) = Posi(1) - StepLen;
        NextPosiPoint(2) = Posi(2) + StepLen;
    case 3
        NextPosiPoint(1) = Posi(1) - StepLen;
    case 4
        NextPosiPoint(1) = Posi(1) - StepLen;
        NextPosiPoint(2) = Posi(2) - StepLen;
    case 5
        NextPosiPoint(2) = Posi(2) - StepLen;
    case 6
        NextPosiPoint(2) = Posi(2) - StepLen;
        NextPosiPoint(1) = Posi(1) + StepLen;
    case 7
        NextPosiPoint(1) = Posi(1) + StepLen;
    case 8
        NextPosiPoint(1) = Posi(1) + StepLen;
        NextPosiPoint(2) = Posi(2) + StepLen;
end
end