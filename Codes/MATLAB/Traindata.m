function [TrainData,TrainLabel,UniqueLabel,TrainPos_All] = Traindata(Img, Label, Rate, n)

[Row, Column, Bands] = size(Img);
SamNum = Row * Column;
ImgRow = reshape(Img, [SamNum, Bands]);
LabelRow = reshape(Label, [SamNum, 1]);
UniqueLabel = unique(LabelRow);
nUniqueLabel = size(UniqueLabel, 1);
NumEveryClass = zeros(1, nUniqueLabel);

for i = 1:nUniqueLabel
    NumEveryClass(1, i) = size(find(LabelRow == UniqueLabel(i)), 1);
end

RateEveryClass = NumEveryClass / min(NumEveryClass);
RateEveryClass(RateEveryClass > 3) = 3;
TrainNum = ceil(min(NumEveryClass) * RateEveryClass);

TrainData = zeros(1, Bands);
TrainPos_All=zeros(1,1);
TrainLabel = zeros(1, 1);
if min(NumEveryClass) > 100
    TrainNum = ceil(TrainNum * Rate);
end

for i = 1:nUniqueLabel
    Position = find(LabelRow == UniqueLabel(i));
    Temp = randperm(NumEveryClass(1, i));
    Train = sort(Temp(1:TrainNum(1, i)));
    
    TrainPos = Position(Train);
    TrainData = [TrainData; ImgRow(TrainPos, :)];
    TrainLabel = [TrainLabel; LabelRow(TrainPos, :)];
    TrainPos_All=[TrainPos_All;TrainPos];
end

TrainData = TrainData(2:end, :);
TrainLabel = TrainLabel(2:end, :);
TrainPos_All=TrainPos_All(2:end,:);
NumAllClass = size(TrainData, 1);

Temp = randperm(NumAllClass);
TrainData = TrainData(Temp, :);
TrainLabel = TrainLabel(Temp, :);
TrainPos_All=TrainPos_All(Temp,:);
