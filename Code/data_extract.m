
function[Traindata,Trainlabel] = data_extract(Img,Label,Position)%ImgΪ�������� LabelΪ��ǩ PositionΪѰ�����ݵ�λ��
%���ڸ���ÿ�ε�ѵ������
[Row, Column, Bands] = size(Img);%��ȡ����ͼ����ά
SamNum = Row * Column;%��������
ImgRow = reshape(Img, [SamNum, Bands]);%����άͼ���������Ϊ��ά Row * Column�� Bands�� reshape�������ܾ��� ����֮��ÿһ�д���һ�������ϵ�����ͼ��
LabelRow = reshape(Label, [SamNum, 1]);%��ά��ǩ��������Ϊ��ά Row * Column�� 1�� �����������
Traindata=ImgRow(Position,:);
Trainlabel=LabelRow(Position,:);
