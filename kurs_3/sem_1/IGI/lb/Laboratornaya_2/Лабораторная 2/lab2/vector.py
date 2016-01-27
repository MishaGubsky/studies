# !/usr/bin/python
# -*- coding: utf-8 -*-
import numbers

from lab2 import CustomRange

__author__ = 'asaskevich'


class Vector(object):
    """
    Класс многомерного вектора
    """

    def __init__(self, *args):
        if len(args) == 0:
            self.values = (0, 0)
        else:
            self.values = args

    def __add__(self, other):
        # суммирует вектора или вектор с числом
        if isinstance(other, numbers.Number):
            result = tuple(a + other for a in self)
        elif isinstance(other, Vector):
            result = tuple(a + b for a, b in zip(self, other))
        else:
            raise TypeError("method is not applicable to this type")
        return Vector(*result)

    def __sub__(self, other):
        # вычисляет разность между векторами или вектором и числом
        if isinstance(other, numbers.Number):
            result = tuple(a - other for a in self)
        elif isinstance(other, Vector):
            result = tuple(a - b for a, b in zip(self, other))
        else:
            raise TypeError("method is not applicable to this type")
        return Vector(*result)

    def __neg__(self):
        # отражение вектора
        negated = tuple(-a for a in self)
        return Vector(*negated)

    def __mul__(self, other):
        # скалярное произведение векторов или произедение вектора на число
        if isinstance(other, numbers.Number):
            result = tuple(a * other for a in self)
            return Vector(*result)
        elif isinstance(other, Vector):
            result = sum(tuple(a * b for a, b in zip(self, other)))
            return result
        else:
            raise TypeError("method is not applicable to this type")

    def __eq__(self, other):
        # сравнение векторов
        if isinstance(other, Vector):
            return self.values == other.values
        else:
            raise TypeError("method is not applicable to this type")

    def __iter__(self):
        return self.values.__iter__()

    def len(self):
        # декартова длина вектора
        return sum(tuple(a ** 2 for a in self)) ** 0.5

    def __getitem__(self, key):
        return self.values[key]

    def __setitem__(self, key, value):
        # установка координаты в значение
        # если такая координата не существует - создает ее
        items = [it for it in self.values]
        if key >= 0:
            if key > len(items):
                items = items + [0 for _ in CustomRange(key - len(items))] + [value]
            elif key == len(items):
                items = items + [value]
            else:
                items[key] = value
            self.values = tuple(it for it in items)
        elif key < 0:
            raise IndexError('index in vector cannot be negative')

    def __repr__(self):
        return str(self.values)

    def __str__(self):
        return 'Vector' + repr(self)
