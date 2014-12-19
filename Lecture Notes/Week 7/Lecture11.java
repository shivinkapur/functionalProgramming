import java.util.*;
// Java
/*
	Object oriented concepts:
	- subtyping
	- inheritence
	- dynamic dispatch

	Key focus: interface vs. implementation
	(Ocaml modules)

	why is it a good thing to separate interface/impl?

	o flexibility for the implementer
		- can change implementation without affecting clients
		  as long as the interface doesn't change
		- can monetize your implementation
		- can hide private details
			- my SSN
			- my proprietary algorithm

	o client doens't need to care about implementation details
	Note: small talk was first OO language. Java 8, Scala

*/

// Interfaces (types)
	//  stype for a set of strings
	// methods inside interface are implicitly public
	// Interface cannot have constructors
	interface Set {
		boolean contains(String s);
		void addElem(String s);
		int size();
	}
/*
	Separating iterface from implementation simplifies reasoning about correctness.
	Splits reasoning into two pieces:

	1. Check that an implemetation obeys the interface
		- supports all the operations of the interface
		- implementer doesn't know or care about the clients

	2. Check that clients use the interface properly
		- invoke operations with arguments of the right type
		- client doesn't know or care about the implemetations
*/

/*
	Declares a new type Set

	Declares the operations supported by a Set

	Can only specify methods (no fields can be mentioned)

*/

class Client {
	void myClient(Set s) {
		// if(s.contains("hi"))
			s.addElem("bye");
		System.out.println("size is "+ s.size());
	}
}

// an implementation of a set of strings
// if u declare this class at abstract, it will compile. You can't make an instance of an abstract class
class Set1 implements Set {
	private List<String> l = new LinkedList<String>();

	public boolean contains(String s) {
		return l.contains(s);
	}

	public void addElem(String s) {
		if(!(this.contains(s)))
			l.add(s);
	}

	public int size() {
		return l.size();
	}
}

class Main {
	public static void main(String[] args) {
		Client c = new Client();
		c.myClient(new Set1());
		c.myClient(new Set2(0));
	}
}

// Generics is parametric polymorphism. No type inference, like in Ocaml, so we need to mention
// Java is a memory safe language
// Pure object oriented languages: Java(?), Ruby, Small Talk

// Implement with arrays
class Set2 implements Set {
	private String[] strings;
	private int count;

	Set2(int initialSize) {
		if(initialSize <= 0)
			initialSize = 10;
		this.strings = new String[initialSize];
		this.count = 0;
	}
	public boolean contains(String s) {
		for (int i=0;i<count;i++) {
			if(s.equals(strings[i]))
				return true;
		}
		return false;
	}

	public void addElem(String s) {
		if(this.contains(s))
			return;

		if(count == strings.length) {
			// ugly resizing
			String[] newarr = new String[count*2];
			for (int i=0;i<count;i++) {
				newarr[i] = strings[i];
				this.strings = newarr;
			}
		}
		strings[count] = s;
		count++;
	}

	public int size() {
		return this.count;
	}
}

/*
	Kinds of polymorphism

	1. Parametric polymorphism (aka Generics)
		- can declare types that are parameterize by type variables

	2. Subtype polymorphism
		- types have a relation among them(the subtyping relation)
		- if S is a subtype of T, then can use an object of type S wherever an object of type T is expected

*/

class Generics {
	public static void main(String[] args) {
		List<String> l1 = new ArrayList<String>();
		List<Integer> l2 = new ArrayList<Integer>();

		l1.add("hello");
		// l2.add("hi"); // type error
		l2.add(34); // implicit conversion from int to Integer (Auto-Boxing)
		// Unboxing and autoboxing might have corner cases which don't do the right thing
		l2.add(new Integer(4));
	}
}

// A generic Set. This is a polymorphic type
interface GenericSet<E> {
		boolean contains(E s);
		void addElem(E s);
		int size();
	}

class GenericSet1<T> implements GenericSet<T> {
	private List<T> l = new LinkedList<T>();

	public boolean contains(T s) {
		return l.contains(s);
	}

	public void addElem(T s) {
		if(!(this.contains(s)))
			l.add(s);
	}

	public int size() {
		return l.size();
	}
}


//  Subtyping

// a subtype of Set
interface RemovableSet extends Set {
	void remove(String s);
}

class NewClient {
	void m(RemovableSet rs) {
		Client c = new Client();
		c.myClient(rs);
		Set s = rs;
		rs.remove("hello");
		// s.remove("hello"); // type error. Set doesn't have remove
		this.m(rs);
		// this.m(s);
		/* Lect10.java:202: error: method m in class NewClient cannot be applied to given types;
		this.m(s);
		    ^
		  required: RemovableSet
		  found: Set
		  reason: actual argument Set cannot be converted to RemovableSet by method invocation conversion
		   */
	}

	Set union(Set s1, Set s2) {
		// ...
		return s1; // not a real implementation
	}

}

/*
	LECTURE 11 STARTS HERE
*
*
*
*
*/


interface ObjectSet {
	boolean contains(Object o);
	void addelem(Object o);
	int size();
	Object get(); // get a random item from the set
}

