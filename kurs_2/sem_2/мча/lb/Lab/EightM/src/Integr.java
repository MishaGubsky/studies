public class Integr {
	// пересчет N и H от погрешности
	static int N = 1000;
	static double h = (Start.b - Start.a) / N;

	private static double round(double number, int scale) {
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	static double F(double x) {
		return Math.sqrt(1 - Math.pow(Math.log10(x), 2));
	}

	static void Simps() {
		double temp = F(Start.a) + F(Start.b);
		N = 5;
		h = (Start.b - Start.a) / N;
		h = h / 2;
		for (int i = 1; i < N - 1; i++) {
			temp += 4 * F(Start.a + h * i * 2 - h) + 2 * F(Start.a + h * 2 * i);
		}
		temp += 4 * F(Start.a + h * (2 * N - 1));
		temp *= h / 3;
		double delta = 1;
		while (delta > Start.truthS) {
			delta = temp;
			temp = F(Start.a) + F(Start.b);
			N *= 2;
			h = (Start.b - Start.a) / N;
			h = h / 2;
			for (int i = 1; i < N - 1; i++) {
				temp += 4 * F(Start.a + h * i * 2 - h) + 2 * F(Start.a + h * 2 * i);
			}
			temp += 4 * F(Start.a + h * (2 * N - 1));
			temp *= h / 3;

			delta = Math.abs(delta - temp);
		}
		System.out.println("N = " + N + "     h = " + h);
		System.out.println("По формуле Симпсона интеграл = " + round(temp, 6));

	}

	static void Kvadr() {
		double temp = 0;
		N = 5;
		h = (Start.b - Start.a) / N;
		double delta = 1;

		for (int i = 0; i < N; i++) {
			temp += F(Start.a + h * i + h / 2);
		}
		temp *= h;

		while (delta > Start.truthS) {
			delta = temp;
			temp = 0;
			N *= 2;
			h = (Start.b - Start.a) / N;
			for (int i = 0; i < N; i++) {
				temp += F(Start.a + h * i + h / 2);
			}
			temp *= h;
			delta = Math.abs(delta - temp);
		}
		System.out.println("N = " + N + "     h = " + h);
		System.out.println("По формуле средних прямоугольников интеграл = " + round(temp, 6));
	}

	static void Trap() {
		double temp = 0;
		N = 5;
		h = (Start.b - Start.a) / N;
		for (int i = 0; i < N; i++) {
			temp += F(Start.a + h * i) + F(Start.a + h * (i + 1));
		}
		temp *= h / 2;
		double delta = 1;
		while (delta > Start.truthS) {
			delta = temp;
			temp = 0;
			N *= 2;
			h = (Start.b - Start.a) / N;
			for (int i = 0; i < N; i++) {
				temp += F(Start.a + h * i) + F(Start.a + h * (i + 1));
			}
			temp *= h / 2;
			delta = Math.abs(delta - temp);
		}
		System.out.println("N = " + N + "     h = " + h);
		System.out.println("По формуле трапециий интеграл = " + round(temp, 6));
	}

	public static void Start() {
		Kvadr();
		Trap();
		Simps();
		System.out.println("==============================================================");
	}

}
