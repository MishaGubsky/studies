public class Deff {

	// пересчет N и H от погрешности
	static int N = 5;
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

	static void FirstDeff(double x) {
		double xt;
		double delta = 1;
		double temp = 0;
		while (delta > Start.truthF) {
			xt = Start.a;
			while (xt < x) {
				xt += h;
			}
			delta = (F(xt) - F(xt - 2 * h)) / 2 / h;
			N *= 2;
			h = (Start.b - Start.a) / N;
			xt = Start.a;
			while (xt < x) {
				xt += h;
			}
			temp = (F(xt) - F(xt - 2 * h)) / 2 / h;

			delta = Math.abs(delta - temp);
			;
		}
		System.out.println("N = " + N);
		System.out.println("y'=" + round(temp, 4) + "    при x=" + round(x, 2) + "     при h="
				+ round(h, 4));
	}

	static void SecondDeff(double x) {
		double xt;
		double delta = 1;
		double temp = 0;
		while (delta > Start.truthF) {
			xt = Start.a;
			while (xt < x) {
				xt += h;
			}
			delta = (F(xt) - 2 * F(xt - h) + F(xt - 2 * h)) / h / h;
			N *= 2;
			h = (Start.b - Start.a) / N;
			xt = Start.a;
			while (xt < x) {
				xt += h;
			}
			temp = (F(xt) - 2 * F(xt - h) + F(xt - 2 * h)) / h / h;

			delta = Math.abs(delta - temp);
			;
		}
		System.out.println("N = " + N);
		System.out.println("y''=" + round(temp, 4) + "    при x=" + round(x, 2) + "     при h="
				+ round(h, 4));
	}

	public static void Start() {
		FirstDeff((Start.b - Start.a) / 2);
		SecondDeff((Start.b - Start.a) / 2);
		System.out.println("==============================================================");
	}

}
