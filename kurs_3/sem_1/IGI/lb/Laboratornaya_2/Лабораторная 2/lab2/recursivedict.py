# !/usr/bin/python
# -*- coding: utf-8 -*-
import numbers

__author__ = 'asaskevich'


class RecursiveDict(object):
    """
    Класс рекурсивного словара. Позволяет обращаться к элементам в виде dict[key_1][key_2]..[key_n]
    """

    def __init__(self):
        self.__values__ = {}

    def __setitem__(self, key, value):
        # установка значения по ключю
        if not isinstance(key, (str, numbers.Number)):
            raise KeyError('key should be number or string')
        self.__values__.__setitem__(key, value)

    def __len__(self):
        # возвращает размер словаря
        return len(self.__values__)

    def __contains__(self, item):
        # проверяет наличие элемента в словаре
        if item in self.__values__:
            if isinstance(self.__values__[item], RecursiveDict):
                return len(self.__values__[item])
            else:
                return True
        else:
            return False

    def __getitem__(self, key):
        # получает значение по ключю
        # если значения нет - пробует создать пустой словарь
        if key not in self.__values__:
            self.__values__.__setitem__(key, RecursiveDict())
        if not isinstance(key, (str, numbers.Number)):
            raise KeyError('key should be number or string')
        return self.__values__.__getitem__(key)

    def __delitem__(self, key):
        # удаляет ключ из словаря
        self.__values__.__delitem__(key)

    def __str__(self):
        # строковое представление
        if len(self) == 0:
            return '{}'
        return '{' + ', '.join(
            ['"' + inner_keys + '":' + str(self[inner_keys]) for inner_keys in self.__values__.keys()]) + '}'
