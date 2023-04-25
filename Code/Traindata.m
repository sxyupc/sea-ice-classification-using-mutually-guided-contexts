function [TrainData,TrainLabel,UniqueLabel,TrainPos_All] = Traindata_v2(Img, Label, Rate, n)
%Rate----The proportion of training samples and total samples is 0.2-2%
%get training data 获取训练数据

%将原始图像降维处理，将每个像素点根据类别不同分开，再对每个类别的像素点进行0.2%比例挑选得到用于训练的数据与标签，以及
%不同的标签类别

[Row, Column, Bands] = size(Img);%获取输入图像三维
SamNum = Row * Column;%像素总数
ImgRow = reshape(Img, [SamNum, Bands]);%将三维图像矩阵重塑为二维 Row * Column行 Bands列 reshape函数重塑矩阵 重塑之后，每一列代表一个波段上的整幅图像
LabelRow = reshape(Label, [SamNum, 1]);%三维标签矩阵重塑为二维 Row * Column行 1列 按列重新组合
%find label0-3
UniqueLabel = unique(LabelRow);%unique(A) 返回与 A 中相同的数据，但是不包含重复项,升序排列。找到每个不重复的数据
nUniqueLabel = size(UniqueLabel, 1);%统计不同标签数目 size(a,1)返回行数 nUniqueLabel为4
%number of each label
NumEveryClass = zeros(1, nUniqueLabel);%统计每个不同类别的数量

for i = 1:nUniqueLabel
    NumEveryClass(1, i) = size(find(LabelRow == UniqueLabel(i)), 1);%统计每一类别的个数
end

RateEveryClass = NumEveryClass / min(NumEveryClass);%除以每一类别个数的最小值
RateEveryClass(RateEveryClass > 3) = 3;%将大于3的都设为3 防止数量差距过大
TrainNum = ceil(min(NumEveryClass) * RateEveryClass);%获得每一类别像素个数的矩阵


TrainData = zeros(1, Bands);%初始化用于训练的数据
TrainPos_All=zeros(1,1);%初始化用于存放位置的矩阵
TrainLabel = zeros(1, 1);%初始化用于训练数据的标签
if min(NumEveryClass) > 100
    TrainNum = ceil(TrainNum * Rate);%每一类中取百分之0.2作为用于训练的数据
end

for i = 1:nUniqueLabel%分别对每一类别进行挑选
    Position = find(LabelRow == UniqueLabel(i));%找到第i类所有标签在整个标签中的位置
%     Random training data
    Temp = randperm(NumEveryClass(1, i));%randperm 将一列序号随机打乱，序号必须是整数。 获得当前类别的随机序号 获取第i类像素点的随机排列
    Train = sort(Temp(1:TrainNum(1, i)));%Train为取第i类的前0.2%进行升序排列
    
    %Fix training data position
    %Train = TrainNum(1, i)*(n-1)+1:n*TrainNum(1, i);
    
    TrainPos = Position(Train);%获取第i类选取的0.2%数据在整幅图像中的位置
    TrainData = [TrainData; ImgRow(TrainPos, :)];%拼接 得到第i类用于训练的数据
    TrainLabel = [TrainLabel; LabelRow(TrainPos, :)];%拼接 得到第i类用于训练的数据的标签
    TrainPos_All=[TrainPos_All;TrainPos];
end

TrainData = TrainData(2:end, :);%得到最终的用于训练的数据
TrainLabel = TrainLabel(2:end, :);%得到最终的训练的数据所对应的标签
TrainPos_All=TrainPos_All(2:end,:);
NumAllClass = size(TrainData, 1);%得到所有用于训练的像素点的个数

Temp = randperm(NumAllClass);%产生用于训练的数据的随机排列
TrainData = TrainData(Temp, :);%再将用于训练的数据随机打乱
TrainLabel = TrainLabel(Temp, :);%再将用于训练的数据所对应的标签随机打乱
TrainPos_All=TrainPos_All(Temp,:);%得到打乱后的对应的位置

%最终输出 TrainData为用于训练的像素点 TrainLabel为用于训练的数据标签 UniqueLabel为不同标签类别