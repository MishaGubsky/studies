public class First {

	public static int N;
	public static int K;

	public static float[] GetDerivate(int j) {
		float[] temp = new float[N + 1];
		for (int i = 1; i <= N; i++) {
			temp[i - 1] = Start.index[j][i] * i;
		}
		temp[N] = 0;
		return temp;
	}

	public static boolean NotEndNull(int k) {
		for (int i = 0; i < N + 1; i++)
			if (Start.index[k][i] != 0)
				return true;
		return false;
	}

	public static boolean CanDiv(float[] m, int k) {
		int i, j;
		for (i = N; i >= 0; i--)
			if (Start.index[k][i] != 0)
				break;
		for (j = N; j >= 0; j--)
			if (m[j] != 0)
				break;

		if (j < i)
			return false;

		return true;
	}

	public static float[] DivOneStep(float[] m, int k) {
		int i, j;
		for (i = N; i >= 0; i--)
			if (Start.index[k][i] != 0)
				break;
		for (j = N; j >= 0; j--)
			if (m[j] != 0)
				break;
		float delta = m[j] / Start.index[k][i];
		m[j] = 0;
		j--;
		i--;
		while ((i >= 0) && (j >= 0)) {
			m[j] -= Start.index[k][i] * delta;
			i--;
			j--;
		}
		return m;
	}

	public static float[] DivIndex(int k) {
		int i;
		float[] temp = new float[N + 1];
		for (i = 0; i < N + 1; i++)
			temp[i] = Start.index[k - 1][i];

		while (CanDiv(temp, k)) {
			temp = DivOneStep(temp, k);
		}
		for (i = 0; i < N + 1; i++)
			temp[i] *= -1;
		return temp;
	}

	public static void PrintLine(int k) {
		for (int i = N; i >= 0; i--)
			System.out.print(Start.index[k][i] + "*x^" + i + "     ");
		System.out.println();
	}

	public static float Substitution(int k, float n) {
		float temp = Start.index[k][0];
		for (int i = 1; i < N + 1; i++)
			temp += Start.index[k][i] * (Math.pow(n, i));
		return temp;
	}

	public static int HowMachChange(float n, int k) {
		int i = 0;
		for (int j = 1; j < k; j++) {
			if (Substitution(j, n) * Substitution(j - 1, n) < 0)
				i++;
		}
		return i;
	}

	public static void Start(int num) {
		N = num;
		Start.index[1] = GetDerivate(0);
		K = 1;
		while ((NotEndNull(K)) && (K < 100)) {
			Start.index[K + 1] = DivIndex(K);
			K++;
		}
		for (int i = 0; i < K; i++)
			PrintLine(i);
		System.out.println("------------------------------------------------------------");

		int Na = HowMachChange(Start.a, K);
		int Nb = HowMachChange(Start.b, K);
		System.out.println(Na + " - " + Nb + " = " + (Na - Nb));
		System.out.println("------------------------------------------------------------");
	}
}
