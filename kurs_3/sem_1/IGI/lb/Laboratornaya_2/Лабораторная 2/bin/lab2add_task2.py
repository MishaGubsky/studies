# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import Singleton

__author__ = 'asaskevich'


def main():
    class Sample(object, metaclass=Singleton):
        def __init__(self):
            print('__init__ called')
            self.num = 100

    a = Sample()
    b = Sample()

    print(a.num, b.num)

    a.num = 200
    print(a.num, b.num)


if __name__ == '__main__':
    main()
