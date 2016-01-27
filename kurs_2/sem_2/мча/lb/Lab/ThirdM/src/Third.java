public class Third {
	public static int N;
	public static double truth = 0.0001;

	private static float round(float number) {
		int scale=4;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		float tmp = number * pow;
		return (float) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}
	
	public static float Substitution(int k, float n) {
		float temp = Start.index[k][0];
		for (int i = 1; i < N + 1; i++)
			temp += Start.index[k][i] * (Math.pow(n, i));
		return temp;
	}

	public static void H1(int i) {
		int j = 0;
		float delta = 1;
		float x = Second.deltaX[i][1];
		float a = Second.deltaX[i][0];
		while ((Math.abs(delta) > truth) && (j < 100)) {
			j++;
			delta = x;
			x = x - Substitution(0, x) / (Substitution(0, a) - Substitution(0, x)) * (a - x);
			delta -= x;
		}
		System.out.println("X= " + round(x) + "      i=" + j);
	}

	public static void H2(int i) {
		int j = 0;
		float delta = 1;
		float x = Second.deltaX[i][0];
		float b = Second.deltaX[i][1];
		while ((Math.abs(delta) > truth) && (j < 100)) {
			j++;
			delta = x;
			x = x - Substitution(0, x) / (Substitution(0, b) - Substitution(0, x)) * (b - x);
			delta -= x;
		}
		System.out.println("X= " + round(x) + "      i=" + j);
	}

	public static void Hord(int j) {
		if (Substitution(2, Second.deltaX[j][0]) * Substitution(0, Second.deltaX[j][0]) >= 0)
			H1(j);
		else
			H2(j);
	}

	public static void Niuton(int i) {
		float x = Second.deltaX[i][0];
		int j = 0;
		float delta = 1;
		while ((Math.abs(delta) > truth) && (j < 100)) {
			j++;
			delta = x;
			x = x - Substitution(0, x) / Substitution(1, x);
			delta -= x;
		}
		System.out.println("X= " + round(x) + "      i=" + j);
	}

	public static void Half(int i) {
		int h = 0;
		float a = Second.deltaX[i][0];
		float b = Second.deltaX[i][1];
		float x = 0;
		while (h<1000) {
			x = (a + b) / 2;
			 
			h++;
			if (Math.abs(x - a) <= truth)
				break;
			else if (Substitution(0, x) * Substitution(0, a) < 0)
				b = x;
			else if (Substitution(0, x) * Substitution(0, a) > 0)
				a = x;
			else break;
		}
		System.out.println("X= " + round(x) + "      i=" + h);
	}

	public static void Start(int num) {
		N = num;
		Start.index[2] = First.GetDerivate(1);
		int j;
		for (j = 0; j < Second.I; j++)
			Half(j);
		System.out.println("---|End Half Method|--------------------------");

		for (j = 0; j < Second.I; j++)
			Hord(j);
		System.out.println("---|End Hord Method|--------------------------");

		for (j = 0; j < Second.I; j++)
			Niuton(j);
		System.out.println("---|End Niuton Method|------------------------");
	}
}
