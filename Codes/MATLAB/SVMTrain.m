function [Mdl] = SVMTrain(TrainData,TrainLabel,UniqueLabel)
T = templateSVM('Standardize',1,'KernelFunction','gaussian');
Mdl = fitcecoc(TrainData,TrainLabel,'Learners',T,'Coding','onevsone','FitPosterior',1,...
    'ClassNames',UniqueLabel,...
    'Verbose',2);
