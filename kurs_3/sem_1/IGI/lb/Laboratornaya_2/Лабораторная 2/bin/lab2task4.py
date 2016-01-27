# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import LinearFunction

__author__ = 'asaskevich'


def main():
    f = LinearFunction(1.0, -2.0)
    g = LinearFunction(k=10)
    print('f:', f)
    print('g:', g)
    print('-f:', -f)
    print('f * 5:', f * 5)
    print('f - 5:', f - 5)
    print('f * g:', f * g)
    print('f * g', f(g))
    print('f(10):', f(10))
    print('f[10]:', f[10])


if __name__ == '__main__':
    main()
