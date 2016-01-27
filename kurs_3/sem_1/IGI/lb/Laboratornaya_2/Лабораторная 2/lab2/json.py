# !/usr/bin/python
# -*- coding: utf-8 -*-
import numbers
import re

__author__ = 'asaskevich'
__escape_map__ = [('"', '\\"'), ('\n', '\\n'), ('\t', '\\t')]


class ParseException(BaseException):
    """
    Класс-исключение, вызываемый в случае ошибок парсинга JSON строки
    """

    def __init__(self, msg, token, token_group=''):
        BaseException.__init__(self, msg + ', token: ' + token + ', group: ' + token_group)


def escape_str(string):
    """
    Экранирует спецсимволы в строке
    :param string: строка для экранирования
    :return: экранированная строка
    """
    for old, new in __escape_map__:
        string = string.replace(old, new)
    return string


def unescape_str(string):
    """
    Восстанавливает экранированные спецсимволы
    :param string: экранированная строка
    :return: оригинал
    """
    for old, new in __escape_map__:
        string = string.replace(new, old)
    return string


def to_json(obj):
    """
    Конвертирует некоторый объект в JSON строку
    :param obj: объект для конвертации
    :return: строка-JSON
    """
    # None -> null
    if obj is None:
        return 'null'
    # булеан значения
    elif isinstance(obj, bool):
        if obj:
            return "true"
        else:
            return "false"
    # строка
    elif isinstance(obj, str):
        return ''.join(['"', escape_str(obj), '"'])
    # число
    elif isinstance(obj, numbers.Number):
        return str(obj)
    # Список, массив
    elif isinstance(obj, (list, tuple)):
        return '[' + \
               ','.join([to_json(item) for item in obj]) + \
               ']'
    # словарь
    elif isinstance(obj, dict):
        return '{' + \
               ','.join([
                            ''.join(['"', escape_str(key), '"', ':', to_json(obj[key])]) for key in obj.keys()
                            ]) + \
               '}'
    # экземпляр класса
    elif isinstance(obj, object) and hasattr(obj, '__dict__'):
        return to_json(obj.__dict__)
    # иначе это неподдерживаемый тип
    else:
        raise NotImplementedError('type of this object is not supported')


def get_tokens(text):
    """
    Возвращает список токенов для JSON-строки
    :param text: json строка
    :return: список токенов
    """
    tokens = []
    chars = list(text)
    while len(chars) > 0:
        ch = chars[0]
        # спецтокены
        if ch in ('[', ']', ',', ':', '{', '}'):
            tokens.append(ch)
        # начало строки или ключа
        elif ch == '"':
            token = ch
            i = 1
            while i < len(chars):
                ch = chars[i]
                token += ch
                # неэкранированные кавычки - конец строки
                if not chars[i - 1] == '\\':
                    if ch == '"':
                        break
                i += 1
            tokens.append(token)
            del chars[0:i + 1]
            continue
        # число
        elif re.match('[0-9\.\-e]', ch):
            token = ch
            del chars[0]
            while len(chars) > 0 and re.match('[0-9\.\-e]', chars[0]):
                ch = chars[0]
                token += ch
                del chars[0]
            tokens.append(token)
            continue
        # одно из ключевых слов null / true
        if len(chars) >= 4:
            if ''.join(chars[0:4]) in ('null', 'true'):
                tokens.append(''.join(chars[0:4]))
                del chars[0:4]
                continue
        # ключевое слово false
        if len(chars) >= 5:
            if ''.join(chars[0:5]) == 'false':
                tokens.append(''.join(chars[0:5]))
                del chars[0:5]
                continue
        del chars[0]
    return tokens


