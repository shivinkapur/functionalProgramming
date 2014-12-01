/* Name: Shivin Kapur

   UID: 404259526

   Others With Whom I Discussed Things:

   Other Resources I Consulted: http://homes.cs.washington.edu/~djg/teachingMaterials/grossmanSPAC_forkJoinFramework.html
   http://www.drdobbs.com/jvm/lambdas-and-streams-in-java-8-libraries/240166818
*/

import java.io.*;
import java.util.Arrays;

import java.util.stream.*;
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.RecursiveAction;


// a marker for code that you need to implement
class ImplementMe extends RuntimeException {}

// an RGB triple
class RGB {
    public int R, G, B;

    RGB(int r, int g, int b) {
    	R = r;
    	G = g;
    	B = b;
    }

    public String toString() { return "(" + R + "," + G + "," + B + ")"; }

}

// code for creating a Gaussian filter
class Gaussian {

    protected static double gaussian(int x, int mu, double sigma) {
	     return Math.exp( -(Math.pow((x-mu)/sigma,2.0))/2.0 );
    }

    public static double[][] gaussianFilter(int radius, double sigma) {
    	int length = 2 * radius + 1;
    	double[] hkernel = new double[length];
    	for(int i=0; i < length; i++)
    	    hkernel[i] = gaussian(i, radius, sigma);
    	double[][] kernel2d = new double[length][length];
    	double kernelsum = 0.0;
    	for(int i=0; i < length; i++) {
    	    for(int j=0; j < length; j++) {
    		double elem = hkernel[i] * hkernel[j];
    		kernelsum += elem;
    		kernel2d[i][j] = elem;
	    }
  	}
  	for(int i=0; i < length; i++) {
  	    for(int j=0; j < length; j++)
  		    kernel2d[i][j] /= kernelsum;
  	}
  	return kernel2d;
  }
}

// an object representing a single PPM image
class PPMImage {
    protected int width, height, maxColorVal;
    protected RGB[] pixels;

    PPMImage(int w, int h, int m, RGB[] p) {
    	width = w;
    	height = h;
    	maxColorVal = m;
    	pixels = p;
    }

	// parse a PPM file to produce a PPMImage
    public static PPMImage fromFile(String fname) throws FileNotFoundException, IOException {
    	FileInputStream is = new FileInputStream(fname);
    	BufferedReader br = new BufferedReader(new InputStreamReader(is));
    	br.readLine(); // read the P6
    	String[] dims = br.readLine().split(" "); // read width and height
    	int width = Integer.parseInt(dims[0]);
    	int height = Integer.parseInt(dims[1]);
    	int max = Integer.parseInt(br.readLine()); // read max color value
    	br.close();

    	is = new FileInputStream(fname);
    	    // skip the first three lines
    	int newlines = 0;
    	while (newlines < 3) {
    	    int b = is.read();
    	    if (b == 10)
    		newlines++;
    	}

    	int MASK = 0xff;
    	int numpixels = width * height;
    	byte[] bytes = new byte[numpixels * 3];
            is.read(bytes);
    	RGB[] pixels = new RGB[numpixels];
    	for (int i = 0; i < numpixels; i++) {
    	    int offset = i * 3;
    	    pixels[i] = new RGB(bytes[offset] & MASK, bytes[offset+1] & MASK, bytes[offset+2] & MASK);
    	}

    	return new PPMImage(width, height, max, pixels);
    }

	// write a PPMImage object to a file
    public void toFile(String fname) throws IOException {
    	FileOutputStream os = new FileOutputStream(fname);

    	String header = "P6\n" + width + " " + height + "\n" + maxColorVal + "\n";
    	os.write(header.getBytes());

    	int numpixels = width * height;
    	byte[] bytes = new byte[numpixels * 3];
    	int i = 0;
    	for (RGB rgb : pixels) {
    	    bytes[i] = (byte) rgb.R;
    	    bytes[i+1] = (byte) rgb.G;
    	    bytes[i+2] = (byte) rgb.B;
    	    i += 3;
    	}
    	os.write(bytes);
    }

	// implement using Java 8 Streams
    public PPMImage negate() {
      RGB[] output_negate = new RGB[pixels.length];
      Stream<RGB> s = Arrays.stream(pixels)
                        .parallel()
                        .map(p -> new RGB(maxColorVal - p.R, maxColorVal - p.G, maxColorVal - p.B));
      RGB[] new_pixels = s.toArray(size -> new RGB[size]);
      return new PPMImage(width, height, maxColorVal, new_pixels);
    }

