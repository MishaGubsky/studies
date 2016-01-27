
public class Start {

	static double a=1.1;
	static double m=2.0;
	static double yo=0;
	static double truth=0.001;
	static double A=0;
	static double B=1;
	
	static double round(double number, int scale) {
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}

	static double Dy(double x, double y){
		return a*(1-y*y)/(1+m)/(x*x+y*y+1);
	}
	
	
	public static void main(String[] args) {
		System.out.println("============================");
		System.out.println("Метод Эйлера");
		Ailer.Start();
		System.out.println("============================");
		System.out.println("Метод Рунге-Кутта");
		Rynge.Start();
	}

}
