import re
import sys

__author__ = 'Mikhail'

token_exprs = [
	(r'[ \t\n]+', 'None'),
	(r'#[ ^\n]*', 'None'),

	(r';', 'DELIMITER'),
	(r'\,', 'DELIMITER'),

	(r'\(', 'RESERVED'),
	(r'\)', 'RESERVED'),
	(r'{', 'RESERVED'),
	(r'}', 'RESERVED'),

	(r'\+\+?', 'MATH OPERATOR'),
	(r'\-\-?', 'MATH OPERATOR'),
	(r'\*', 'MATH OPERATOR'),
	(r'\/', 'MATH OPERATOR'),
	(r'%', 'MATH OPERATOR'),

	(r'\=\=\=?', 'LOGICAL OPERATOR'),
	(r'<=?', 'LOGICAL OPERATOR'),
	(r'>=?', 'LOGICAL OPERATOR'),
	(r'!=', 'LOGICAL OPERATOR'),
	(r'&&', 'LOGICAL OPERATOR'),
	(r'\|\|', 'LOGICAL OPERATOR'),

	(r'\=', 'ASSIGNMENT OPERATOR'),

	(r'&', 'BIN OPERATOR'),
	(r'|', 'BIN OPERATOR'),
	(r'\^', 'BIN OPERATOR'),
	(r'\~', 'BIN OPERATOR'),

	(r'if', 'KEYWORD'),
	(r'else', 'KEYWORD'),
	(r'console.log', 'METHOD OF CLASS CONSOLE'),
	(r'function', 'KEYWORD'),
	(r'while', 'KEYWORD'),
	(r'for', 'KEYWORD'),
	(r'in', 'KEYWORD'),
	(r'var', 'KEYWORD'),
	(r'return', 'KEYWORD'),
	(r'true', 'BOOLEAN'),
	(r'false', 'BOOLEAN'),


	(r'\"([^\"]+)\"', 'STRING'),
	(r'\'([^\']+)\'', 'STRING'),
	(r'[0-9]+(\.[0-9]{0,15})?|\.[0-9]{0,15}', 'NUMBER'),
	(r'[A-Za-z][A-Za-z0-9_]*', 'ID'),
]


def lex(characters, token_exprs):
	pos = 0
	tokens = []
	while pos < len(characters):
		match = None
		for token_expr in token_exprs:
			pattern, tag = token_expr
			# print(pattern+'\n')
			regex = re.compile(pattern)
			match = regex.match(characters, pos)
			if match:
				text = match.group(0)
				if tag:
					token = (text, tag)
					tokens.append(token)
					# print(token)
				break
		if not match:
			sys.stderr.write('Illegal character: %s\n' % characters[pos])
		else:
			pos = match.end(0)
	return tokens


def lex_an(characters):
	return lex(characters, token_exprs)


d = open('task1.txt', 'r')

line = d.read()
d.close()
tokens = lex_an(line)
print(tokens)
# for line in d.readlines():
