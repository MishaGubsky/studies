import colorama
import re

reserved = {
	'if': "IF",
	'else': "ELSE",
	'while': "WHILE",
	'var': "VAR",
	'function': "FUNCTION",
	'return': "RETURN"
}

tokens = (
	         'LPAREN', 'RPAREN', 'LBRACKET', 'RBRACKET',
	         'LOGICAL_OPERATOR', 'MATH_OPERATOR', 'COMMA',
	         'METHOD_OF_CLASS_CONSOLE', 'ASSIGNMENT_OPERATOR',
	         'STRING', 'ID', 'NUMBER', 'SEMICOLON',
         ) + tuple(reserved.values())

t_ignore = ' \t'
t_ignore_COMMENT = r'(\/\/[^\n]*)|(\/\*.*(\*\/))'
t_SEMICOLON = r'\;'
t_LPAREN = r'\('
t_RPAREN = r'\)'
t_LBRACKET = r'\{'
t_RBRACKET = r'\}'
t_MATH_OPERATOR = '\+\+?|\-\-?|\*|\/|%'
t_LOGICAL_OPERATOR = r'\=\=\=?|<=?|>=?|!=|&&|\|\|'
t_ASSIGNMENT_OPERATOR = r'\='
# t_BIN_OPERATOR = r'&|\||\^|\~'
t_STRING = r'\"([^\"]+)\"|\'([^\']+)\''
t_COMMA = r'\,'

# t_ID = r'[A-Za-z][A-Za-z0-9_]*'

def t_NUMBER(t):
	r'[0-9]+(\.[0-9]{0,15})?|\.[0-9]{1,15}'
	if re.match('^[0-9]+$', t.value):
		t.value = int(t.value)
	else:
		t.value = float(t.value)
	return t


def t_error(t):
	print(colorama.Fore.RED + '\n!ERROR!\nIllegal character {0} at line {1}\n'.format(t.value[0], t.lexer.lineno))
	print(colorama.Fore.WHITE)
	t.lexer.skip(1)


def t_newline(t):
	r'\n+'
	t.lexer.lineno += 1


def t_METHOD_OF_CLASS_CONSOLE(t):
	r'console.log'
	t.type = reserved.get(t.value, 'METHOD_OF_CLASS_CONSOLE')
	return t


def t_ID(t):
	r'[A-Za-z][A-Za-z0-9_]*'
	t.type = reserved.get(t.value, 'ID')
	return t
