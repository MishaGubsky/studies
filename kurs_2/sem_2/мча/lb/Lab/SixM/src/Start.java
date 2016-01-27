import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Start {
	
	static double X0 = 0.47;
	static int N = 11;
	static double X[] = new double[12];
	static double Y[] = new double[12];
	static double P[] = new double[12];
	static int k = 12;
	static double m = 3.96;

	static void Yi(int i) {
		Y[i] = P[i] + Math.pow(-1, k) * m;
	}

	public static void Scan() {
		try (Scanner s = new Scanner(new File("matrix.txt"))) {
			int i;
			for (i = 0; i < N; i++)
				X[i] = s.nextFloat();
			
			for (i = 0; i < N; i++) {
				P[i] = s.nextFloat();
				Yi(i);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	static double Delta(double x){
		double temp=0;
		return temp;
	}
	
	public static void main(String[] args) {
		Scan();
		Lagr.Start();
		Niut.Start();
	}

}
