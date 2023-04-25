
function[Traindata,Trainlabel] = data_extract(Img,Label,Position)%Img为输入向量 Label为标签 Position为寻找数据的位置
%用于更新每次的训练样本
[Row, Column, Bands] = size(Img);%获取输入图像三维
SamNum = Row * Column;%像素总数
ImgRow = reshape(Img, [SamNum, Bands]);%将三维图像矩阵重塑为二维 Row * Column行 Bands列 reshape函数重塑矩阵 重塑之后，每一列代表一个波段上的整幅图像
LabelRow = reshape(Label, [SamNum, 1]);%三维标签矩阵重塑为二维 Row * Column行 1列 按列重新组合
Traindata=ImgRow(Position,:);
Trainlabel=LabelRow(Position,:);
