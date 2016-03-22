__author__ = 'Mikhail'
import re
import colorama
import ply.lex as lex

tokens = (
	'DELIMITER', 'RESERVED', 'LOGICAL_OPERATOR', 'BIN_OPERATOR',
	'MATH_OPERATOR', 'ASSIGNMENT_OPERATOR', 'KEYWORD', 'BOOLEAN',
	'STRING', 'ID', 'NUMBER', 'METHOD_OF_CLASS_CONSOLE',
)

t_ignore = ' \t'
t_ignore_COMMENT = r'(\/\/[^\n]*)|(\/\*.*(\*\/))'
t_DELIMITER = r';|\,'
t_RESERVED = r'\(|\)|{|}'
t_MATH_OPERATOR = '\+\+?|\-\-?|\*|\/|%'
t_LOGICAL_OPERATOR = r'\=\=\=?|<=?|>=?|!=|&&|\|\|'
t_ASSIGNMENT_OPERATOR = r'\='
t_BIN_OPERATOR = r'&|\||\^|\~'
t_METHOD_OF_CLASS_CONSOLE = r'console.log'
t_KEYWORD = r'if|else|function|while|for|in|var|return'
t_BOOLEAN = r'true|false'
t_STRING = r'\"([^\"]+)\"|\'([^\']+)\''
t_NUMBER = r'[0-9]+(\.[0-9]{0,15})?|\.[0-9]{0,15}'
t_ID = r'[A-Za-z][A-Za-z0-9_]*'


def t_error(t):
	print(colorama.Fore.RED + '\n!ERROR!\nIllegal character {0} at line {1}\n'.format(t.value[0], t.lexer.lineno))
	print(colorama.Fore.WHITE)
	t.lexer.skip(1)


def t_newline(t):
	r'\n+'
	t.lexer.lineno += 1


lexer = lex.lex(reflags=re.UNICODE | re.DOTALL)


def parse():
	d = open('task1.txt', 'r')
	lines = d.read()
	d.close()

	lexer.input(lines)
	while True:
		tok = lexer.token()
		if not tok:
			break
		print(tok)


parse()
