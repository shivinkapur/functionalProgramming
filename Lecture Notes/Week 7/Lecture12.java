/*
	Facebook released a new tool. Called FLOW. Its a static typechecker for javascript. They implemented flow and hack in OCaml.
*/

import java.util.*;

class C {
	void m() { System.out.println("C"); }
}

class D extends C {
	void m() { 
		System.out.println("do some stuff");
		super.m();
		System.out.println("do some other stuff");
	}
}

class E extends D {}

/*
	Super is statically resolved. 
	If it were dynamically resolved, E extends D, it would go to D's m. 
	But then super is called on E and then it would go to D's m again. It will become an infinite loop.
*/

// first-class functions
// First he will tell us about old first-class functions in Java, then about the new syntax which came out last month.

// interface Comparator<T> {
// 	int compare(T t1, T t2);
// }

// No need for this if done inside the sort itself
// class Mycomp implements Comparator<String> {
// 	public int compare(String s1, String s2) {
// 		return -(s1.compareTo(s2));
// 	}
// }

class Main {
	public static void main(String[] args) {
		List<String> l = new LinkedList<String>();
		for (String s : args) {
			l.add(s);
		}
		// Collections.sort(l, new Mycomp()); // Collections u don't need to instantiate. They are like static methods. Like List.map etc
		
		// New Way
		Collections.sort(
			l,
			// creates an anonymous class that implements
			// comparator<Srting> and creates a single instance of that class
			new Comparator<String>() {
				public int compare(String s1, String s2) {
					return -(s1.compareTo(s2));
				}
			}
			// This is syntactic sugar.
			// (String s1, String s2) -> -(s1.compareTo(s2))
			// (s1, s2) -> -(s1.compareTo(s2)) // type inference
			// (String s1, String s2) -> { //...
								// return -(s1.compareTo(s2)) } 
			);

		for (String str : l) {
			System.out.println(str);				
		}
	}
}
// Object passed as parameter acts like a first class function

// Type inference in Java doesn't have guarantee like in OCaml



// Exceptions

interface LList {
	void add(String s);
	String get(int i) throws MyException;
}

class MyException extends Exception {}

class MyList implements LList {
	String[] elems = new String[10];
	private int size = 0;

	public void add(String s) {
		// ...
	}

	public String get(int i) throws MyException {
		if(i < 0 || i >= size)
			// throw new IndexOutOfBoundsException();
			throw new MyException();
		return elems[i];
	}
}

class Main2 {
	public static void main(String[] args) {
		try {
			LList l = new MyList();
			l.get(100);			
		} catch(IndexOutOfBoundsException e) {
			System.out.println("index out of bounds" + e);
		} catch(NullPointerException e) {
			System.out.println("null pointer occured");
		} 
		// Either do this or 
		catch(MyException e) {
			System.out.println("MyException is thrown");
		}	
	}
}

// Runtime Exceptions don't require checked exceptions. Other exceptions are checked. Out of memory, out of index etc 

// Pass exception to class to main. Then if the exception occurs, the program will just crash.
class Main3 {
	public static void main(String[] args) throws MyException {
		LList l = new MyList();
		new Main3().callsGet(l, 100);				
	}

	String callsGet(LList l ,int i) throws MyException {
		return l.get(i);
	}
}

// Java 8. Interface Stream
// This is parallelism. Pipeline parallelism. You can get it for free. 


class XException extends Exception {}
class YException extends Exception {}

class Point {
	protected int x, y;

	void updateX() throws XException {}
	void updateY() throws YException {}

	// want to either update both or none
	void updateBoth() {
		int oldx = this.x;
		int oldy = this.y;
		try {
			updateX();
			updateY();	
		} catch(Exception e) {
			this.x = oldx;
			this.y = oldy;
			throw e;
		}
		
	}
}

class FileReader {
	// make sure the file is always closed upon exit
	void readFileAndCompute(File f) {
		try {
			String s = f.read();
			compute(s);
		} finally {
			f.close();
		}
		// } catch(Exception e) {
		// 	if(!(f.isClosed()))
		// 		f.close();
		// 	throw e;
		// }
	}

	void compute(String s) {}
}