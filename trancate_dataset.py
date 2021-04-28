import numpy as np
from collections import defaultdict

def trancate_dataset(dataSizePerClass, X_train, y_train):
    numClass = len(np.unique(y_train))
    index = -1
    indexArray = defaultdict(list)
    for key in y_train.flat:
        index = index + 1
        if len(indexArray[key]) < dataSizePerClass:
            indexArray[key].append(index)
    y_train_new = np.array([0])
    X_train_new = np.zeros((dataSizePerClass*numClass, X_train.shape[1], X_train.shape[2]))
    index = -1
    for key, values in indexArray.items():
        for value in values:
            index = index + 1
            y_train_new = np.vstack((y_train_new, y_train[value]))
            h = X_train[value]
            X_train_new[index] = h
    y_train_new = y_train_new[~np.isin(np.arange(y_train_new.size), [0])]

    return X_train_new, y_train_new




if __name__ == "__main__":
    pass