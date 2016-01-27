public class Start {

	static double a = 1.1;
	static double m = 2.0;
	static double yo = 0;
	static double truth = 0.001;
	static double A = 0;
	static double B = 1;

	static void PrintYX(double h) {
		System.out.println("Подходящий шаг h = " + Start.round(h, 4));
		double x;
		double y, y1;
		double temp;
		y1 = Start.yo;
		x = Start.A;
		y = YnextA(x + h, Start.yo, h);
		x += h;

		while (x <= Start.B) {
			y1 = Ynext(y, h, x, y1, x + h);
			temp = y1;
			y1 = y;
			y = temp;
			System.out.println("при x = " + Start.round(x, 4) + "     y = " + Start.round(y, 4));
			x += h;
		}
	}

	static double YnextA(double xk, double yk, double hk) {
		return yk + hk * Start.Dy(xk + hk / 2, yk + hk / 2 * Start.Dy(xk, yk));
	}

	static double round(double number, int scale) {
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	static double Ynext(double yk, double hk, double xk, double xk_1, double yk_1) {
		return yk + hk * (1.5 * Dy(xk, yk) - 0.5 * Dy(xk_1, yk_1));
	}

	static double Dy(double x, double y) {
		return a * (1 - y * y) / (1 + m) / (x * x + y * y + 1);
	}

	public static void main(String[] args) {
		double x;
		double y, y1, yh, yh1;
		double delta = 1;
		double h = 1;
		double temp;
		while (delta > Start.truth) {
			h /= 2;
			delta = 0;
			y1 = Start.yo;
			yh1 = Start.yo;

			x = Start.A;
			y = YnextA(x + h, Start.yo, h);
			yh = YnextA(x + h / 2, Start.yo, h / 2);
			yh = YnextA(x + h / 2, yh, h / 2);
			x += h;

			while (x <= Start.B) {
				y1 = Ynext(y, h, x, y1, x + h);
				yh1 = Ynext(yh, h / 2, x, yh1, x + h / 2);

				temp = yh1;
				yh1 = yh;
				yh = temp;
				yh1 = Ynext(yh, h / 2, x, yh1, x + h / 2);

				if (delta < Math.abs(yh - y))
					delta = Math.abs(yh - y);
				x += h;
				temp = y1;
				y1 = y;
				y = temp;

				temp = yh1;
				yh1 = yh;
				yh = temp;

			}
		}

		PrintYX(h);
	}

}
