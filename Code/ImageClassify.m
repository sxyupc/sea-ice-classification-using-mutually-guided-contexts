function [PreLabel]=ImageClassify(SubImage,Mdl) 
%Classify updatas Classify4
%If Optical.Md1 exist, the classify sample select at the entire image 
% and the model = 1
%the else the classify sample select at every subimg,
%then the model = 0 ,and need para Label and Rate
%
% if (~isfield(Optical,'Md1'))
%     mode = 0;
%     SubLabel = Optical.SubLabel;
%     Rate = Optical.Rate;
% else
%     mode = 1;
%     Md1 = Optical.Md1;
% end

SubImgSize = size(SubImage);
SubImgNum = SubImgSize(1) * SubImgSize(2);

PreSubLabel = cell([1,SubImgNum]);

tic;
%if mode == 1
for k = 1:SubImgNum
    i = floor((k-1)/ SubImgSize(2)) + 1;
    j = mod(k-1, SubImgSize(2)) + 1;
    %select image block
    TempImage = SubImage{i, j};
    %TempImage = TempImage(:,:,1:4);
    PreSubLabel{1, k} = SVMClassifier(TempImage, Mdl);
    %PreSubLabel{1, k} = libSVMClassifier(TempImage, Mdl);
end
% else
%     parfor k = 1:SubImgNum
%         i = floor((k-1)/ SubImgSize(2)) + 1;
%         j = mod(k-1, SubImgSize(2)) + 1;
%         
%         TempImage = SubImage{i, j};
%         %TempImage = TempImage(:,:,1:4);
%         PreSubLabel{1, k} = classifier4(TempImage, SubLabel{i, j}, Rate);
%     end
toc;
%end

PreSubLabel1 = reshape(PreSubLabel, [SubImgSize(2), SubImgSize(1)]);
PreSubLabel1 = permute(PreSubLabel1,[2,1]);
PreLabel = cell2mat(PreSubLabel1);
end