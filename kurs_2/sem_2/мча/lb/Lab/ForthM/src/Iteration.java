public class Iteration {
	// tg(x1*x2+m)=x1
	// ((a*x1^2-1)/2)^(1/2)=x2
	public static double m, a;
	public static double truth = 0.0001;
	public static int z = 12;

	private static double round(double number) {
		int scale = 4;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	public static double f1(double x1, double x2) {
		return Math.tan(x1 * x2 + m);
	}

	public static double f2(double x1, double x2) {
		return Math.abs(Math.sqrt((1-a*x1*x1)/2));
	}

	public static double Max(double a1, double a2) {
		return a1 > a2 ? a1 : a2;
	}

	public static void Start() {
		double[] X = {  0.7, 0.6 };
		int k;

		double delta, temp;
		a = Start.a[z];
		m = Start.m[z];
		delta = 100000;
		k = 0;
		while ((delta > truth) && (k < 1000000)) {
			temp = X[0];
			delta = X[1];
			X[0] = f1(X[0], X[1]);
			X[1] = f2(X[0], X[1]);
			delta = Max(Math.abs(delta - X[1]), Math.abs(temp - X[0]));
			k++;
		}

		if ((X[0] < 1000000) && (X[0] > 0) && (X[1] < 1000000) && (X[1] > 0)) {
			System.out.println("Iteration method.");
			System.out.println("i = " + k);
			System.out.println("x1 = " + round(X[0]));
			System.out.println("x2 = " + round(X[1]));
			System.out.println("===================================================");
		}

	}

	/*
	 * a=ac; m=mc; int i=0; double delta=1; double temp; double[] X=FindX0();
	 * 
	 * while ((delta>truth)&&(i<100)){ temp=X[0]; delta=X[1];
	 * X[0]=f1(X[0],X[1]); X[1]=f2(temp,X[1]);
	 * delta=Max(Math.abs(delta-X[1]),Math.abs(temp-X[0])); i++; }
	 * 
	 * System.out.println("Iteration method."); System.out.println(" i = "+i);
	 * System.out.println("x1 = "+X[0]); System.out.println("x2 = "+X[1]);
	 * System.out.println("=================");
	 */
}
