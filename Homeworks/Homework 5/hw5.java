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

    public Num(double value) {
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

    public String toString() {
        return "Num " + val;
    }
}

class BinOp implements AExp {
    protected AExp left, right;
    protected Op op;

    public BinOp(AExp a, Op oper, AExp b) {
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

    public String toString() {
        return "BinOp(" + left + ", " + op + ", " + right + ")";
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

    public Push(double value) {
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

    public Calculate(Op oper) {
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

    public Swap(){}

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
      	System.out.println("aexp2 evaluates to " + aexp2.eval()); // aexp evaluates to 15.75

      	AExp aexp3 = new BinOp(new Num(3.5), Op.TIMES, new Num(0));
      	System.out.println("aexp3 evaluates to " + aexp3.eval()); // aexp evaluates to 0.0

      	AExp aexp4 = new BinOp(new Num(3.5), Op.DIVIDE, new Num(0));
      	System.out.println("aexp4 evaluates to " + aexp4.eval()); // aexp evaluates to Infinity

      	AExp aexp5 = new BinOp(new Num(3.0), Op.MINUS, new Num(6.0));
      	System.out.println("aexp5 evaluates to " + aexp5.eval()); // aexp evaluates to -3.0

      	AExp aexp6 = new BinOp(new Num(0), Op.DIVIDE, new Num(0));
      	System.out.println("aexp6 evaluates to " + aexp6.eval()); // aexp evaluates to NaN

      	AExp aexp7 = new BinOp(new BinOp(new Num(6), Op.DIVIDE, new Num(2)), Op.PLUS, new BinOp(new Num(4), Op.MINUS, new BinOp(new Num(1), Op.PLUS, new Num(2))));
      	System.out.println("aexp7 evaluates to " + aexp7.eval()); // aexp evaluates to 4.0

        System.out.println();

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

        List<AInstr> is1 = new LinkedList<AInstr>();
        is1.add(new Push(1.0));
        is1.add(new Push(2.0));
        is1.add(new Calculate(Op.MINUS));
        Instrs instrs1 = new Instrs(is1);
        System.out.println("instrs evaluates to " + instrs1.eval());  // instrs evaluates to -1.0

        List<AInstr> is2 = new LinkedList<AInstr>();
        is2.add(new Push(1.0));
        is2.add(new Push(2.0));
        is2.add(new Calculate(Op.DIVIDE));
        Instrs instrs2 = new Instrs(is2);
        System.out.println("instrs evaluates to " + instrs2.eval());  // instrs evaluates to 0.5

        List<AInstr> is3 = new LinkedList<AInstr>();
        is3.add(new Push(6.0));
        is3.add(new Push(2.0));
        is3.add(new Calculate(Op.DIVIDE));
        is3.add(new Push(4.0));
        is3.add(new Push(1.0));
        is3.add(new Push(2.0));
        is3.add(new Calculate(Op.PLUS));
        is3.add(new Calculate(Op.MINUS));
        is3.add(new Calculate(Op.PLUS));
        Instrs instrs3 = new Instrs(is3);
        System.out.println("instrs evaluates to " + instrs3.eval());  // instrs evaluates to 4.0

        System.out.println();

        // a test for Problem 1c
        System.out.println("aexp converts to " + aexp.compile());
        System.out.println("aexp2 converts to " + aexp2.compile());
        System.out.println("aexp3 converts to " + aexp3.compile());
        System.out.println("aexp4 converts to " + aexp4.compile());
        System.out.println("aexp5 converts to " + aexp5.compile());
        System.out.println("aexp6 converts to " + aexp6.compile());
        System.out.println("aexp7 converts to " + aexp7.compile());

        System.out.println();
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

    public DictImpl2() {
        root = new Empty<K,V>();
    }

    public void put(K k, V v) {
        root = root.put(k, v);
    }

    public V get(K k) throws NotFoundException {
        return root.get(k);
    }
}

interface Node<K,V> {
    Node<K,V> put(K k, V v);
    V get(K k) throws NotFoundException;
}

class Empty<K,V> implements Node<K,V> {

    public Empty() {}

    public Node<K,V> put(K key, V value) {
        return new Entry<K,V>(key, value, this);
    }

    public V get(K key) throws NotFoundException {
        throw new NotFoundException();
    }
}

class Entry<K,V> implements Node<K,V> {
    protected K k;
    protected V v;
    protected Node<K,V> next;

    public Entry(K key, V value, Node<K,V> next) {
    	k = key;
    	v = value;
    	this.next = next;
    }

    public Node<K,V> put(K key, V value) {
        if(key.equals(k))
            v = value;
        else
            this.next = this.next.put(key,value);
        return this;
    }

    public V get(K key) throws NotFoundException {
        if(key.equals(k))
            return v;
        else return next.get(key);
    }
}


interface DictFun<A,R> {
    R invoke(A a) throws NotFoundException;
}

// Problem 2b
class DictImpl3<K,V> implements Dict<K,V> {
    protected DictFun<K,V> dFun;

    DictImpl3() {
        dFun = new DictFun<K,V>() {
            public V invoke(K k) throws NotFoundException {
                throw new NotFoundException();
            }
        };
    }

    // DictImpl3() {
    //   dFun = ((k) -> invoke(k));
    // }

    public void put(K k, V v) {
        DictFun<K,V> dictFun = dFun;
        dFun = new DictFun<K,V>() {
            public V invoke(K key) throws NotFoundException {
                if(key.equals(k))
                    return v;
                else return dictFun.invoke(key);
            }
        };
    }

    public V get(K k) throws NotFoundException {
        return dFun.invoke(k);
    }
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

class FancyDictImpl3<K,V> extends DictImpl3<K,V> implements FancyDict<K,V> {

    FancyDictImpl3() {
        dFun = new DictFun<K,V>() {
            public V invoke(K k) throws NotFoundException {
                throw new NotFoundException();
            }
        };
    }

    public void clear() {
        dFun = new DictFun<K,V>() {
            public V invoke(K k) throws NotFoundException {
                throw new NotFoundException();
            }
        };
    }

    public boolean containsKey(K k) {
        try {
            dFun.invoke(k);
            return true;
        } catch(NotFoundException e) {
            return false;
        }
    }

    public void putAll(List<Pair<K,V>> enteries) {
        for(Pair<K,V> p : enteries) {
            DictFun<K,V> dictFun = dFun;
            dFun = new DictFun<K,V>() {
                public V invoke(K key) throws NotFoundException {
                    if(key.equals(p.fst()))
                        return p.snd();
                    else return dictFun.invoke(key);
                }
            };
        }
    }
}

class DictTest {
    public static void main(String[] args) {

    	// a test for Problem 2a
    	Dict<String,Integer> dict1 = new DictImpl2<String,Integer>();
    	dict1.put("hello", 23);
    	dict1.put("bye", 45);
    	try {
    	    System.out.println("bye maps to " + dict1.get("bye")); // prints 45
    	    System.out.println("hi maps to " + dict1.get("hi"));  // throws an exception
    	} catch(NotFoundException e) {
    	    System.out.println("not found!");  // prints "not found!"
    	}
      System.out.println();

      Dict<String,Integer> dict11 = new DictImpl2<String,Integer>();
      dict11.put("a", 1);
      dict11.put("b", 2);
      dict11.put("c", 3);
      dict11.put("d", 4);
      try {
        System.out.println("'a' maps to " + dict11.get("a"));     // prints 1
        System.out.println("'b' maps to " + dict11.get("b"));     // prints 2
        System.out.println("'ok' maps to " + dict11.get("ok"));   // throws an exception
      } catch(NotFoundException e) {
        System.out.println("not found!");  // prints "not found!"
      }
      dict11.put("ok",22);
      try {
        System.out.println("'ok' maps to " + dict11.get("ok"));   // prints 22
      } catch(NotFoundException e) {
        System.out.println("catch 22");
      }
      System.out.println();

    	// a test for Problem 2b
    	Dict<String,Integer> dict2 = new DictImpl3<String,Integer>();
    	dict2.put("hello", 23);
    	dict2.put("bye", 45);
    	try {
    	    System.out.println("bye maps to " + dict2.get("bye"));  // prints 45
          System.out.println("hello maps to " + dict2.get("hello"));   // prints 23
          System.out.println("hi maps to " + dict2.get("hi"));   // throws an exception
    	} catch(NotFoundException e) {
    	    System.out.println("not found!");  // prints "not found!"
    	}
      System.out.println();

      Dict<String,Integer> dict22 = new DictImpl3<String,Integer>();
      dict22.put("a", 1);
      dict22.put("b", 2);
      dict22.put("c", 3);
      dict22.put("d", 4);
      try {
        System.out.println("'a' maps to " + dict22.get("a"));     // prints 1
        System.out.println("'b' maps to " + dict22.get("b"));     // prints 2
        System.out.println("'ok' maps to " + dict22.get("ok"));   // throws an exception
      } catch(NotFoundException e) {
        System.out.println("not found!");  // prints "not found!"
      }
      dict22.put("ok",22);
      try {
        System.out.println("'ok' maps to " + dict22.get("ok"));   // prints 22
        System.out.println("'c' maps to " + dict22.get("c"));     // prints 3
        System.out.println("'e' maps to " + dict22.get("e"));     // throws an exception
      } catch(NotFoundException e) {
        System.out.println("catch 22");
      }
      System.out.println();

    	// a test for Problem 2c
    	FancyDict<String,Integer> dict3 = new FancyDictImpl3<String,Integer>();
    	dict3.put("hello", 23);
    	dict3.put("bye", 45);
    	System.out.println(dict3.containsKey("bye")); // prints true
      System.out.println(dict3.containsKey("hi")); // prints false
      System.out.println(dict3.containsKey("hello")); // prints true
    	dict3.clear();
    	System.out.println(dict3.containsKey("bye")); // prints false
      dict3.put("bye", 45);
      System.out.println(dict3.containsKey("bye")); // prints true

      System.out.println();

      List<Pair<String,Integer>> list = new LinkedList<Pair<String,Integer>>();
      list.add(new Pair<String,Integer>(new String("a"), new Integer(1)));
      list.add(new Pair<String,Integer>(new String("b"), new Integer(2)));
      list.add(new Pair<String,Integer>(new String("c"), new Integer(3)));

      FancyDict<String,Integer> dict33 = new FancyDictImpl3<String,Integer>();
      dict33.putAll(list);
      System.out.println(dict33.containsKey("a")); // prints true
      System.out.println(dict33.containsKey("ok")); // prints false
      System.out.println(dict33.containsKey("a")); // prints true
    }
}
