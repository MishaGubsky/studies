
public class Ailer {
	static double Ynext(double xk, double yk, double hk){
		return yk+hk*Start.Dy(xk+hk/2, yk+hk/2*Start.Dy(xk,yk));
	}
	
	static void PrintYX(double h){
		System.out.println("Подходящий шаг h = "+Start.round(h,4));
		double y=Start.yo;
		double x=Start.A+h;
		while (x<=Start.B){
			y=Ynext(x,y,h);
			System.out.println("при x = "+Start.round(x,4)+"     y = "+Start.round(y,4));
			x+=h;
		}
	}
	
	public static void Start() {
		double x;
		double y,y2;
		double delta=1;
		double h=2;
		while (delta>Start.truth){
			h/=2;
			delta=0;
			y=Start.yo;
			y2=Start.yo;
			x=Start.A+h;
			while (x<=Start.B){
				y=Ynext(x,y,h);
				y2=Ynext(x,y2,h/2);
				y2=Ynext(x+h/2,y2,h/2);
				if(delta<Math.abs(y2-y))
					delta=Math.abs(y2-y);
				x+=h;
			}
		}
		
		PrintYX(h);
	}

}
