# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import CustomRange

__author__ = 'asaskevich'


def main():
    print([it for it in CustomRange(10)])
    print([it for it in CustomRange(1, 5)])
    print([it for it in CustomRange(1, 10, 3)])
    print([it for it in CustomRange(1, 10, step=2)])
    print([it for it in CustomRange(1, -10, -1)])


if __name__ == '__main__':
    main()
