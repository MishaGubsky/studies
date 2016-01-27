__author__ = 'Mikhail'
import numbers

__author__ = 'Mikhail'


class json(object):
	def __init__(self):
		self._tab = 0

	def to_json(self, object):
		if hasattr(object, '__dict__'):
			return self.to_json(object)
		if isinstance(object, str):
			return '"' + str(object) + '"'
		if isinstance(object, dict):
			self._tab += 1
			d = self.dict_to(object)
			self._tab -= 1
			return d
		if isinstance(object, (list, tuple)):
			self._tab += 1
			s = self.sequence(object)
			self._tab -= 1
			return s
		if isinstance(object, numbers.Number):
			return str(object)
		if object is None:
			return 'null'
		if isinstance(object, bool):
			return str(object).lower()

	def sequence(self, seq):
		items = (',\n' + '\t' * self._tab).join(self.to_json(val) for val in seq)
		return '[\n' + '\t' * self._tab + items + '\n' + '\t' * (self._tab - 1) + ']'

	def dict_to(self, dict):
		items = [('"{}": {}').format(str(key), self.to_json(val))
		         for key, val in dict.items()]
		return '{\n' + '\t' * self._tab + (',\n' + '\t' * self._tab).join(items) + '\n' + '\t' * (self._tab - 1) + '}'


j = json()
print j.to_json([{8: [5, 'fd'], 5: 4}, 'r', 'rg'])
