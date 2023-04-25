function [TrainData,TrainLabel,UniqueLabel,TrainPos_All] = Traindata_v2(Img, Label, Rate, n)
%Rate----The proportion of training samples and total samples is 0.2-2%
%get training data ��ȡѵ������

%��ԭʼͼ��ά������ÿ�����ص�������ͬ�ֿ����ٶ�ÿ���������ص����0.2%������ѡ�õ�����ѵ�����������ǩ���Լ�
%��ͬ�ı�ǩ���

[Row, Column, Bands] = size(Img);%��ȡ����ͼ����ά
SamNum = Row * Column;%��������
ImgRow = reshape(Img, [SamNum, Bands]);%����άͼ���������Ϊ��ά Row * Column�� Bands�� reshape�������ܾ��� ����֮��ÿһ�д���һ�������ϵ�����ͼ��
LabelRow = reshape(Label, [SamNum, 1]);%��ά��ǩ��������Ϊ��ά Row * Column�� 1�� �����������
%find label0-3
UniqueLabel = unique(LabelRow);%unique(A) ������ A ����ͬ�����ݣ����ǲ������ظ���,�������С��ҵ�ÿ�����ظ�������
nUniqueLabel = size(UniqueLabel, 1);%ͳ�Ʋ�ͬ��ǩ��Ŀ size(a,1)�������� nUniqueLabelΪ4
%number of each label
NumEveryClass = zeros(1, nUniqueLabel);%ͳ��ÿ����ͬ��������

for i = 1:nUniqueLabel
    NumEveryClass(1, i) = size(find(LabelRow == UniqueLabel(i)), 1);%ͳ��ÿһ���ĸ���
end

RateEveryClass = NumEveryClass / min(NumEveryClass);%����ÿһ����������Сֵ
RateEveryClass(RateEveryClass > 3) = 3;%������3�Ķ���Ϊ3 ��ֹ����������
TrainNum = ceil(min(NumEveryClass) * RateEveryClass);%���ÿһ������ظ����ľ���


TrainData = zeros(1, Bands);%��ʼ������ѵ��������
TrainPos_All=zeros(1,1);%��ʼ�����ڴ��λ�õľ���
TrainLabel = zeros(1, 1);%��ʼ������ѵ�����ݵı�ǩ
if min(NumEveryClass) > 100
    TrainNum = ceil(TrainNum * Rate);%ÿһ����ȡ�ٷ�֮0.2��Ϊ����ѵ��������
end

for i = 1:nUniqueLabel%�ֱ��ÿһ��������ѡ
    Position = find(LabelRow == UniqueLabel(i));%�ҵ���i�����б�ǩ��������ǩ�е�λ��
%     Random training data
    Temp = randperm(NumEveryClass(1, i));%randperm ��һ�����������ң���ű����������� ��õ�ǰ���������� ��ȡ��i�����ص���������
    Train = sort(Temp(1:TrainNum(1, i)));%TrainΪȡ��i���ǰ0.2%������������
    
    %Fix training data position
    %Train = TrainNum(1, i)*(n-1)+1:n*TrainNum(1, i);
    
    TrainPos = Position(Train);%��ȡ��i��ѡȡ��0.2%����������ͼ���е�λ��
    TrainData = [TrainData; ImgRow(TrainPos, :)];%ƴ�� �õ���i������ѵ��������
    TrainLabel = [TrainLabel; LabelRow(TrainPos, :)];%ƴ�� �õ���i������ѵ�������ݵı�ǩ
    TrainPos_All=[TrainPos_All;TrainPos];
end

TrainData = TrainData(2:end, :);%�õ����յ�����ѵ��������
TrainLabel = TrainLabel(2:end, :);%�õ����յ�ѵ������������Ӧ�ı�ǩ
TrainPos_All=TrainPos_All(2:end,:);
NumAllClass = size(TrainData, 1);%�õ���������ѵ�������ص�ĸ���

Temp = randperm(NumAllClass);%��������ѵ�������ݵ��������
TrainData = TrainData(Temp, :);%�ٽ�����ѵ���������������
TrainLabel = TrainLabel(Temp, :);%�ٽ�����ѵ������������Ӧ�ı�ǩ�������
TrainPos_All=TrainPos_All(Temp,:);%�õ����Һ�Ķ�Ӧ��λ��

%������� TrainDataΪ����ѵ�������ص� TrainLabelΪ����ѵ�������ݱ�ǩ UniqueLabelΪ��ͬ��ǩ���