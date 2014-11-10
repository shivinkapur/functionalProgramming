# What is a scripting language?
# almost any dynamically typed language
# language features tailored to writing scripts
# - little programs that connect other programs
# regular expression matching
# easy manipulation of text data/files
# ability to invoke processes
# lots of libraries for common functionality

# It is memory safe
# Lists are mutable
# Its pseduo object oriented (Lists are objects)

def prodList(l):
	result = 1
	for i in l:
		result *= i;
	return result

# Whitespace is important. Identation matters
# Tuples are immutable. Lists vs Tuples. When u want functional programming, use tuple. But then they r fixed size.