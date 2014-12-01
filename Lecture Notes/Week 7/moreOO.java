import java.util.*;

// super sends

class C {
    void m() { System.out.println("C"); }
}

class D extends C {
    void m() {
	System.out.println("do some stuff");
	    // statically resolved to invoke C.m()
	super.m();
	System.out.println("do some other stuff");
    }
}

class E extends D {}

// first-class functions

// in the standard library
// interface Comparator<T> {
//     int compare(T t1, T t2);
// }

class MyComp implements Comparator<String> {
    public int compare(String s1, String s2) {
	return -(s1.compareTo(s2));
    }
}

class Main {
    public static void main(String[] args) {
	List<String> l = new LinkedList<String>();
	for (String s : args)
	    l.add(s);
	Collections.sort(
	    l,
		// creates an anonymous class that implements
		// Comparator<String> and creates a single
		// instance of that class
	    // new Comparator<String>() {
	    // 	public int compare(String s1, String s2) {
	    // 	    return -(s1.compareTo(s2));
	    // 	}
	    // }
	    
	    // nicer shorthand for the above code
	    (s1, s2) -> -(s1.compareTo(s2))
	    );
	for (String str : l)
	    System.out.println(str);
    }
}

// Exceptions

interface LList {
    void add(String s);
    String get(int i) throws MyException;
}

class MyException extends Exception {}

class MyList implements LList {
    private String[] elems = new String[10];
    private int size = 0;
    
    public void add(String s) {
	    // ...
    }
    public String get(int i) throws MyException {
	if (i < 0 || i >= size)
	    throw new MyException();
	return elems[i];
    }
}

class Main2 {
    public static void main(String[] args) {
	try {
	    LList l = new MyList();
	    new Main2().callsGet(l, 100);
	} catch(MyException e) {
	    System.out.println("myexception occurred");
	}
    }

	// the typechecker ensures that this method either
	// catches MyException or declares that it might throw
	// that exception
    String callsGet(LList l, int i) throws MyException {
	return l.get(i);
    }
}

class XException extends Exception {}
class YException extends Exception {}

class Point {
    protected int x, y;

    void updateX() throws XException { }
    void updateY() throws YException { }

	// want to either update both x and y or neither
	// need to catch exceptions and restore state manually
	// hard to do in general!
    void updateBoth() throws XException, YException {
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

/*
class FileReader {
	// make sure the file is always closed upon exit
    void readFileAndCompute(File f) {
	try {
	    String s = f.read();
	    compute(s);
	} finally {
	// this code is guaranteed to execute last, regardless
	// of whether an exception occurs or not in the try block above
	    f.close();
	}
    }
}
*/