# !/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'asaskevich'


def __signum__(x):
    """
    Возвращает знак числа
    :param x: число
    :return: -1, если число меньше нуля, 1 иначе
    """
    return 1 if x >= 0 else -1


class CustomRange(object):
    """
    Класс итератора, аналогичному xrange. Предлагает неистощаемую итерабельность
    """

    def __finit__(self, start, stop, step):
        self.start, self.stop, self.step = start, stop, step
        self.__restore_start__ = self.start
        self.__restore__stop__ = self.stop
        self.__restore__step__ = self.step

    def __restore__(self):
        """
        Восстанавливает значения итератора
        :return: None
        """
        self.start, self.stop, self.step = self.__restore_start__, self.__restore__stop__, self.__restore__step__

    def __init__(self, *args, **kwargs):
        self.__finit__(0, 0, 1)
        if len(args) == 1:
            self.__finit__(0, args[0], 1)
        elif len(args) == 2:
            self.__finit__(args[0], args[1], 1)
        elif len(args) == 3:
            self.__finit__(args[0], args[1], args[2])
        self.__finit__(kwargs.get('start', self.start), kwargs.get('stop', self.stop), kwargs.get('step', self.step))
        if self.step == 0 or __signum__(self.stop - self.start) != __signum__(self.step):
            raise ValueError('infinite range')

    def __iter__(self):
        return self

    def __next__(self):
        return self.next()

    def next(self):
        if __signum__(self.step) * self.start < __signum__(self.step) * self.stop:
            cur, self.start = self.start, self.start + self.step
            return cur
        else:
            self.__restore__()
            raise StopIteration()
