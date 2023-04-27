
function[Traindata,Trainlabel] = data_extract(Img,Label,Position)
[Row, Column, Bands] = size(Img);
SamNum = Row * Column;
ImgRow = reshape(Img, [SamNum, Bands]);
LabelRow = reshape(Label, [SamNum, 1]);
Traindata=ImgRow(Position,:);
Trainlabel=LabelRow(Position,:);
