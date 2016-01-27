# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import cached

__author__ = 'asaskevich'


def main():
    @cached()
    def sample_1(a, b):
        return a + b

    # использование вместе с аргументами
    @cached(debug=True)
    def sample_2(a=5, b=5):
        return a * b

    # Кеширует значения аргументов args
    print('Cache args:')
    print(sample_1(10, 20))
    print(sample_1(20, 10))
    print(sample_1(10, 20))

    # Кеширует значения аргументов kwargs
    print('Cache kwargs:')
    print(sample_2(a=10, b=20))
    print(sample_2(a=20, b=10))
    print(sample_2(a=10, b=20))

    # Кеширует значения смешанных аргументов
    print('Mixed:')
    print(sample_1(10, b=20))
    print(sample_1(20, b=10))
    print(sample_1(10, b=20))


if __name__ == '__main__':
    main()
