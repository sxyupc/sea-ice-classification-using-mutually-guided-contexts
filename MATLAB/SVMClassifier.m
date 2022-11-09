function [Classify] = SVMClassifier(Img, Md1)
[Row, Column, Bands] = size(Img);
SamNum = Row * Column;
ImgRow = reshape(Img, [SamNum, Bands]);
%Predict,MD1 is the training parameter
[PreLabel, ~, ~, ~] = predict(Md1, ImgRow);
PreLabel = reshape(PreLabel, [Row, Column])
Classify = PreLabel;;