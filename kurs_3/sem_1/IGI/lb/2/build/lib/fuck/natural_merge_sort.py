from pip._vendor.requests.packages.urllib3.connectionpool import xrange

__author__ = 'Mikhail'

import tempfile
import random


class merge_sort:
	def create_sequance(self, _range):
		with open('numbers', 'w') as f:
			f.writelines(' {}\n'.format(random.randint(-1000000, 1000000)) for _ in xrange(_range))

	def end_range(self, f):
		tmp = f.readline()
		if tmp == '\'\n':
			return True
		else:
			f.seek(f.tell() - len(tmp) - 1)
			return False

	def end_of_file(self, f):
		tmp = f.readline()
		if tmp == '':
			return True
		else:
			f.seek(f.tell() - len(tmp) - 1)
			return False

	def sorting(self):
		a2 = 0
		s1 = s2 = 1
		while s1 > 0 and s2 > 0:
			f1 = tempfile.TemporaryFile(mode='w+t')
			f2 = tempfile.TemporaryFile(mode='w+t')
			mark = 1
			s1 = s2 = 0

			f = open('numbers', 'r')
			a1 = int(f.readline())
			if not self.end_of_file(f):
				f1.write(str(a1) + '\n')

			while not self.end_of_file(f):
				a2 = int(f.readline())
				if a2 < a1:
					if mark == 1:
						f1.write('\'\n')
						mark = 2
						s1 += 1
					else:
						f2.write('\'\n')
						mark = 1
						s2 += 1

				if mark == 1:
					f1.write(str(a2) + '\n')
					s1 += 1

				else:
					f2.write(str(a2) + '\n')
					s2 += 1
				a1 = a2

			if s2 > 0 and mark == 2:
				f2.write('\'\n')
			elif s1 > 0 and mark == 1:
				f1.write('\'\n')

			f.close()

			# f1.seek(0)
			# print("Lines from f1:\n")
			# for i in f1.readlines():
			# 	print(i + '\n')
			#
			# f2.seek(0)
			# print("\nLines from f2:\n")
			# for i in f2.readlines():
			# 	print(i + '\n')

			f = open('numbers', 'w')
			f1.seek(0)
			f2.seek(0)
			if not self.end_of_file(f1):
				a1 = int(f1.readline().strip('\n'))
			if not self.end_of_file(f2):
				a2 = int(f2.readline().strip('\n'))

			while not self.end_of_file(f1) and not self.end_of_file(f2):
				file1 = file2 = False

				while not file1 and not file2:
					if a1 <= a2:
						f.write(str(a1) + '\n')
						file1 = self.end_range(f1)
						if not self.end_of_file(f1):
							a1 = int(f1.readline().strip('\n'))
					else:
						f.write(str(a2) + '\n')
						file2 = self.end_range(f2)
						if not self.end_of_file(f2):
							a2 = int(f2.readline().strip('\n'))

				while not file1:
					f.write(str(a1) + '\n')
					file1 = self.end_range(f1)
					if not self.end_of_file(f1):
						a1 = int(f1.readline().strip('\n'))

				while not file2:
					f.write(str(a2) + '\n')
					file2 = self.end_range(f2)
					if not self.end_of_file(f2):
						a2 = int(f2.readline().strip('\n'))
			#
			# f.close()
			# f = open('numbers', 'r')
			# f.seek(0)
			# print("\n\n\nLines from f:\n")
			# for i in f.readlines():
			# 	print(i + '\n')

			file1 = file2 = False
			while not file1 and not self.end_of_file(f1):
				f.write(str(a1) + '\n')
				file1 = self.end_range(f1)
				if not self.end_of_file(f1):
					a1 = int(f1.readline().strip('\n'))
			while not file2 and not self.end_of_file(f2):
				f.write(str(a2) + '\n')
				file2 = self.end_range(f2)
				if not self.end_of_file(f2):
					a2 = int(f2.readline().strip('\n'))
			f.close()
			f1.close()
			f2.close()


def main():
	sort = merge_sort()
	sort.create_sequance(500)
	sort.sorting()


if __name__ == '__main__':
	main()
