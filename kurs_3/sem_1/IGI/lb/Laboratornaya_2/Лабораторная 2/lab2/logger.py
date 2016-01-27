# !/usr/bin/python
# -*- coding: utf-8 -*-
import re

__author__ = 'asaskevich'
__format_pattern__ = '[{flag}]: {fname}({args}) = {result}'


class Logger(object):
    """
    Класс-логгер. Может быть применен к классу или функциям
    """

    def __init__(self, flag='INFO', format=__format_pattern__):
        # текущий лог
        self.__log__ = []
        self.__apply_logger__(flag, format)

    def __apply_logger__(self, flag='INFO', format=__format_pattern__):
        ignored_funcs = ['clear']
        # применяет логгер с указанным форматов вывода и флагом к открытым функциям класса
        methods = filter(lambda x: not re.match('__[\w\d]+__', x) and x not in ignored_funcs,
                         [method for method in dir(self) if callable(getattr(self, method))])
        for fname in methods:
            self.__apply_to_func__(fname, flag, format)

    def __apply_to_func__(self, fname, flag='INFO', format=__format_pattern__):
        # применяет логгер с указанным форматов вывода и флагом к заданной функции класса
        setattr(self, fname, self.__logger_decorator__(flag, format)(getattr(self, fname)))

    def __call__(self, flag='INFO', format=__format_pattern__):
        # возвращает декоратор с указанным форматов вывода и флагом
        return self.__logger_decorator__(flag, format)

    def __logging__(self, flag, fname, args, result, format=__format_pattern__):
        # записывает в лог результат вызова функции, аргументы и ее название
        self.__log__.append(format.format(flag=flag, fname=fname, args=','.join(args), result=result))

    def __str__(self):
        # возвращает строковое представление лога
        return '\n'.join(self.__log__)

    def clear(self):
        # очистка лога
        self.__log__.clear()

    def __log_call__(self, flag, func, func_args, func_kwargs, result, format=__format_pattern__):
        # логирует вызов функции - выделяет аргументы (названия, значения), результат, название функции
        arg_names = func.__code__.co_varnames[:func.__code__.co_argcount]
        args = func_args[:len(arg_names)]
        defaults = func.__defaults__ or ()
        args = args + defaults[len(defaults) - (func.__code__.co_argcount - len(args)):]
        params = list(zip(arg_names, args))
        args = func_args[len(arg_names):]
        if args:
            params.append(('args', args))
        if func_kwargs:
            params.append(('kwargs', func_kwargs))
        self.__logging__(flag, func.__name__, ['%s = %r' % p for p in params], str(result), format)

    def __logger_decorator__(self, flag='INFO', format=__format_pattern__):
        """
        Декоратор класса-логгера
        :param flag: флаг вывода - можно использовать для фильтра/тегирования
        :param format: формат вывода, можно использовать шаблоны {flag}, {fname}, {args}, {result}
        :return:
        """

        def decorator(func):
            def wrapped(*func_args, **func_kwargs):
                result = func(*func_args, **func_kwargs)
                self.__log_call__(flag, func, func_args, func_kwargs, result, format)
                return result

            return wrapped

        return decorator
