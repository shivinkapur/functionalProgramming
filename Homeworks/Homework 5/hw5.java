/* Name: Shivin Kapur

   UID: 404259526

   Others With Whom I Discussed Things:

   Other Resources I Consulted:

*/

// import lists and other data structures from the Java standard library
import java.util.*;

// a type for arithmetic expressions
interface AExp {
    double eval(); 	                       // Problem 1a
    List<AInstr> compile(); 	               // Problem 1c
}

class Num implements AExp {
    protected double val;

    Num(double value) {
      val = value;
    }

    public double eval() {
      return val;
    }

    public List<AInstr> compile() {
      List<AInstr> l = new LinkedList<AInstr>();
      l.add(new Push(val));
      return l;
    }
}

class BinOp implements AExp {
    protected AExp left, right;
    protected Op op;

    BinOp(AExp a, Op oper, AExp b) {
      left = a;
      op = oper;
      right = b;
    }

    public double eval(){
      return op.calculate(left.eval(), right.eval());
    }

    public List<AInstr> compile() {
      List<AInstr> l = new LinkedList<AInstr>();
      l = left.compile();
      l.addAll(right.compile());
      l.add(new Calculate(op));
      return l;
    }
}

// a representation of four arithmetic operators
enum Op {
    PLUS { public double calculate(double a1, double a2) { return a1 + a2; } },
    MINUS { public double calculate(double a1, double a2) { return a1 - a2; } },
    TIMES { public double calculate(double a1, double a2) { return a1 * a2; } },
    DIVIDE { public double calculate(double a1, double a2) { return a1 / a2; } };

    abstract double calculate(double a1, double a2);
}

// a type for arithmetic instructions
interface AInstr {
  void eval(Stack<Double> stack);
}

class Push implements AInstr {
    protected double val;

    Push(double value) {
      val = value;
    }

    public void eval(Stack<Double> stack) {
      stack.push(val);
    }

    public String toString() {
      return "Push " + val;
    }
}

class Calculate implements AInstr {
    protected Op op;

    Calculate(Op oper) {
      op = oper;
    }

    public void eval(Stack<Double> stack) {
      Double d2 = stack.pop();
      Double d1 = stack.pop();
      stack.push(op.calculate(d1,d2));
    }


    public String toString() {
      return "Calculate " + op;
    }
}

class Swap implements AInstr {
  Swap(){}

  public void eval(Stack<Double> stack) {
    Double d2 = stack.pop();
    Double d1 = stack.pop();
    stack.push(d2);
    stack.push(d1);
  }


  public String toString() {
    return "Swap ";
  }
}

class Instrs {
    protected List<AInstr> instrs;

    public Instrs(List<AInstr> instrs) { this.instrs = instrs; }

    public double eval() {
      Stack<Double> s = new Stack<Double>();
      for(AInstr ai: instrs)
        ai.eval(s);
      return s.peek();
    }  // Problem 1b
}

class CalcTest {
    public static void main(String[] args) {
	    // a test for Problem 1a
	AExp aexp =
	    new BinOp(new BinOp(new Num(1.0), Op.PLUS, new Num(2.0)),
		      Op.TIMES,
		      new Num(3.0));
	System.out.println("aexp evaluates to " + aexp.eval()); // aexp evaluates to 9.0

  AExp aexp2 = new BinOp(new Num(3.5), Op.TIMES, new Num(4.5));
  System.out.println("aexp evaluates to " + aexp2.eval()); // aexp evaluates to 15.75

  AExp aexp3 = new BinOp(new Num(3.5), Op.TIMES, new Num(0));
  System.out.println("aexp evaluates to " + aexp3.eval()); // aexp evaluates to 0.0

  AExp aexp4 = new BinOp(new Num(3.5), Op.DIVIDE, new Num(0));
  System.out.println("aexp evaluates to " + aexp4.eval()); // aexp evaluates to Infinity

  AExp aexp5 = new BinOp(new Num(3.0), Op.MINUS, new Num(6.0));
  System.out.println("aexp evaluates to " + aexp5.eval()); // aexp evaluates to -3.0

  AExp aexp6 = new BinOp(new Num(0), Op.DIVIDE, new Num(0));
  System.out.println("aexp evaluates to " + aexp6.eval()); // aexp evaluates to NaN

  AExp aexp7 = new BinOp(new BinOp(new Num(6), Op.DIVIDE, new Num(2)), Op.PLUS, new BinOp(new Num(4), Op.MINUS, new BinOp(new Num(1), Op.PLUS, new Num(2))));
  System.out.println("aexp evaluates to " + aexp7.eval()); // aexp evaluates to 4.0

  // a test for Problem 1b
	List<AInstr> is = new LinkedList<AInstr>();
	is.add(new Push(1.0));
	is.add(new Push(2.0));
	is.add(new Calculate(Op.PLUS));
	is.add(new Push(3.0));
	is.add(new Swap());
	is.add(new Calculate(Op.TIMES));
	Instrs instrs = new Instrs(is);
	System.out.println("instrs evaluates to " + instrs.eval());  // instrs evaluates to 9.0

	// a test for Problem 1c
	System.out.println("aexp converts to " + aexp.compile());

    }
}

