# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import RecursiveDict

__author__ = 'asaskevich'


def main():
    d = RecursiveDict()
    d['a']['b']['c'] = [1, 2, 3]

    print(d)
    print(d['a']['b'])
    print(d['c']['a'])
    print('d' in d['a']['e'])
    d['a']['e']['d'] = 'yeah'
    print('d' in d['a']['e'])
    print(d)
    del d['a']['b']
    print(d)


if __name__ == '__main__':
    main()
