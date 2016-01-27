import types
import regex

__author__ = 'Mikhail'
import numbers


#########################object to json######################

def dict_to_json(dict):
	items = [
		'"{}": {}'.format(str(key), to_json(value))
		for key, value in dict.items()
		]
	return '{' + ', '.join(items) + '}'


def sequence_to_json(seq):
	items = ', '.join(to_json(value) for value in seq)
	return '[' + items + ']'


def to_json(object):
	if hasattr(object, '__dict__'):
		return to_json(object.__dict__)
	elif isinstance(object, dict):
		return dict_to_json(object)
	elif isinstance(object, (list, tuple)):
		return sequence_to_json(object)
	elif isinstance(object, str):
		return '"' + str(object) + '"'
	elif object is None:
		return 'null'
	elif isinstance(object, bool):
		return str(object).lower()
	elif isinstance(object, numbers.Number):
		return str(object)
	else:
		raise TypeError('Unsupported type "{}"'.format(type(object)))


###############################json to object###########################

re_object = r'(?P<obj>\{([^\}\{]*|(?&obj))+\})'
re_sequence = r'(?P<seq>\[([^\]\[]*|(?&seq))+\])'
re_str = r'[\"].*?[\"]'
re_int = r'[+-]?[\d]+'
re_float = r'[+-]?[\d]+\.[\d]+'
re_bool = r'true|false'
re_none = r'null'


def parse_dict(json_str):
	re_item = '(?P<key>{key}){separator}{value}'.format(
		key=re_str,
		separator=r'\s*:\s*',
		value=r'(?P<value>' + '|'.join(
			(re_bool,
			 re_float,
			 re_int,
			 re_none,
			 re_object,
			 re_sequence,
			 re_str)) + ')'

	)
	items = regex.finditer(re_item, json_str[1:-1])
	dictionary = {}
	for i in items:
		key = i.group('key').lstrip('\'\"').rstrip('\'\"')
		dictionary[key] = from_json(i.group('value'))
	return dictionary


def parse_sequence(json_str):
	re_item = r'(?P<value>' + '|'.join(
		(re_bool,
		 re_float,
		 re_int,
		 re_none,
		 re_object,
		 re_sequence,
		 re_str)) + ')'
	items = regex.finditer(re_item, json_str[1:-1])
	return [from_json(i.group('value')) for i in items]


def from_json(json_str):
	if regex.match(re_object, json_str):
		return parse_dict(json_str)
	elif regex.match(re_sequence, json_str):
		return parse_sequence(json_str)
	elif regex.match(re_str, json_str):
		return json_str.lstrip('\'\"').rstrip('\'\"')
	elif regex.match(re_none, json_str):
		return None
	elif regex.match(re_float, json_str):
		return float(json_str)
	elif regex.match(re_int, json_str):
		return int(json_str)
	elif regex.match(re_bool, json_str):
		return json_str == 'true'
	else:
		raise ValueError('Json syntax error')
