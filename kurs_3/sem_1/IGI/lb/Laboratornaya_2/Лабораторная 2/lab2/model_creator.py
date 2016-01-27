# !/usr/bin/python
# -*- coding: utf-8 -*-
import binascii
import os

__author__ = 'asaskevich'


class Field(object):
    """
    Дескриптор доступа к полю
    """

    def __init__(self, type=None, default=None):
        # имя поля, при хранении в __dict__ имеет свое уникальное имя
        self.name = binascii.b2a_hex(os.urandom(15)).decode('utf-8')
        # тип поля
        self.type = type
        # значение по умолчанию
        if default and not isinstance(default, self.type or ()):
            try:
                self.default = self.type(default)
            except:
                raise TypeError("default value must be a %s or any other type that can be casted to it" % self.type)
        else:
            self.default = default

    def __get__(self, instance, owner):
        # получение значения поля для экземпляра
        if self.name in instance.__dict__:
            return instance.__dict__[self.name]
        else:
            if self.default:
                return self.default
                # поле экземпляра появляется при инициализации
                # else:
                #     raise KeyError('field not available or hasn\'t default value')

    def __set__(self, instance, value):
        # установка поля экземпляра
        # при необходимости - приведение типов
        if not isinstance(value, self.type or ()):
            try:
                value = self.type(value)
            except:
                raise TypeError("must be a %s or any other type that can be casted to it" % self.type)
        instance.__dict__[self.name] = value

    def __name__(self):
        # имя поля дескриптора в экземпляре
        return self.name


class StringField(Field):
    """
    Строковое поле
    """

    def __init__(self, default=None):
        Field.__init__(self, str, default)


class IntField(Field):
    """
    Числовое поле - целое
    """

    def __init__(self, default=None):
        Field.__init__(self, int, default)


class BoolField(Field):
    """
    Логическое поле
    """

    def __init__(self, default=None):
        Field.__init__(self, bool, default)


class FloatField(Field):
    """
    Поле числа с плавающей запятой
    """

    def __init__(self, default=None):
        Field.__init__(self, float, default)


class ListField(Field):
    """
    Поле - список
    """

    def __init__(self, default=None):
        Field.__init__(self, list, default)


class TupleField(Field):
    """
    Поле - кортеж
    """

    def __init__(self, default=None):
        Field.__init__(self, tuple, default)


class DictField(Field):
    """
    Поле - словарь
    """

    def __init__(self, default=None):
        Field.__init__(self, dict, default)


class SetField(Field):
    """
    Поле - множество
    """

    def __init__(self, default=None):
        Field.__init__(self, set, default)


def __bases_dicts__(cls):
    # извлекает поля из всех базовых классов класса
    __dct__ = {}
    for base in cls.mro():
        __dct__ = dict(__dct__, **base.__dict__)
    return __dct__


class ModelCreator(type):
    """
    Метакласс, управляющий поведением полей
    """
    __attributes__ = {}

    def __init__(cls, what, bases, dct):
        # определение всех полей, для которых могут быть именованые аргументы
        cls.__attributes__ = dict(__bases_dicts__(cls), **dct)
        super(ModelCreator, cls).__init__(what, bases, dct)

    def __call__(cls, *args, **kwargs):
        # создание экземпляра класса
        # применение именованых аргументов к полям
        instance = super(ModelCreator, cls).__call__()
        for key, value in kwargs.items():
            if key in cls.__attributes__:
                descriptor = cls.__attributes__[key]
                instance.__dict__[descriptor.__name__()] = value
        return instance
