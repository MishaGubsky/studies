import numpy as np

from second.second import secondPhase as second_phase


def first_phase(c, b, A):
    size = c.size + A.shape[0]


    c_new = []
    B = np.matrix(np.zeros(A.shape[0], dtype=int))
    A_new = np.matrix(np.zeros((A.shape[0], size)))
    x = np.matrix(np.zeros(size))

    #initialize

    for i in range(c.size):
        c_new.append(0)
        x[0, i] = 0
        A_new[:, i] = A[:, i]

    for i in range(A.shape[0]):
        c_new.append(-1)
        B[0, i] = c.size + i

    # if b[i] < 0
        x[0, c.size + i] = b[0, i]
        if b[0, i] < 0:
            x[0, c.size + i] *= -1
            A_new[i, :] *= -1
        A_new[i, c.size + i] = 1



    B_start = np.matrix(B, dtype=int)
    c_new = np.matrix(c_new)

    x = second_phase(c_new, B, x, A_new)

    for i in range(A_new.shape[0]):
        if x[0, B_start[0, i]] != 0:
            return 'System is not compatible!'

    j = 0
    while j < B.size:
        if B[0, j] in B_start:
            value = B[0, j]
            change_indexes(j, B, B_start, A_new)
            if value == B[0, j]:
                row = value - (A_new.shape[1] -B.size)
                A_new = remove_row(A_new, row)
                A = remove_row(A, row)
                B = remove_col(B, row)
                continue
        j += 1

    x_opt = np.matrix(x[0, 0:c.size])

    return x_opt, B


def remove_row(matrix, row):
    matrix_upd = np.matrix(np.zeros((matrix.shape[0]-1, matrix.shape[1])))
    matrix_upd[0: row, :] = matrix[0: row, :]
    matrix_upd[row:, :] = matrix[row+1:, :]
    return matrix_upd


def remove_col(matrix, col):
    matrix_upd = np.matrix(np.zeros((matrix.shape[0], matrix.shape[1]-1), dtype=int))
    matrix_upd[:, 0:col] = matrix[:, 0:col]
    matrix_upd[:, col:] = matrix[:, col+1:]
    return matrix_upd


def change_indexes(index, B, B_start, A):
    Ab = np.matrix(np.zeros((A.shape[0], B.size)))
    for i in range(B[0].size):
        Ab[:, i] = A[:, B[0, i]]

    reverse_Ab = np.linalg.inv(Ab)

    N = []
    for i in range(A.shape[1]):
        if i not in B_start:
            N.append(i)

    temp = []
    for i in N:
        if i not in B:
            l = reverse_Ab * A[:, i]
            temp.append(l[index])

    for i in temp:
        if i != 0:
            B[0, index] = i


#inputD


c, b, A = [], [], []

with open('inputForThird') as f:
    c.append(list(map(lambda x: int(x), f.readline().replace("c=", '').split(' '))))
    b.append(list(map(lambda x: int(x), f.readline().replace("b=", '').split(' '))))
    for l in f.readlines():
        A.append(list(map(lambda x: int(x), l.replace('\n', '').split(' '))))

c = np.matrix(c)
b = np.matrix(b)
A = np.matrix(A)

result = first_phase(c, b, A)
if isinstance(result, str):
    print (result)
else:
    print ('x_opt', result[0])
    print ('B', result[1])
