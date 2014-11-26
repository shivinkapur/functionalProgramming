import java.util.concurrent.RecursiveTask;
import java.util.*;
// import java.util.Stream;
import java.util.Arrays;

class SumTask extends RecursiveTask<Long> {
	protected int[] arr;
	protected int low;
	protected int hi;

	protected static final int SEQUENTIAL_CUTOFF = 1000; 
	// it is said that thumb of rule is that each thread has 10000 things to do

	public SumTask(int[] arr, int low, int hi) {
		this.arr = arr;
		this.low = low;
		this.hi = hi;
	}

	// public Long compute() {
	// 	Long sum = 0;
	// 	for (int i=low;i<hi;i++) {
	// 		sum += arr[i];
	// 	}
	// 	return sum;
	// }

	public Long compute() {
		if(hi - low < SEQUENTIAL_CUTOFF) {
			Long sum = (long)0;
			for (int i=low;i<hi;i++) {
				sum += arr[i];
			}
			return sum;
		}
		int mid = (low+hi)/2;
		SumTask t1 = new SumTask(arr,low,mid);
		SumTask t2 = new SumTask(arr,mid,hi);

			// run t1's compute method in another thread
		t1.fork();
		// t2.fork();
		Long l2 = t2.compute(); 
		
			// wait for t1 to finish and get its result
		Long l1 = t1.join(); // ordering of fork and join is important.
		// Long l2 = t2.join();
		
		// Don't do something like this
		// Long l1 = t1.compute();
		// Long l2 = t2.compute();
		
		return l1+l2;
	}
}

class Main {
	public static void main(String[] args) {
		int size = Integer.parseInt(args[0]);
		int a[] = new int[size];

		for (int i=0;i<size;i++) {
			a[i] = i;
		}
		SumTask t = new SumTask(a,0,size);
		Long l = t.compute();
		System.out.println(l);
	}
}

class Main2 {
	public static void main(String[] args) {
		int size = Integer.parseInt(args[0]);
		int a[] = new int[size];

		for (int i=0;i<size;i++) {
			a[i] = i;
		}
		// IntStream s =
		int i =
			Arrays.stream(a)
			.parallel()
			.sum();
	}
}