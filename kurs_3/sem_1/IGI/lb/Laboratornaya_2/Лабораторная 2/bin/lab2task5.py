# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import Logger

__author__ = 'asaskevich'


def main():
    logger = Logger()

    @logger(flag="SAMPLE")
    def get_list(n, m=5):
        return [i ** m for i in range(n + 1)]

    @logger(format="{fname}({args}) -> {result}")
    def get_string(n="aba", m=5):
        return n * m

    class Sample1(Logger):
        def __init__(self):
            Logger.__init__(self, format="{fname}(..) => {result}")

        def f(self, x):
            return x ** 2

        def g(self, x):
            return [x ** 2 for x in range(x + 1)]

    class Sample2(Sample1):
        def __init__(self):
            Sample1.__init__(self)

        def hello(self, x):
            return "Hello, " + x

    get_list(10)
    get_list(4, 2)
    get_string()
    get_string("hello")

    print('log from logger-decorator:')
    print(logger)

    sample1 = Sample1()
    sample1.f(20)
    sample1.g(5)

    sample2 = Sample2()
    sample2.hello("John")
    sample2.g(5)

    print('\nlog from sample1')
    print(sample1)

    print('\nlog from sample2')
    print(sample2)


if __name__ == '__main__':
    main()
