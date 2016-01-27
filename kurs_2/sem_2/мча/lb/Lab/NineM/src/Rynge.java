
public class Rynge {

	static double K1(double xk, double yk, double hk){
		return hk*Start.Dy(xk, yk);
	}
	
	static double K2(double xk, double yk, double hk, double k1){
		return hk*Start.Dy(xk+hk/2, yk+k1/2);
	}
	
	static double K3(double xk, double yk, double hk, double k2){
		return hk*Start.Dy(xk+hk/2, yk+k2/2);
	}
	
	static double K4(double xk, double yk, double hk, double k3){
		return hk*Start.Dy(xk+hk, yk+k3);
	}
	
	static void PrintYX(double h){
		System.out.println("Подходящий шаг h = "+Start.round(h,4));
		double k1,k2,k3;
		double y=Start.yo;
		double x=Start.A+h;
		while (x<=Start.B){
			k1=K1(x,y,h);
			k2=K2(x,y,h,k1);
			k3=K3(x,y,h,k2);
			y=y+(k1+2*k2+2*k3+K4(x,y,h,k3))/6;
			System.out.println("при x = "+Start.round(x,4)+"     y = "+Start.round(y,4));
			x+=h;
		}
	}
	
	public static void Start() {
		double k1,k2,k3;
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
				k1=K1(x,y,h);
				k2=K2(x,y,h,k1);
				k3=K3(x,y,h,k2);
				y=y+(k1+2*k2+2*k3+K4(x,y,h,k3))/6;
				
				for(int i=0;i<2;i++){
					k1=K1(x,y2,h/2);
					k2=K2(x,y2,h/2,k1);
					k3=K3(x,y2,h/2,k2);
					y2=y2+(k1+2*k2+2*k3+K4(x,y2,h/2,k3))/6;
				}
				
				if(delta<Math.abs(y2-y))
					delta=Math.abs(y2-y);
				x+=h;
			}
		}
		PrintYX(h);		
	}

}
