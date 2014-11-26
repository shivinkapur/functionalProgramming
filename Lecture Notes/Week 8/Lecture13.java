/*
	Not good to use getters, setters. Thats not really object oriented. As you are not using it as an object. U r using it as manipulating data.

	Ideal style is to not do just imperitive programming. Do object oriented programmins!!
*/

/*
	Java's Memory Model

	Java is strongly typed:
	- "there are no pointers" 
		(actually ointers are everywhere but hidden)
		- memory deleted by the garbage collector

	- run-time checks for array bounds, null pointer dereferences

	- enforced initialization of variables/fields
		- some implicit, others explicit

	OCaml does it exactly the same way. Java too is memory safe. Any memory safe language would have this.
	SQL injection, stack smashing, aribtrary code execution
*/

// everything is a pointer 

class Main {
	void m() {

			// s is a pointer to a Set1 object
			// s is called a *reference*
		Set s = new Set1();

			// dereferencing s to find the object
			// invoke the add method on the object
		s.add("hello");

		// Java does a null pointer check on every call
		// OCaml: let l = [1;2;3] in..
		// l here is a pointer to the list [1;2;3]

		// let l = [1;2;3] in 0::l

			// creates an alias
			// both s and s2 point to the same object
		Set s2 = s; // s2 copies the value of s. we basically created an alias.

			// now both s and s2 have 2 elements in them
			// because they point to the same object
		s2.add("bye");

			// explicitly make a copy
		Set s3 = s.clone();

		// primitives are stored locally. But since they are immutable, it doesn't matter.
		int x = 43;
		int y = x;
		y = y+1;
		// The wrapping classes are also immutable
		Integer x = new Integer(43);
		Integer y = x;
		y = new Integer(y.getValue()+1);

	}
}

// Parameter Passing

// Java has by-value parameter passing 
// 		key point : often the vaues are pointers (references)

// by vlaue: copy the argument values into the formal parameters
//  	invariant: the original variables are unv=changed

int plus(init a, int b) {
	a = a+b;
	return a;
}

int x = 3;
int y = 4;
int z = plus(x,y);
// the value of a and y are unchanged by the call

class Integer {
	int i;
	Integer(int j) { this.i = j; }
}
Integer plus(Integer a, Integer b) {
	a = new Integer(a.i + b.i);
	return a;
}

Integer x = new Integer(3);
Integer y = new Integer(4);
Integer z = plus(x,y);

// the value of a and y are unchanged by the call
// but...if we have mutation, the we can still make changes
// that are visible at the call site

Integer plus(Integer a, Integer b) {
	a = a.i + b.i;
	return a;
}

Integer x = new Integer(3);
Integer y = new Integer(4);
Integer z = plus(x,y); 
// x and y have the same vallues as before the call
// but x.i is now 7

// Contrast with call-by reference
// creating an alias on the stack

// C++
int plus(int& a, int& b) {
	a = a+b;
	return a;
}
int x = 3;
int y = 4;
int z = plus(x,y);

