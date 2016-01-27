public class Second {
	public static int N;
	public static float[][] deltaX;
	public static int I;
	public static float h=(float)0.1;
	
	public static float Substitution(int k, float n) {
		float temp = Start.index[k][0];
		for (int i = 1; i < N + 1; i++)
			temp += Start.index[k][i] * (Math.pow(n, i));
		return temp;
	}

	private static float round(float number, int scale) {
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		float tmp = number * pow;
		return (float) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	public static void Start(int num) {
		N = num;
		float q = Start.a;
		I = 0;
		deltaX = new float[First.K][2];
		while (q <= Start.b - 0.01) {
			if (Substitution(0, q) * Substitution(0, q + h) <= 0) {
				deltaX[I][0] = round(q - h, 1);
				deltaX[I][1] = round(q + h, 1);
				I++;
			}
			q = q + h;
		}
		for (int j = 0; j < I; j++)
			System.out.println(deltaX[j][0] + " <= x <= " + deltaX[j][1]);
		System.out.println("------------------------------------------------------------");

	}
}
