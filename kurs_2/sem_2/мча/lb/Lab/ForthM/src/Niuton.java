public class Niuton {
	// tg(xy+m)=x
	// ax^2+2y^2=1

	// tg(x1*x2+m)-x1=0
	// a*x1^2+2*x2^2-1=0

	public static double m, a;

	private static double round(double number) {
		int scale = 4;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}
	
	public static double df11(double x1, double x2) {
		return x2 / Math.pow(Math.cos(x1 * x2 + m), 2) - 1;
	}

	public static double df12(double x1, double x2) {
		return x1 / Math.pow(Math.cos(x1 * x2 + m), 2);
	}

	public static double df21(double x1, double x2) {
		return 2 * a * x1;
	}

	public static double df22(double x1, double x2) {
		return 4 * x2;
	}

	public static double f1(double x1, double x2) {
		return Math.tan(x1 * x2 + m) - x1;
	}

	public static double f2(double x1, double x2) {
		return a * x1 * x1 + 2 * x2 * x2 - 1;
	}

	public static double Max(double a1, double a2) {
		return a1 > a2 ? a1 : a2;
	}

	public static void Start() {
		double[] X = { 0.7, 0.6 };
		int k;
		double delta, temp;
		a = Start.a[Iteration.z];
		m = Start.m[Iteration.z];
		delta = 100000;
		k = 0;
		while ((delta > Iteration.truth) && (k < 100)) {
			delta = X[0];
			temp = X[1];
			X[0] = delta
					- 1
					/ (df11(delta, temp) * df22(delta, temp) - df12(delta, temp)
							* df21(delta, temp))
					* (df22(delta, temp) * f1(delta, temp) - df12(delta, temp) * f2(delta, temp));
			X[1] = temp
					- 1
					/ (df11(delta, temp) * df22(delta, temp) - df12(delta, temp)
							* df21(delta, temp))
					* (-df21(delta, temp) * f1(delta, temp) + df11(delta, temp) * f2(delta, temp));

			delta = Max(Math.abs(delta - X[0]), Math.abs(temp - X[1]));
			k++;
		}

		System.out.println("Niuton method.");
		System.out.println(" i = " + k);
		System.out.println("x1 = " + round(X[0]));
		System.out.println("x2 = " + round(X[1]));
		System.out.println("===================================================");

	}
}
