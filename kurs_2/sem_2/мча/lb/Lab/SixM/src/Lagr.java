public class Lagr {

	static double round(double number) {
		int scale = 4;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}
	
	static double round2(double number) {
		int scale = 6;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	public static void Printlj(int j) {
		double temp = 1;
		int i;
		for (i = 0; i < Start.N; i++) {
			if (i != j) {
				if (Start.X[i] > 0)
					System.out.print("(x - " + round(Start.X[i]) + " )");
				else
					System.out.print("(x + " + round(-Start.X[i]) + " )");
				temp = temp * (Start.X[j] - Start.X[i]);
			}
		}
		System.out.print("/(" + round2(temp) + ")*");
	}

	public static void PrintL() {
		int i;
		for (i = 0; i < Start.N; i++) {

			Printlj(i);
			if (i != Start.N - 1)
				System.out.println(round(Start.Y[i]) + " +");
			else

				System.out.println(round(Start.Y[i]));
		}
	}

	public static double lj(int j, double x) {
		double temp = 1;
		int i;
		for (i = 0; i < Start.N; i++) {
			if (i != j)
				temp = temp * (x - Start.X[i]) / (Start.X[j] - Start.X[i]);
		}
		return temp;
	}

	public static double L(double x) {
		int i;
		double temp = 0;
		for (i = 0; i < Start.N; i++)
			temp += lj(i, x) * Start.Y[i];
		return temp;
	}

	public static void Start() {
		System.out.println("Интерполяционный многочлен Лагранжа");
		PrintL();
		System.out.println("При x = " + Start.X0 + "	y = " + round(L(Start.X0)));
		System.out.println("------------------------------------------------------------------------------------------------------------------");

	}

}
