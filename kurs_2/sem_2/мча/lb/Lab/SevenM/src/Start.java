public class Start {

	// arctg(x) 0,2 6 0.7854
	// точек всего 6+1 поэтому отрезков 6. Поэтому мы ищем С1 - С6
	static double a = 0;
	static double b = 2;
	static double x = 0.5 * (b - a);
	static int N = 7;
	static double h;

	static double Xi[] = new double[N + 2];
	static double Yi[] = new double[N + 2];
	static double K[][] = new double[N + 2][4];

	static double A[][] = new double[N + 2][N + 2]; // xi => ci
	static double B[] = new double[N + 2];

	private static double round(double number, int scale) {
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	static double F(double x) {
		return Math.atan(x);
	}

	static double di(double ci, double ci1) {
		return (ci1 - ci) / h / 3;
	}

	static double ai(int i) {
		return Yi[i - 1];
	}

	static double bi(int i, double ci, double ci1) {
		return (Yi[i] - Yi[i - 1]) / h - ci * h - (ci1 - ci) * h / 3;
	}

	static void GenerateK(double[] c) {
		for (int i = 1; i <= N; i++) {
			K[i][0] = ai(i);
			K[i][1] = bi(i, c[i], c[i + 1]);
			K[i][2] = c[i];
			K[i][3] = di(c[i], c[i + 1]);

		}
	}

	static void PrintPoints() {
		for (int i = 0; i <= N; i++) {
			System.out.println("x = " + round(Xi[i], 2) + "     y = " + round(Yi[i], 2));
		}
	}

	static void CreateDiagMatrix() {
		int i, j;
		for (i = 1; i <= N; i++) {
			A[i][i - 1] = h / 3;
			A[i][i] = h / 3 * 4;
			A[i][i + 1] = h / 3;
			B[i] = (Yi[i + 1] - 2 * Yi[i] + Yi[i - 1]) / h;
		}
	}

	static void PrintDiagMatrix() {
		int i, j;
		for (i = 1; i <= N; i++) {
			for (j = 1; j <= N; j++) {
				System.out.print(round(A[i][j], 3) + "   ");
			}
			System.out.println("   || " + round(B[i], 3));
		}
	}

	static void SolveDiagMatrix() {
		double[] c = new double[N + 3];
		// нужен метод гаусса

		int k, j, i;
		double delta = 0;
		for (k = 1; k <= N; k++) {
			for (i = k + 1; i <= N; i++) {
				if ((A[i][k] != 0) && (A[k][k] != 0))
					delta = A[i][k] / A[k][k];
				else
					delta = 0;
				B[i] -= B[k] * delta;
				for (j = k; j <= N; j++) {
					A[i][j] -= A[k][j] * delta;
				}
			}
		}
		// теперь она угловая;

		delta = 0;
		for (k = N; k >= 1; k--) {
			for (i = k - 1; i >= 1; i--) {
				if ((A[i][k] != 0) && (A[k][k] != 0))
					delta = A[i][k] / A[k][k];
				else
					delta = 0;
				B[i] -= B[k] * delta;
				for (j = 2; j <= N; j++) {
					A[i][j] -= A[k][j] * delta;
					if (Math.abs(A[i][j]) < 1E-5)
						A[i][j] = 0;
				}
			}
		}

		for (j = 1; j <= N; j++) {
			c[j] = B[j] / A[j][j];
		}
		// конец гаусса
		GenerateK(c);
	}

	static void Generate() {
		h = (b - a) / (N);
		int c = 0;
		double temp = a;
		while (temp <= b) {
			Xi[c] = temp;
			Yi[c] = F(temp);
			temp += h;
			c++;
		}
	}

	static void PrintSplain() {
		int i, j;
		for (i = 1; i <= N; i++) {
			System.out.println("При x = " + round(Xi[i - 1], 2) + " ... " + round(Xi[i], 2));
			for (j = 0; j < 4; j++) {
				System.out.print(round(K[i][j], 2) + "*(x-"+round(Xi[i - 1], 2)+")^" + j + "  +  ");
			}
			System.out.println("  = Y" + i);
			System.out.println();
		}
	}

	static double S(double x, int i) {
		int j;
		double temp = 0;
		for (j = 0; j < 4; j++) {
			temp += K[i][j] * Math.pow(x, j);
		}

		return temp;
	}

	public static void main(String[] args) {
		Generate();
		PrintPoints();
		System.out
				.println("=======================================================================");
		CreateDiagMatrix();
		PrintDiagMatrix();
		System.out
				.println("=======================================================================");
		SolveDiagMatrix();
		PrintSplain();
		System.out
				.println("=======================================================================");
		System.out.println("Через функцию: x = " + round(x, 2) + "    y = " + +round(F(x), 4));
		System.out.println("Через сплайн для 4 отрезка : x = " + round(x, 2) + "    y = " + +round(S((x-Xi[3]), 4), 4));
	}

}
