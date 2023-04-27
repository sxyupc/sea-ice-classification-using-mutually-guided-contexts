function [Classify] = SVMClassifier(Img, Md1)
[Row, Column, Bands] = size(Img);
SamNum = Row * Column;
ImgRow = reshape(Img, [SamNum, Bands]);
[PreLabel, ~, ~, ~] = predict(Md1, ImgRow);
PreLabel = reshape(PreLabel, [Row, Column]);
Classify = PreLabel;