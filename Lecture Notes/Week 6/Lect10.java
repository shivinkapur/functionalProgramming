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