def from_json(text):
    """
    Возвращает объект, полученный после преобразования json-строки
    :param text: json-строка
    :return: объект
    """
    tokens = get_tokens(text)
    if len(tokens) == 0:
        return None
    # на входе один токен
    if len(tokens) == 1:
        token = tokens[0]
        if token == 'false':
            return False
        elif token == 'true':
            return True
        elif token == 'null':
            return None
        elif re.match('^\-?[0-9]+$', token):
            return int(token)
        elif re.match('^\-?[0-9]+(\.[0-9]+)?$', token):
            return float(token)
        elif token[0] == '"' and token[-1] == '"':
            return unescape_str(token[1:-1])
        else:
            raise ParseException('unexpected token ', token, text)
    # на входе массив
    elif tokens[0] == '[' and tokens[-1] == ']':
        return_array = []
        tokens = tokens[1:-1]
        i = 0
        while i < len(tokens):
            token = tokens[i]
            # элемент массива - массив
            # ищем конец элемента, парсим
            if token == '[':
                j = i + 1
                depth = 1
                tokens_group = ['[']
                while depth > 0 and j < len(tokens):
                    if tokens[j] == '[':
                        depth += 1
                        tokens_group.append(tokens[j])
                    elif tokens[j] == ']':
                        depth -= 1
                        tokens_group.append(tokens[j])
                        if depth == 0:
                            return_array.append(from_json(''.join(tokens_group)))
                            tokens_group.clear()
                            break
                        # elif depth < 0:
                        #     raise ParseException('unexpected token', tokens[j], ''.join(tokens_group))
                    else:
                        tokens_group.append(tokens[j])
                    j += 1
                if depth != 0:
                    raise ParseException('unexpected token', token, ''.join(tokens_group))
                i = j + 1
            elif token == '{':
                # элемент массива - объект
                # ищем конец элемента, парсим
                j = i + 1
                depth = 1
                tokens_group = ['{']
                while depth > 0 and j < len(tokens):
                    if tokens[j] == '{':
                        depth += 1
                        tokens_group.append(tokens[j])
                    elif tokens[j] == '}':
                        depth -= 1
                        tokens_group.append(tokens[j])
                        if depth == 0:
                            return_array.append(from_json(''.join(tokens_group)))
                            tokens_group.clear()
                            break
                        # elif depth < 0:
                        #     raise ParseException('unexpected token', tokens[j], ''.join(tokens_group))
                    else:
                        tokens_group.append(tokens[j])
                    j += 1
                if depth != 0:
                    raise ParseException('unexpected token', token, ''.join(tokens_group))
                i = j + 1
            elif token == ',':
                # разделитель элементов
                i += 1
                continue
            else:
                return_array.append(from_json(token))
                i += 1
        return return_array
    elif tokens[0] == '{' and tokens[-1] == '}':
        # на входе - объект
        tokens = tokens[1:-1]
        i = 0
        return_dict = {}
        while i < len(tokens):
            token = tokens[i]
            next_token = tokens[i + 1] if i + 1 < len(tokens) else None
            if token[0] == '"' and token[-1] == '"' and \
                            next_token is not None and next_token == ':':
                # текущий токен - ключ, следующий - ":"
                key = token
                value_token = tokens[i + 2] if i + 2 < len(tokens) else None
                if value_token == '{':
                    # после двоеточия - возможно объект
                    # ищем конец объекта - парсим
                    j = i + 3
                    depth = 1
                    tokens_group = ['{']
                    while depth > 0 and j < len(tokens):
                        if tokens[j] == '{':
                            depth += 1
                            tokens_group.append(tokens[j])
                        elif tokens[j] == '}':
                            depth -= 1
                            tokens_group.append(tokens[j])
                            if depth == 0:
                                return_dict[unescape_str(key[1:-1])] = from_json(''.join(tokens_group))
                                tokens_group.clear()
                                break
                            # elif depth < 0:
                            #     raise ParseException('unexpected token', tokens[j], ''.join(tokens_group))
                        else:
                            tokens_group.append(tokens[j])
                        j += 1
                    if depth != 0:
                        raise ParseException('unexpected token', token, ''.join(tokens_group))
                    i = j + 1
                elif value_token == '[':
                    # после двоеточия - возможно массив
                    j = i + 3
                    depth = 1
                    tokens_group = ['[']
                    # ищем конец массива, парсим
                    while depth > 0 and j < len(tokens):
                        if tokens[j] == '[':
                            depth += 1
                            tokens_group.append(tokens[j])
                        elif tokens[j] == ']':
                            depth -= 1
                            tokens_group.append(tokens[j])
                            if depth == 0:
                                return_dict[unescape_str(key[1:-1])] = from_json(''.join(tokens_group))
                                tokens_group.clear()
                                break
                            # elif depth < 0:
                            #     raise ParseException('unexpected token', tokens[j], ''.join(tokens_group))
                        else:
                            tokens_group.append(tokens[j])
                        j += 1
                    if depth != 0:
                        raise ParseException('unexpected token', token, ''.join(tokens_group))
                    i = j + 1
                else:
                    return_dict[unescape_str(key[1:-1])] = from_json(value_token)
                    i += 3
                    continue
            elif token == ',':
                i += 1
                continue
            else:
                raise ParseException('unexpected token', token, ''.join(tokens))
            i += 1
        return return_dict
    else:
        raise ParseException('unexpected token', text)
