from lab.json import from_json

# -*- coding: utf-8 -*-
__author__ = 'Mikhail'

def d(file_name):
	class class_creater(type):
		def __new__(cls, class_name, base_classes, dct):
			# new_class = super(class_creater, cls).__new__(cls, class_name, base_classes, {})
			dct = {}
			if file_name is not None:
				with open(file_name, 'r') as file:
					args = from_json(file.read())
					for item in args.items():
						key = item[0]
						value = item[1]
						dct[key] = value
				return super(class_creater, cls).__new__(cls, class_name, base_classes, dct)
	return class_creater

class f(object, metaclass=d('js')):
	pass

print(f.S)
