clc;clear;
load('.\Image.mat');
load('.\Label.mat');
Img = SubImage;
Label = SubLabel;
[Row, Col, B] = size(Img);
ImgContext = rand(Row, Col, B+6);
ImgContext(:,:,1:B) = Img;
n = 20;
step = 20;
BatchSize = [200,200];
[TrainData_All,TrainLabel_All,UniqueLabel,TrainPos_All] = Traindata(ImgContext, Label, 0.02, n);
Proportion=size(TrainData_All,1);
TrainPos_1=TrainPos_All(((Proportion/10)*(1-1))+1:Proportion/10*5,:);
TrainPos_2=TrainPos_All((Proportion/10*(6-1))+1:Proportion/10*10,:);
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
    if i>1
         Change=length(find((PreLabelTensor(:,:,i)-PreLabelTensor(:,:,i-1))~=0))/(Row*col);
         if Change<0.03
             PreLabelTensor(:,:,i)=[];
             break
         end
    end
    ImgContext(:,:, B+1:B+6) = GetSpatialContext(PreLabelTensor(:,:,i), step);
    save('.\PreLabelTensor.mat','PreLabelTensor','-v7.3');
end