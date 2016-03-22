import numpy as np


def main():
    mx = []
    with open('file') as f:
        for l in f.readlines():
            mx.append(list(map(lambda x: int(x), l.replace('\n', '').split(' '))))

    c = np.matrix(mx)

    print('inputted matrix:')
    print(c)
    print('reverse_matrix:')
    print(reverse(c))


def reverse(c):
    n = len(c)
    reverse_a, a = np.eye(len(c)), np.eye(len(c))
    myDictChanges = dict()
    setColumns = set()

    iter, j = 0, 0

    while j < n:
        if j not in setColumns:
            l = reverse_a * c[:, j]
            if l[iter] != 0:
                setColumns.add(j)
                myDictChanges[j] = iter
                q_matrix = np.eye(n)

                # A
                a[:, iter:iter + 1] = l

                # l(~)
                temp_vector = np.empty_like(l)
                temp_vector[:] = l
                temp_vector[iter] = -1

                # q
                q_vector = temp_vector * (-1 / l[iter])

                # Q
                q_matrix[:, iter:iter + 1] = q_vector
                # print(q_matrix)

                # A(-1)=Q*A(-1)
                reverse_a = np.matrix(q_matrix * reverse_a)
                iter += 1
                j = 0
            else:
                j += 1
        else:
            j += 1

    newReverse_a = np.empty_like(reverse_a)

    for key in myDictChanges.values():
        newReverse_a[myDictChanges[key]] = reverse_a[key]

    return newReverse_a

    # main()
