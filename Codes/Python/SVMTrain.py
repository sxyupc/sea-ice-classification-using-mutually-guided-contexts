# -*- coding:utf-8 -*-
import os
from sklearn import svm
from sklearn.datasets import *
from sklearn.multiclass import OneVsRestClassifier
from sklearn import preprocessing
import numpy as np
from sklearn.svm import SVC
import pandas as pd
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.multiclass import OutputCodeClassifier
from libsvm.python.libsvm.svmutil import *
from libsvm.python.libsvm.svm import *
from sklearn.preprocessing import StandardScaler


def SVMTrain(TrainData,TrainLabel,i):
    print('SVM')

    model = svm.SVC(kernel='rbf')
    ecoc = OutputCodeClassifier(model, code_size=5, random_state=42).fit(TrainData, TrainLabel.ravel())
 #   option  = '-c 0.707 -g 0.707 -t 0'

   # model = svm_train(TrainLabel.ravel(), TrainData,option)
    
   # print(model)
    print('SVMend')
    return ecoc