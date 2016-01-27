from random import randint

__author__ = 'Mikhail'

class seq_filter(object):
	def __init__(self, seq):
		self.sequence = seq

	def __iter__(self):
		for item in self.sequence:
			yield item

	def filter(self, fun):
		items = []
		for item in self.sequence:
			if fun(item):
				items.append(item)
		return items




