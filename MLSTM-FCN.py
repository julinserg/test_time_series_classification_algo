import csv
from keras.models import Model
from keras.layers import Input, Dense, LSTM, multiply, concatenate, Activation, Masking, Reshape
from keras.layers import Conv1D, BatchNormalization, GlobalAveragePooling1D, Permute, Dropout

import sys
sys.path.append('../MLSTM-FCN/')

from pyUtilsForMLSTM.constants import MAX_NB_VARIABLES, NB_CLASSES_LIST, MAX_TIMESTEPS_LIST
from pyUtilsForMLSTM.keras_utils import train_model, evaluate_model, set_trainable
from pyUtilsForMLSTM.layer_utils import AttentionLSTM


import matplotlib.pyplot as plt
from typing import NamedTuple
import os
import generate_dataset


def generate_model_2():
    ip = Input(shape=(MAX_NB_VARIABLE, MAX_TIMESTEPS))
    # stride = 10

    # x = Permute((2, 1))(ip)
    # x = Conv1D(MAX_NB_VARIABLE // stride, 8, strides=stride, padding='same', activation='relu', use_bias=False,
    #            kernel_initializer='he_uniform')(x)  # (None, variables / stride, timesteps)
    # x = Permute((2, 1))(x)

    #ip1 = K.reshape(ip,shape=(MAX_TIMESTEPS,MAX_NB_VARIABLE))
    #x = Permute((2, 1))(ip)
    x = Masking()(ip)
    x = AttentionLSTM(8)(x)
    x = Dropout(0.8)(x)

    y = Permute((2, 1))(ip)
    y = Conv1D(128, 8, padding='same', kernel_initializer='he_uniform')(y)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)
    y = squeeze_excite_block(y)

    y = Conv1D(256, 5, padding='same', kernel_initializer='he_uniform')(y)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)
    y = squeeze_excite_block(y)

    y = Conv1D(128, 3, padding='same', kernel_initializer='he_uniform')(y)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)

    y = GlobalAveragePooling1D()(y)

    x = concatenate([x, y])

    out = Dense(NB_CLASS, activation='softmax')(x)

    model = Model(ip, out)
    model.summary()

    # add load model code here to fine-tune

    return model


def squeeze_excite_block(input):
    ''' Create a squeeze-excite block
    Args:
        input: input tensor
        filters: number of output filters
        k: width factor

    Returns: a keras tensor
    '''
    filters = input._keras_shape[-1] # channel_axis = -1 for TF

    se = GlobalAveragePooling1D()(input)
    se = Reshape((1, filters))(se)
    se = Dense(filters // 16,  activation='relu', kernel_initializer='he_normal', use_bias=False)(se)
    se = Dense(filters, activation='sigmoid', kernel_initializer='he_normal', use_bias=False)(se)
    se = multiply([input, se])
    return se


#groupDATA = {'ArticularyWordRecognition' : 0, 'AtrialFibrillation' : 1, 'BasicMotions' : 2,
#'CharacterTrajectories' : 3, 'Cricket' : 4, 'EigenWorms' : 5, 'Epilepsy' : 6, 'EthanolConcentration' : 7,
#'ERing' : 8, 'FingerMovements' : 8, 'HandMovementDirection' : 10, 'Handwriting' : 11, 'Heartbeat' : 12, 'JapaneseVowels' : 13,
#'Libras' : 14, 'LSST' : 15, 'NATOPS' : 16, 'PenDigits' : 17, 'PEMS-SF' : 18, 'RacketSports' : 19,
#'SelfRegulationSCP1' : 20, 'SelfRegulationSCP2' : 21, 'SpokenArabicDigits' : 22,
#'StandWalkJump' : 23, 'UWaveGestureLibrary' : 24}


if not os.path.exists('weights'):
    os.makedirs('weights')

INDEX_DATASETS_LIST = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for INDEX_DATASET in INDEX_DATASETS_LIST:
    DATA = ('ArticularyWordRecognition' + '-' + str(INDEX_DATASET) , 0 + (INDEX_DATASET-1)*25)

    TRAINFOLDSIZE  = [ 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 30, 35, 40, 45, 50]

    dataIndex = 0
    RESULT_ACCURACY = []
    DATASET_NAME= DATA[0]
    DATASET_INDEX = DATA[1]
    stopFlag = False
    for dataSizePerClass in TRAINFOLDSIZE:
        if stopFlag == True:
            RESULT_ACCURACY.append(0)
            continue
        stopFlag = generate_dataset.generate_dataset(dataSizePerClass,'./Multivariate_mat_for_mlstm/{dataName}_MLSTM.mat'.format(dataName = DATASET_NAME),
                                          './numPyData/{dataName}/'.format(dataName = DATASET_NAME))

        MAX_TIMESTEPS = MAX_TIMESTEPS_LIST[DATASET_INDEX]
        MAX_NB_VARIABLE = MAX_NB_VARIABLES[DATASET_INDEX]
        NB_CLASS = NB_CLASSES_LIST[DATASET_INDEX]

        TRAINABLE = True
        model = generate_model_2()

        train_model(model, DATASET_INDEX, dataset_prefix=DATASET_NAME, epochs=1000, batch_size=128)

        accuracy, loss = evaluate_model(model, DATASET_INDEX, dataset_prefix=DATASET_NAME, batch_size=128)
        RESULT_ACCURACY.append(accuracy)

    with open('AccuracySeqMLSTM-FCN({dataName}).csv'.format(dataName = DATASET_NAME), 'w', newline='') as f:

        write = csv.writer(f)

        headerCsv = ['NameDataSet']
        for dataSizePerClass in TRAINFOLDSIZE:
            headerCsv.append(str(dataSizePerClass))

        accuracyCsv = [DATASET_NAME]
        for ac in RESULT_ACCURACY:
            accuracyCsv.append(str(ac))

        write.writerow(headerCsv)
        write.writerow(accuracyCsv)