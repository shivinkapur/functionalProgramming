def fact(n):
	result = 1
	for i in range(2,n+1):
		result *= i
	return result

for c in 'hello':
	print c

def doSomething(fname):
	f = open(fname,'r')
	for line in f:
		print line

s = "hello my name is todd"
s.split(" ")
s.split("m")
"m" in s

# iterating over collections
# for x in collections
# "in" is a way to test membership in a collection

f = (lambda x: x+1)
map(f,[1,2,3,4,5])

map((lambda x: x+1),[1,2,3,4,5])

reduce((lambda x,y:x+y),[1,2,3,4,5,6,])
reduce((lambda x,y:x+y),[1,2,3,4,5,6,],0)
reduce((lambda x,y:x+y),[1,2,3,4,5,6,],34)

# List comprehension. comes from Haskell
[x+1 for x in [1,2,3,4,5]]

filter((lambda x:x%2 == 1),[1,2,3])

[x+1 for x in l]

[x+1 for x in l if x%2 == 1]

l1 = [1,2,3,4]
l2 = [5,6,7,8]

[x*y for x in l1 for y in l2]

def unzip(l):
	return ([x[0] for x in l], [x[1] for x in l])

# Here we are iterating over all the elements twice
def unzip2(l):
	return ([a for (a,b) in l], [b for (a,b) in l])

# Use one iteration
# def unzip3(l):
# 	return reduce((lambda (x,y), (l1,l2): ))
# not a good example


ll = [[1,2,3], [4,5,6], [7,8,9]] 
map((lambda l : l.reverse()),ll)
# returns None,None,None. Need to return the reverse

def myReverse(l):
	l.reverse()
	return l


# need to be aware of mutable and immutable

def quicksort(l):
	if(l==[]):
		return l
	else:
		return quicksort([x for x in l[1:] if x<= l[0]]) + [l[0]] + \
			quicksort([x for x in l[1:] if x>l[0]])
# 1st is pivot. Don't need to iterate over that.

def isPrime(n):
	if n==1:
		return False
	else:
		for i in range(2,n-1)
			if n%i == 0:
				return False
		return True

def isPrime2(n):
	return not reduce(lambda i,b: (n%i==0) or b, range(2,n-1), False)

def isPrime3(n):
	return filter(lambda i: (n%i==0), range(2,n)) == []

def primesUpTo(n):
		return [x for x in range(2,n+1) if isPrime(x)]

# Dictionaries in Python
mydict = {'name':'mypoint','x':3.4,'y':5.6}


# frequency of [1,2,1,1,4,5,4] returns {1:3,2:1,4:2,5:1}
def frequency(l):
	mydict = {}
	for x in l:
		if x in mydict:
			mydict[x]+= 1
		else:
			mydict[x] = 1
	return mydict
