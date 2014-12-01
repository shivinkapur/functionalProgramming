
# What is a scripting language?

# any dynamically typed language

# language features tailored to writing scripts
# - little programs that connect other programs
# regular expression matching
# easy manipulation of text data / files
# ability to invoke processes
# lots of libraries for common functionality

def prodList(l):
    result = 1
    for i in l:
        if (type(i) == int):
            result *= i
    return result

def fact(n):
    result = 1
    for i in range(2,n+1):
        result *= i
    return result

def doSomething(fname):
    f = open(fname, 'r')
    for line in f:
        print line
        
# iterating over collections
# for x in collection
# "in" is a way to test membership in a collection
# typically use array indexing to read/write elements

def unzip(l):
    return ([x[0] for x in l], [x[1] for x in l])

def unzip2(l):
    return ([a for (a,b) in l], [b for (a,b) in l])

def myReverse(l):
    l.reverse()
    return l

def quicksort(l):
    if l == []:
        return l
    else:
        return quicksort([x for x in l[1:] if x <= l[0]]) + [l[0]] + \
               quicksort([x for x in l[1:] if x > l[0]])

def isPrime(n):
    for i in range(2,n-1):
        if n % i == 0:
            return False
    return True

def isPrime2(n):
    return filter((lambda i: n % i == 0), range(2,n)) == []

def isPrime3(n):
    return not reduce((lambda b,i: (n % i == 0) or b), range(2,n-1), False)

def primesUpTo(n):
    return [x for x in range(2,n+1) if isPrime(x)]

# frequency [1,2,1,1,4,5,4] returns {1:3, 2:1, 4:2, 5:1}
def frequency(l):
    mydict = {}
    for x in l:
        if x in mydict:
            mydict[x] += 1
        else:
            mydict[x] = 1
    return mydict

