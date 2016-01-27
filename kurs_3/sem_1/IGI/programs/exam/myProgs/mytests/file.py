__author__ = 'Mikhail'


def count_fun(word):
	vowel, cons = 0, 0
	for char in word:
		if char.isalpha():
			if char in ['a', 'e', 'i', 'u', 'o', 'y']:
				vowel += 1
			else:
				cons += 1
			return (vowel, cons)


def fun(path, chars, *args):
	f = open(path, 'r')
	result = set()
	for line in f.readlines():
		line = line.replace('\n', '')
		for char in chars:
			line = line.replace(char, '')

		a = line.split(' ')
		mycount = []

		for word in a:
			if word not in args:
				count = count_fun(word)
				if count not in mycount:
					mycount.append(count)
					result.add(''.join(sorted(word)))
		print result
	print len(result)
	f.close()


fun('words', 'gfd', 'as', 'fgfhd', 'dfgsgs')
