function [AccomPosi, AccomLabel, MinDis, MinDisLab] = GetPosLab(Img, MaxDist)

[Row, Col] = size(Img);

MinDis = ones(Row, Col);
MinDisLab = ones(Row, Col);

OrienNum = 8;

ModeImg = ModeFilt2(Img);


AccomPosi = ones(Row, Col, OrienNum);
AccomLabel = uint8(zeros(Row, Col, OrienNum));

for i = 1:Row
    for j = 1:Col
        for k = 1:OrienNum
            [AccomPosi(i, j, k),  AccomLabel(i, j, k)] = FindDiffPoint...
                ([i,j,k], MaxDist, Img, ModeImg);
            
        end
    [tmp,ind] = sort(AccomPosi(i, j, :), 'ascend');
    MinDis(i, j) = tmp(1);
    MinDisLab(i, j) = AccomLabel(i,j, ind(1));
    end
end

end

function [DistPoint, LabelPoint] = FindDiffPoint(PosiOrien, MaxDist, Img, ModeImg)
Posi = PosiOrien(1:2);
PosiLabel = Img(Posi(1),Posi(2));

OrienNo = PosiOrien(3);


StepLen = 2; 

ImgRange = size(Img);

FrontPosi = Posi;


for i = 1:MaxDist
    NextPosi = FindPosi(FrontPosi, OrienNo, StepLen);
    OffLimits = IsOutImgRange(NextPosi, ImgRange);
    if OffLimits ~= 1
        DistPoint  = (MaxDist+1) * StepLen;
        LabelPoint = PosiLabel;
        return;
    end
    if ModeImg(NextPosi(1),NextPosi(2)) ~= PosiLabel
        DistPoint  = i * StepLen;
        LabelPoint = ModeImg(NextPosi(1),NextPosi(2));
        return;
    end
    FrontPosi = NextPosi;
end
DistPoint = (MaxDist+1) * StepLen;
LabelPoint = PosiLabel;
end

function ModeLabel = ModeFilt2(Img)

[Row, Col] = size(Img);
TensorModeLabel = ones(Row,Col, 9);
for i=1:9
    TensorModeLabel(:,:,i) = ordfilt2(Img, i, ones(3,3), 'symmetric');
end
ModeLabel = mode(TensorModeLabel,3);
end



function OffLimits = IsOutImgRange(PosiPoint,ImgRange)
if PosiPoint(1) >=1 && PosiPoint(1) <= ImgRange(1) &&...
        PosiPoint(2) >=1 && PosiPoint(2) <= ImgRange(2)
    OffLimits = 1;
    return;
end
OffLimits = 0;
end