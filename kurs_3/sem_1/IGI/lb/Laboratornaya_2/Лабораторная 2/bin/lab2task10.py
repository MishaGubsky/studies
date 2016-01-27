# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import FilteredSequence, CustomRange

__author__ = 'asaskevich'


def main():
    seq = FilteredSequence(CustomRange(0, 100))
    for it in seq:
        print(it)
    for it in seq:
        print(it)
    print(seq % (lambda x: x % 2 and (10 < x < 50)))


if __name__ == '__main__':
    main()

