clc;clear;
load('G:\SIclassification\data\case5\SubImage.mat');
load('G:\SIclassification\data\case5\SubLabel.mat');
Img = SubImage;
Label = SubLabel;
[Row, Col, B] = size(Img);
ImgContext = rand(Row, Col, B+6);%
ImgContext(:,:,1:B) = Img;
n = 20;
nIt = 8;
PreLabelTensor = zeros([Row, Col, nIt]);
ImgContextTensor = zeros(Row, Col, B+6, nIt);
step = 20;
BatchSize = [200,200];
[TrainData_All,TrainLabel_All,UniqueLabel,TrainPos_All] = Traindata_v2(ImgContext, Label, 0.02, n);%从上一代预测得到的输入向量中抽取用于训练的数据 参数n无用√
TrainPos_1=TrainPos_All((596*(1-1))+1:596*5,:);
TrainPos_2=TrainPos_All((596*(6-1))+1:596*10,:);
for i = 1:8
    if (mod(i,2)==1)
    [TrainData_1,TrainLabel_1]=data_extract(ImgContext,Label,TrainPos_1);
    Mdl = SVMTrain(TrainData_1,TrainLabel_1,UniqueLabel);
    elseif (mod(i,2)==0)
    [TrainData_2,TrainLabel_2]=data_extract(ImgContext,Label,TrainPos_2);
    Mdl = SVMTrain(TrainData_2,TrainLabel_2,UniqueLabel);
    end
    [SubImage, SubLabel] = ImageDivide(ImgContext, Label, BatchSize);
    PreLabelTensor(:,:,i) = ImageClassify(SubImage, Mdl);
    ImgContext(:,:, B+1:B+6) = GetSpatialContext(PreLabelTensor(:,:,i), step);
    save('.\PreLabelTensor.mat','PreLabelTensor','-v7.3');
end