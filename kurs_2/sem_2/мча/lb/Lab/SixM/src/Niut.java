public class Niut {

	static double[][] df;

	static double f(int k, int k2) {
		double temp = 0;
		return temp;
	}

	static void GenerateDf() {
		int i, j;
		for (i = 0; i < Start.N; i++)
			df[0][i] = Start.Y[i];

		for (i = 1; i < Start.N; i++) {
			for (j = 0; j < Start.N - i; j++) {
				df[i][j] = (df[i - 1][j+1] - df[i - 1][j]);
			}

		}

		for (i = 1; i < Start.N; i++) {
			for (j = 0; j < Start.N - i; j++) {
				df[i][j] /= Start.X[j + i] - Start.X[j];
			}

		}
	}

	static void PrintDf() {
		int i, j;
		for (i = 0; i < Start.N; i++) {
			for (j = 0; j < Start.N - i; j++) {
				System.out.print(Lagr.round(df[i][j]) + "      ");
			}
			System.out.println();

		}
	}

	static void PrintNi() {
		int i, j;
		for (i = 0; i < Start.N; i++) {
			System.out.print(Lagr.round(df[i][0]));
			if (i > 0)
				System.out.print("*");
			for (j = 0; j < i; j++) {
				System.out.print("(x - " + Lagr.round(Start.X[j]) + ")");
			}
			if (i != Start.N - 1)
				System.out.println("+");
		}
		System.out.println();
	}
		
	static double Ni(double x) {
		int i, j;
		double temp=0;
		double delta;
		for (i = 0; i < Start.N; i++) {
			delta=df[i][0];
			for (j = 0; j < i; j++) {
				delta*=x-Start.X[j];
			}
			temp+=delta;
		}
		return temp;
	}
	
	static int fact(int i){
		int j,k=1;
		for (j=1;j<i;j++)
			k*=j;
		return k;
	}
	
	static double Pogr(double x){
		double temp=df[Start.N-1][0]/fact(Start.N)/Math.pow((Start.X[1]-Start.X[0]),Start.N);
		for(int i=0;i<Start.N;i++){
			temp*=(x-Start.X[i]);
		}
		return Math.abs(temp);
	}
	
	public static void Start() {
		df = new double[Start.N + 1][Start.N + 1];
		GenerateDf();
		System.out.println("------------------------------------------------------------------------------------------------------------------");
		PrintDf();
		System.out.println("------------------------------------------------------------------------------------------------------------------");
		PrintNi();
		System.out.println("------------------------------------------------------------------------------------------------------------------");
		System.out.println("При x = "+Start.X0+"	y = "+Lagr.round(Ni(Start.X0)));
		System.out.print("Погрешность = +- " + Lagr.round(Pogr(Start.X0)));
		
	}

}