// We already had subtyping. Why did they inroduce generics?
// By subtyping, we can store anything in this ObjectSet.

/*
	What is advantage of GenericSet?
		- GenericSet can ensure homogeneity.
		  GenericSet<String> is guaranteed to only contain Strings.

		- GenericSet is statically type safe

		ObjectSet s = new ObjectSet();
		s.addElem("hello");
		s.addElem("bye");
		String str = s.get(); // This will be a type error. Compile time error.
		String str = (String) s.get(); // If its not correct ie. its not a string, will get RuntimeException cast exception

		// No possibility of runtime error
		GenericSet<String> s = new GenericSet<String>();
		s.addElem("hello");
		s.addElem("bye");
		String str = s.get();

	Subtyping is a property of interfaces
*/

// Inheritance
// RemovableSet1 inherits code from Set1
// RemovableSet1 has the type RemovableSet
// Transitively by subtyping RemovableSet1 has the type Set
class RemovableSet1 extends Set1 implements RemovableSet {
	public void remove(String s) {

	// override
	// public boolean contains(String s) {} // dynamic dispatch
	}

	// public boolean contains(..) // Can override it like this
}

// You could use class name as types, but it is discouraged. Rather have only interfaces as types

/*

	Subtyping is about interfaces
		- type compatibility
		- can i safely use an S where a T is expected

	Inheritance is about implementations
		- a mechanism for reusing code

	Why only single inheritance?
		- Simplicity vs Expressiveness
*/


// 1. Subtyping without inheritance

class Rectangle {
	protected int length, width;
	// bunch of methods
}

// How do I make square a subtype but not inherit from Rect? Can't really do this in Java

/*
	I want Square and Rectangle to be compatible:
		- pass them both to same places. But I don't want Square to inherit code from Rectangle
*/

interface Quad {
	int perimeter();
	int area();
	// ..
}

class Square implements Quad {
	int size;
	// ..
}

// 2. Inheritance without subtyping

// class Bag1 extends Set1 {

// }

// Not good

// How can Bag1 and Set1 share code without being in a subtype relationship?

abstract class Collection {
	protected List<String> l = new LinkedList<String>();

	public boolean contains(String s) {
		return l.contains(s);
	}
	// ...
	public abstract void addElem(String s);
}

class Set1 extends Collection implements Set {}

class bag1 extends Collection implements bag {}
// Should make Collection abstract

/*
	I1 extends I2 declares a subtyping relation
	C1 and C2 declares an inheritance and a subtyping relation
	C implements I declares a subtyping relation
*/

/*
	Dynamic Dispatch

	dynamically on a message send, we find the right method to invoke based on the run-time class of the receiver object

*/

class C {
	void m() {
		System.out.println("C.m");
	}
	void n() {
		this.m();
	}

	// these p methods are statically overlaoded
	void p(C c) {
		System.out.println("CpC");
	}

	void p(D d) {
		System.out.println("CpD");
	}
}
class D extends C {
	void m() {
		System.out.println("D.m");
	}

	void p(C c) {
		System.out.println("DpC");
	}

	void p(D d) {
		System.out.println("DpD");
	}
}
class Main {
	public static void main(String[] args) {
		C c = new C();
		D d = new D();
		// c = d; // will print D.m both times
		c.m();
		d.m();
		c.n();
		d.n();

		c = d;
		c.p(c); // will still be cpc dpd
		d.p(d);

		// Off Topic
		Object[] myarray = args[];
		// allows this but really shouldn't. As arrays are mutable.
		myarray[0] = 34;
		String s = args[0]; // will throw ArrayThrowException
	}
}
// Note: super is not dynamically dispatched

/*
	Dynamic Dispatch is a form of *dynamic* overloading:
		- multiple methods of the same name
		- resolved dynamically which one to invoke

	Static Overloading
		- multiple methods of the same name
		- resolved statically based on the static types

	Java methods are dynamically dispatched on the reciever parameters
	Java methods can statically overloaded on the other parameters
*/


/*

	OO style

	objects that talk to each other by sending messages

	each object knows how to do certain things
		- publishes what it knows how to do through an interface

	clients interact with the object only through the interface

	string separation of interface and implementation
*/

// simple example: a chess game

interface Piece {
	boolean isLegalMove(int x, int y);
	// ...
}

abstract class PieceImpl implements Piece {
	int x, y;
	// ..
}
class Rook extends PieceImpl implements Piece { // can get rid of implements Piece here
	// ...
	boolean isLegalMove(int x, int y) {}
}

class Pawn extends PieceImpl implements Piece {
	// ...
	boolean isLegalMove(int x, int y) {}
}

class Board {
	void move(Piece p, int x, int y) {
		// // don't do this!! It is very bad style
		// if p is a Pawn {
		// 	...
		// }
		// else if p is a Rook {
		// 	...
		// }

		if(p.isLegalMove(x,y)) {
			// make the move
		}
	}
}

/*
	What would you do in OCaml?

	type piece = Rook of ... | Pawn of ... | Bishop of ... | ...

	let move(p,x,y) =
		match p with
			Rook(..) -> ...
			| Pawn(..) -> ...
			| ...

	This is what was told to not be done in Java! OO concepts
*/
