# -*- coding:utf-8 -*-

import os
import numpy as np
import h5py
from Traindata_v2 import Traindata_v2
from data_extract import data_extract
from SVMTrain import SVMTrain
from ImageDivide import ImageDivide
from ImageClassify import ImageClassify
from ImageClassify import makearr
from GetSpatialContext import GetSpatialContext
from ClassifiEvaluate import ClassifiEvaluate
import scipy

a=np.random.rand(5, 5, 9)

b=np.reshape(a, [25, 9], order='F')
print(a)