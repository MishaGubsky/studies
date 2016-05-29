__author__ = 'Mikhail'

# TODO:
# set all code to prilozhenie
# change error screen

import token_rules
from token_rules import tokens
import colorama
import re
import ply.lex as lex
import ply.yacc as yacc


class Node:
	def parts_str(self):
		st = []
		for part in self.parts:
			st.append(part.__str__())
		return "\n".join(st)

	def __str__(self):
		return self.type + ":\n  " + self.parts_str().replace("\n", "\n  ")

	def add_child(self, parts):
		if isinstance(parts, Node):
			if parts.parts:
				self.parts.extend(parts.parts)
		return self

	def __init__(self, type, parts):
		self.type = type
		self.parts = parts


def p_block(p):
	'''
		block :
				| LBRACKET body RBRACKET
	'''
	p[0] = Node('block', [p[2]])


def p_body(p):
	'''
		body : expression
			| function_declaration
	'''
	p[0] = Node('body', [p[1]])


def p_expression(p):
	'''
		expression : declaration_with_assignment expression
					| declaration_with_assignment
					| if expression
					| else
					| function_body
					| arithmetic_expression
					| function_implementation
					| while expression
					| console_function
					| console_function expression

	'''
	if len(p) == 2:
		p[0] = Node('expression', [p[1]])
	else:
		p[0] = Node('expression', [p[1]]).add_child(p[2])




def p_declaration_with_assignment(p):
	'''
		 declaration_with_assignment : VAR ID ASSIGNMENT_OPERATOR arithmetic_expression SEMICOLON
									| VAR ID ASSIGNMENT_OPERATOR function_declaration
	'''
	if len(p) == 5:
		p[0] = Node('declaration_with_assignment', [p[1], p[2], p[3], p[4]])
	elif len(p) == 6:
		p[0] = Node('declaration_with_assignment', [p[1], p[2], p[3], p[4]])

def p_arithmetic_expression(p):
	'''
	arithmetic_expression : ID MATH_OPERATOR arithmetic_expression
					 | ID MATH_OPERATOR SEMICOLON
					 | NUMBER MATH_OPERATOR arithmetic_expression
					 | NUMBER
					 | ID
					 | STRING
	'''
	if len(p) == 2:
		p[0] = Node('arithmetic_expression', [p[1]])
	else:
		p[0] = Node('arithmetic_expression', [p[1], p[2], p[3]])


def p_function_declaration(p):
	'''
		function_declaration : FUNCTION LPAREN  parameters RPAREN LBRACKET function_body RBRACKET
	'''
	p[0] = Node('function_declaration', [p[1], p[3], p[6]])


def p_function_body(p):
	'''
		function_body : expression
					| RETURN expression SEMICOLON
	'''
	if len(p) == 2:
		p[0] = Node('function_body', [p[1]])
	else:
		p[0] = Node('return', [p[2]])


def p_function_implementation(p):
	'''
		function_implementation : ID LPAREN parameters RPAREN
								| function_implementation MATH_OPERATOR function_implementation
	'''
	if len(p) < 6:
		p[0] = Node('function_implementation', [p[1], p[3]])
	else:
		p[0] = Node('function_implementation', [p[1], p[2], p[3]])


def p_parameters(p):
	"""
	parameters :
				| parameters COMMA parameters
				| arithmetic_expression

	"""
	if len(p) == 1:
		p[0] = []
	elif len(p) == 2:
		p[0] = Node('parameter', [p[1]])
	else:
		p[0] = Node('parameters', [p[1], p[3]])



def p_console_function(p):
	'''
		console_function : METHOD_OF_CLASS_CONSOLE LPAREN expression RPAREN SEMICOLON
	'''
	p[0] = Node(p[1], [p[3]])


def p_predicate(p):
	'''
	predicate : ID LOGICAL_OPERATOR NUMBER
				| predicate LOGICAL_OPERATOR predicate
	'''
	p[0] = Node('logical_expression', [p[1], p[2], p[3]])



def p_while(p):
	'''
		while : WHILE LPAREN predicate RPAREN block
	'''
	p[0] = Node('while', [p[3]]).add_child(p[5])


def p_if(p):
	'''
		if : IF LPAREN predicate RPAREN block
	'''
	p[0] = Node('if', [p[3], p[5]])


def p_else(p):
	'''
		else : ELSE block
	'''
	p[0] = Node('else', [p[2]])


def p_error(p):
	print(colorama.Fore.RED + '\n!Syntax ERROR!\nUnexpected token {0} at line {1}\n'.format(p.value[0], p.lexer.lineno))


parser = yacc.yacc(method='LALR', check_recursion=False)

with open('code.txt', 'r') as file:
	data = file.read()

program = data
lexer = lex.lex(reflags=re.UNICODE | re.DOTALL, module=token_rules)

result = parser.parse(input=program, lexer=lexer, debug=False, tracking=True)
if result:
	print(result)
