# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import Vector

__author__ = 'asaskevich'


def main():
    a = Vector(1, 2, 3)
    b = Vector(3, 4, 5, 6, 7)
    print('Vector a:', a)
    print('Vector b:', b)
    print('a + b  = ', a + b)
    print('a - b  = ', a - b)
    print('a * b  = ', a * b)
    print('- a    =', - a)
    print('a + 10 = ', a + 10)
    print('a - 10 =', a - 10)
    print('a * 10 =', a * 10)


if __name__ == '__main__':
    main()
