function [PreLabel]=ImageClassify(SubImage,Mdl) 

SubImgSize = size(SubImage);
SubImgNum = SubImgSize(1) * SubImgSize(2);

PreSubLabel = cell([1,SubImgNum]);

tic;
for k = 1:SubImgNum
    i = floor((k-1)/ SubImgSize(2)) + 1;
    j = mod(k-1, SubImgSize(2)) + 1;
    
    TempImage = SubImage{i, j};
    PreSubLabel{1, k} = SVMClassifier(TempImage, Mdl);
end

toc;

PreSubLabel1 = reshape(PreSubLabel, [SubImgSize(2), SubImgSize(1)]);
PreSubLabel1 = permute(PreSubLabel1,[2,1]);
PreLabel = cell2mat(PreSubLabel1);
end