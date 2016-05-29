__author__ = 'Mikhail'

import token_rules
from token_rules import tokens
import colorama
import re
import ply.lex as lex
import ply.yacc as yacc

ident = []
functions = {}


def p_block(p):
	'''
		block :
				| LBRACKET body RBRACKET
	'''
	if len(p) == 1:
		p[0] = []
	else:
		p[0] = p[2]


def p_body(p):
	'''
		body : expression
			| function_declaration
	'''
	p[0] = p[1]


def p_expression(p):
	'''
		expression : declaration_with_assignment expression
					| declaration_with_assignment
					| if expression
					| else
					| function_body
					| function_implementation SEMICOLON
					| function_implementation SEMICOLON expression
					| arithmetic_expression
					| while expression
					| while
					| console_function
					| console_function expression

	'''
	if p[1]:
		p[0] = p[1]


def p_declaration_with_assignment(p):
	'''
		 declaration_with_assignment : VAR ID ASSIGNMENT_OPERATOR arithmetic_expression SEMICOLON
									| VAR ID ASSIGNMENT_OPERATOR function_declaration
	'''
	if len(p) == 6:
		if p[2] not in ident:
			ident.append(p[2])
	else:
		functions[p[2]] = p[4]
	p[0] = p[1]


def p_arithmetic_expression(p):
	'''
	arithmetic_expression : ID MATH_OPERATOR arithmetic_expression
					 | ID MATH_OPERATOR SEMICOLON
					 | NUMBER MATH_OPERATOR arithmetic_expression
					 | arithmetic_expression MATH_OPERATOR arithmetic_expression
					 | NUMBER
					 | ID
					 | STRING
	'''
	if len(p) == 2:
		p[0] = p[1]
	else:
		v1, v2 = p[1], p[3]
		if p[2] == '/' and v2 == 0:
			raise Exception('\n!Semantic Error!\nDivision by zero at line {0}!'.format(lexer.lineno))

		if type(p[1]) not in (float, int) and p[1][0] not in ('\'', '"'):
			if p[1] not in ident:
				raise Exception('\n!Semantic Error!\n{0} is not defined at line {1}!'.format(p[1], lexer.lineno))

		if p[3] != ';':
			if type(p[3]) not in (float, int) and p[3][0] not in ('\'', '"'):
				if p[3] not in ident:
					raise Exception('\n!Semantic Error!\n{0} is not defined at line {1}!'.format(p[3], lexer.lineno))

		p[0] = p[1]


def p_function_declaration(p):
	'''
		function_declaration : FUNCTION LPAREN  parameters RPAREN LBRACKET function_body RBRACKET
	'''
	p[0] = p[3]


def p_function_body(p):
	'''
		function_body : expression
					| RETURN expression SEMICOLON
	'''
	if len(p) == 2:
		p[0] = p[1]
	else:
		if type(p[2]) not in (float, int) and p[2][0] not in ('\'', '"'):
			if p[2] not in ident:
				raise Exception('\n!Semantic Error!\n{0} is not defined at line {1}!'.format(p[2], lexer.lineno - 1))

		p[0] = p[2]


def p_function_implementation(p):
	'''
		function_implementation : ID LPAREN function_parameters RPAREN
								| function_implementation MATH_OPERATOR expression

	'''
	if len(p) == 5:
		if p[1] not in functions.keys():
			raise Exception('\n!Semantic Error!\n{0} is not defined at line {1}!'.format(p[1], lexer.lineno - 1))
		if len(p[3]) != len(functions[p[1]]):
			raise Exception('\n!Semantic Error!\nNot enough parameters at line {1}!'.format(p[3], lexer.lineno - 1))
	p[0] = p[1]

def p_function_parameters(p):
	"""
	function_parameters :
				| function_parameters COMMA function_parameters
				| arithmetic_expression
	"""

	if len(p) == 1:
		p[0] = []
	elif len(p) == 2:
		p[0] = [p[1]]
	else:
		p[0] = [p[1], p[3]]



def p_parameters(p):
	"""
	parameters :
				| parameters COMMA parameters
				| arithmetic_expression
	"""

	if len(p) == 1:
		p[0] = []
	elif len(p) == 2:
		if p[1] not in ident:
			ident.append(p[1])
		p[0] = [p[1]]
	else:
		if p[1] not in ident:
			ident.append(p[1])
		if p[3] not in ident:
			ident.append(p[3])
		p[0] = [p[1], p[3]]


def p_console_function(p):
	'''
		console_function : METHOD_OF_CLASS_CONSOLE LPAREN expression RPAREN SEMICOLON
	'''
	p[0] = [p[1], p[3]]


def p_predicate(p):
	'''
	predicate : ID LOGICAL_OPERATOR arithmetic_expression
				| ID LOGICAL_OPERATOR ID
				| predicate LOGICAL_OPERATOR predicate
	'''
	if p[1] not in ident:
		raise Exception('{0} is not defined at line {1}!'.format(p[1], lexer.lineno))

	if type(p[3]) not in (float, int) and p[3][0] not in ('\'', '"'):
		if p[3] not in ident:
			raise Exception('\n!Semantic Error!\n{0} is not defined at line {1}!'.format(p[3], lexer.lineno))
	p[0] = p[1]


def p_while(p):
	'''
		while : WHILE LPAREN predicate RPAREN block
	'''
	p[0] = [p[3], p[5]]


def p_if(p):
	'''
		if : IF LPAREN predicate RPAREN block
	'''
	p[0] = [p[3], p[5]]


def p_else(p):
	'''
		else : ELSE block
	'''
	p[0] = [p[2]]


def p_error(p):
	print(colorama.Fore.RED + '\n!Syntax ERROR!\nUnexpected token {0} at line {1}\n'.format(str(p.value),
	                                                                                        p.lexer.lineno))


parser = yacc.yacc(method='LALR', check_recursion=False)

with open('code.txt', 'r') as file:
	data = file.read()

program = data
lexer = lex.lex(reflags=re.UNICODE | re.DOTALL, module=token_rules)
result = parser.parse(input=program, lexer=lexer, debug=False, tracking=True)
if result:
	print(ident)
	print(functions)
