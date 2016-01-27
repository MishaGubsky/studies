public class Iakobi {

	public static double truth = 0.0001;
	public static double[][] A;
	public static double[][] A2;
	public static int N;

	public static int[] MaxAboveDiagonal() {
		int[] index = { 0, 1 };
		int i, j;
		for (i = 0; i < N; i++) {
			for (j = i + 1; j < N; j++) {
				if (Math.abs(A[i][j]) >= Math.abs(A[index[0]][index[1]])) {
					index[0] = i;
					index[1] = j;
				}
			}
		}
		return index;
	}

	public static double GetKvadr() {
		double delta = 0;
		int i, j;
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				if (i != j)
					delta += A[i][j] * A[i][j];
			}
		}
		return delta;
	}

	public static void Copy(boolean line) {
		int i, j;
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				if (line)
					A2[i][j] = A[i][j];
				else
					A[i][j] = A2[i][j];

			}
		}
	}

	public static void Start(double[][] Ac, int num) {
		A = Ac;
		N = num;
		int i = 0, s;
		double p, cos, sin;
		double delta;
		int[] index = new int[2];
		A2 = new double[N + 1][N + 1];

		while ((GetKvadr() > truth) && (i < 1000)) {
			i++;
			index = MaxAboveDiagonal();

			p = 2 * A[index[0]][index[1]] / (A[index[0]][index[0]] - A[index[1]][index[1]]);
			Copy(true);

			delta = 1 / Math.sqrt(1 + p * p);
			cos = Math.sqrt(0.5 * (1 + delta));
			sin = Math.sqrt(0.5 * (1 - delta));

			A2[index[0]][index[0]] = cos * cos * A[index[0]][index[0]] - 2 * cos * sin
					* A[index[0]][index[1]] + sin * sin * A[index[1]][index[1]];
			A2[index[1]][index[1]] = sin * sin * A[index[0]][index[0]] + 2 * cos * sin
					* A[index[0]][index[1]] + cos * cos * A[index[1]][index[1]];

			A2[index[0]][index[1]] = (cos * cos - sin * sin) * A[index[0]][index[1]] + cos * sin
					* (A[index[0]][index[0]] - A[index[1]][index[1]]);
			A2[index[1]][index[0]] = (cos * cos - sin * sin) * A[index[0]][index[1]] + cos * sin
					* (A[index[0]][index[0]] - A[index[1]][index[1]]);

			for (s = 0; s < N; s++) {
				if ((s != index[1]) && (s != index[0])) {
					A2[index[0]][s] = cos * A[index[0]][s] - sin * A[index[1]][s];
					A2[s][index[0]] = cos * A[index[0]][s] - sin * A[index[1]][s];

					A2[index[1]][s] = sin * A[index[0]][s] + cos * A[index[1]][s];
					A2[s][index[1]] = sin * A[index[0]][s] + cos * A[index[1]][s];
				}
			}
			Copy(false);
		}

		System.out.println("  i = " + i);
		System.out.println("-----------------------------------");
		Start.PrintMatrix();
		System.out.println("Собственные значения");
		for(i=0;i<N;i++)
			System.out.print(" "+Start.round(A[i][i])+"  ");
		System.out.println();
		System.out.println("-----------------------------------");
		System.out.println("Собственные векторы");
		for(i=0;i<N;i++){
			System.out.print("V["+i+"] = { "+Start.round(A[i][0]));
			for(s=1;s<N;s++)
			System.out.print(", "+Start.round(A[i][s]));
			System.out.println("}");
		}
		System.out.println("-----------------------------------");
		
	}

}