	// implement using Java's Fork/Join library
    public PPMImage mirrorImage() {
      RGB[] output_mirror = new RGB[pixels.length];
      MirrorTask mt = new MirrorTask(width, pixels, output_mirror, 0, pixels.length);
      mt.compute();
      // new ForkJoinPool().invoke(mt);
      return new PPMImage(width, height, maxColorVal, output_mirror);
    }

	// implement using Java's Fork/Join library
    public PPMImage gaussianBlur(int radius, double sigma) {
      RGB[] output_gaussian = new RGB[pixels.length];
      for(int i = 0; i < pixels.length; i++)
        output_gaussian[i] = pixels[i];
      double filter[][] = Gaussian.gaussianFilter(radius, sigma);
      GaussianTask gt = new GaussianTask(width, height, pixels, output_gaussian, 0, pixels.length, filter);
      gt.compute();
      return new PPMImage(width, height, maxColorVal, output_gaussian);
    }

	// implement using Java 8 Streams
    public PPMImage gaussianBlur2(int radius, double sigma) {
      // throw new ImplementMe();
      RGB[] output_gaussian = new RGB[pixels.length];
      for(int i = 0; i < pixels.length; i++)
        output_gaussian[i] = pixels[i];
      double filter[][] = Gaussian.gaussianFilter(radius, sigma);
      int[] result = IntStream
                    .range(0, pixels.length)
                    // .forEach()
                    // .map()
                    .toArray();
      return new PPMImage(width, height, maxColorVal, output_gaussian);
    }
}

class MirrorTask extends RecursiveAction {
  protected int low, high, width;
  protected RGB[] input, output;

  protected static final int SEQUENTIAL_CUTOFF = 1000;

  MirrorTask(int w, RGB[] ip, RGB[] op, int l, int h) {
    width = w;
    input = ip;
    output = op;
    low = l;
    high = h;
  }

  protected void compute() {
    if((high - low) <= SEQUENTIAL_CUTOFF) {
      for(int i = low; i < high; i++) {
        int column = i % width;
        int row = i / width;
        int mirror_column = width - column - 1;
        int index = row * width + mirror_column;
        output[index] = new RGB(input[i].R, input[i].G, input[i].B);
      }
      return;
    }

    int mid = (high + low)/2;
    MirrorTask left = new MirrorTask(width, input, output, low, mid);
    MirrorTask right = new MirrorTask(width, input, output, mid, high);

    left.fork();
    right.compute();
    left.join();
  }
}

class GaussianTask extends RecursiveTask<Void> {
  protected int low, high, width, height;
  protected RGB[] input, output;
  protected double[][] filter;

  protected static final int SEQUENTIAL_CUTOFF = 10000;

  GaussianTask(int w, int h, RGB[] ip, RGB[] op, int l, int hi, double[][] f) {
    width = w;
    height = h;
    input = ip;
    output = op;
    low = l;
    high = hi;
    filter = f;
  }

  protected Void compute() {
    int radius = (filter.length) / 2;
    if((high - low) <= SEQUENTIAL_CUTOFF) {
      for(int i = low; i < high; i++) {
        double R_blur = 0.0, G_blur = 0.0, B_blur = 0.0;
        int row = i / width;
        int column = i % width;
        for(int x = -radius; x <= radius; x++) {
          for(int y = -radius; y <= radius; y++) {
            int n_row = Math.min(Math.max(row + x, 0), height - 1);
            int n_col = Math.min(Math.max(column + y, 0), width - 1);
            RGB pixelsGauss = input[n_row * width + n_col];
            R_blur += pixelsGauss.R * filter[x+radius][y+radius];
            G_blur += pixelsGauss.G * filter[x+radius][y+radius];
            B_blur += pixelsGauss.B * filter[x+radius][y+radius];
          }
        }
        output[i] = new RGB((int) Math.round(R_blur), (int) Math.round(G_blur), (int) Math.round(B_blur));
      }
      return null;
    }

    int mid = (high + low)/2;
    GaussianTask left = new GaussianTask(width, height, input, output, low, mid, filter);
    GaussianTask right = new GaussianTask(width, height, input, output, mid, high, filter);

    left.fork();
    right.compute();
    left.join();

    return null;
  }
}


class Main {
  public static void main(String args[]) throws FileNotFoundException, IOException {
    PPMImage p = PPMImage.fromFile("florence.ppm");
    PPMImage p_negate = p.negate();
    p_negate.toFile("negate.ppm");
    PPMImage p_mirror = p.mirrorImage();
    p_mirror.toFile("mirror.ppm");
    PPMImage p_gaussian1 = p.gaussianBlur(10,2);
    p_gaussian1.toFile("gaussian1.ppm");
    PPMImage p_gaussian2 = p.gaussianBlur2(10,2);
    p_gaussian2.toFile("gaussian2.ppm");
  }
}
