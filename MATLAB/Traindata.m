function [TrainData,TrainLabel,UniqueLabel] = Traindata(Img, Label, Rate, n)
%Rate----The proportion of training samples and total samples is 0.2-2%
%get training data
[Row, Column, Bands] = size(Img);
SamNum = Row * Column;
ImgRow = reshape(Img, [SamNum, Bands]);
LabelRow = reshape(Label, [SamNum, 1]);
%find label0-3
UniqueLabel = unique(LabelRow);
nUniqueLabel = size(UniqueLabel, 1);
%number of each label
NumEveryClass = zeros(1, nUniqueLabel);

for i = 1:nUniqueLabel
    NumEveryClass(1, i) = size(find(LabelRow == UniqueLabel(i)), 1);
end

RateEveryClass = NumEveryClass / min(NumEveryClass);
RateEveryClass(RateEveryClass > 3) = 3;
TrainNum = ceil(min(NumEveryClass) * RateEveryClass);


TrainData = zeros(1, Bands);
TrainLabel = zeros(1, 1);
if min(NumEveryClass) > 100
    TrainNum = ceil(TrainNum * Rate);
end

for i = 1:nUniqueLabel
    Position = find(LabelRow == UniqueLabel(i));
%     Random training data
    Temp = randperm(NumEveryClass(1, i));
    Train = sort(Temp(1:TrainNum(1, i)));
    
    %Fix training data position
    %Train = TrainNum(1, i)*(n-1)+1:n*TrainNum(1, i);
    
    TrainPos = Position(Train);
    TrainData = [TrainData; ImgRow(TrainPos, :)];
    TrainLabel = [TrainLabel; LabelRow(TrainPos, :)];
end

TrainData = TrainData(2:end, :);
TrainLabel = TrainLabel(2:end, :);

NumAllClass = size(TrainData, 1);

Temp = randperm(NumAllClass);
TrainData = TrainData(Temp, :);
TrainLabel = TrainLabel(Temp, :);

