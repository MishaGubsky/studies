# !/usr/bin/python
# -*- coding: utf-8 -*-
import random

from lab2 import merge_sort

__author__ = 'asaskevich'


def main():
    fname = 'd:/Work/JetBrains/PyCharm/lab_2/content/numbers.txt'
    chunk = 100
    n = 100 * chunk
    print('generate array \w len =', n)
    with open(fname, 'w') as f:
        f.writelines('{}\n'.format(random.randint(-1000000, 1000000)) for _ in range(n))
    print('array written\nsort() started')
    merge_sort(fname, chunk)
    print('sort() completed')


if __name__ == '__main__':
    main()