// a type for dictionaries mapping keys of type K to values of type V
interface Dict<K,V> {
    void put(K k, V v);
    V get(K k) throws NotFoundException;
}

class NotFoundException extends Exception {}


// Problem 2a
class DictImpl2<K,V> implements Dict<K,V> {
    protected Node<K,V> root;

    DictImpl2() { throw new RuntimeException("not implemented"); }

    public void put(K k, V v) { throw new RuntimeException("not implemented"); }

    public V get(K k) throws NotFoundException { throw new RuntimeException("not implemented"); }
}

interface Node<K,V> {
}

class Empty<K,V> implements Node<K,V> {
    Empty() {}
}

class Entry<K,V> implements Node<K,V> {
    protected K k;
    protected V v;
    protected Node<K,V> next;

    Entry(K k, V v, Node<K,V> next) {
	this.k = k;
	this.v = v;
	this.next = next;
    }
}


interface DictFun<A,R> {
    R invoke(A a) throws NotFoundException;
}

// Problem 2b
class DictImpl3<K,V> implements Dict<K,V> {
    protected DictFun<K,V> dFun;

    DictImpl3() { throw new RuntimeException("not implemented"); }

    public void put(K k, V v) { throw new RuntimeException("not implemented"); }

    public V get(K k) throws NotFoundException { throw new RuntimeException("not implemented"); }
}


class Pair<A,B> {
    protected A fst;
    protected B snd;

    Pair(A fst, B snd) { this.fst = fst; this.snd = snd; }

    A fst() { return fst; }
    B snd() { return snd; }
}

// Problem 2c
interface FancyDict<K,V> extends Dict<K,V> {
    void clear();
    boolean containsKey(K k);
    void putAll(List<Pair<K,V>> entries);
}


class DictTest {
    public static void main(String[] args) {

	// a test for Problem 2a
	// Dict<String,Integer> dict1 = new DictImpl2<String,Integer>();
	// dict1.put("hello", 23);
	// dict1.put("bye", 45);
	// try {
	//     System.out.println("bye maps to " + dict1.get("bye")); // prints 45
	//     System.out.println("hi maps to " + dict1.get("hi"));  // throws an exception
	// } catch(NotFoundException e) {
	//     System.out.println("not found!");  // prints "not found!"
	// }

	// a test for Problem 2b
	// Dict<String,Integer> dict2 = new DictImpl3<String,Integer>();
	// dict2.put("hello", 23);
	// dict2.put("bye", 45);
	// try {
	//     System.out.println("bye maps to " + dict2.get("bye"));  // prints 45
	//     System.out.println("hi maps to " + dict2.get("hi"));   // throws an exception
	// } catch(NotFoundException e) {
	//     System.out.println("not found!");  // prints "not found!"
	// }

	// a test for Problem 2c
	// FancyDict<String,Integer> dict3 = new FancyDictImpl3<String,Integer>();
	// dict3.put("hello", 23);
	// dict3.put("bye", 45);
	// System.out.println(dict3.containsKey("bye")); // prints true
	// dict3.clear();
	// System.out.println(dict3.containsKey("bye")); // prints false

    }
}
