/* Dynamic dispatch:

   dynamically on a message send, we find the right method to invoke
   based on the run-time class of the receiver object

*/

class C {
    void m() { System.out.println("C.m"); }
    void n() { this.m(); }

	// these methods are statically overloaded
    void p(C c) { System.out.println("CpC"); }
    void p(D d) { System.out.println("CpD"); }
}

class D extends C {
    void m() { System.out.println("D.m"); }

    	// these methods are statically overloaded
    void p(C c) { System.out.println("DpC"); }
    void p(D d) { System.out.println("DpD"); }

}

class Main {
    public static void main(String[] args) {
    	C c = new C();
    	D d = new D();
      c.p(c); // dynamic dispatch happens here
      c.p(d);
      System.out.println();
      c = d;
    	c.p(c);
    	c.p(d);

      System.out.println();
      C d2 = new D();
      C c2 = new C();
      d2.p(c);
      d2.p(d);
      System.out.println();
      c2 = d2;
      c2.p(c);
      c2.p(d);

      D d3 = new D();
      // d3 = d2; will give error
    }
}

/* Dynamic dispatch is a form of *dynamic* overloading:
   - multiple methods of the same name
   - resolved dynamically which one to invoke

   Static overloading
   - multiple methods of the same name
   - resolved statically based on the static types

   Java methods are dynamically dispatch on the receiver parameter
   Java methods can be statically overloaded on the other parameters
*/
