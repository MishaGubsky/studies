# !/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'asaskevich'


class FilteredSequence(object):
    """
    Класс фильтрованной коллекци
    """

    def __init__(self, seq, filtr=(lambda x: True)):
        self.__seq__ = seq
        self.__filter__ = filtr

    def __iter_func__(self, func):
        for item in self.__seq__:
            if func(item):
                yield item

    def __iter__(self):
        for item in self.__iter_func__(self.__filter__):
            yield item

    def __mod__(self, func):
        """
        Оператор % фильтрует внутренную коллекцию
        :param func: фильтр
        :return: новая отфильтрованная коллекция
        """
        return [it for it in self.__iter_func__(func)]
