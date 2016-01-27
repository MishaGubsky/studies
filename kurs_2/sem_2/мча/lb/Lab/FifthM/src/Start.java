import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Scanner;


public class Start {

    static int Var=26-15;
	public static int N;
	static double A[][];
    static double D[][];
	static double C[][];
	
	static double round(double number) {
		int scale = 2;
		int pow = 10;
		for (int i = 1; i < scale; i++)
			pow *= 10;
		double tmp = number * pow;
		return (double) (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) / pow;
	}
	
	public static void GenerateMatrix(){
		int i,j;
		for (i = 0; i < N; i++){
			for (j = 0; j < N; j++){
					A[i][j]=C[i][j]*Var+D[i][j];
			}
		}
		PrintMatrix();
	}
	
	public static void PrintMatrix(){
		int i,j;
		for (i = 0; i < N; i++){
			for (j = 0; j < N; j++){
				if(round(A[i][j])==0)
					System.out.print("  " + round(A[i][j])+" ");
				else if((A[i][j])<0)
					System.out.print(" " + round(A[i][j]));
				else 
					System.out.print("  " + round(A[i][j]));
			}
			System.out.println();
		}

		System.out.println("-----------------------------------");
	}
	
	public static void ScanMainMatrix(){
		int i,j;
        try (Scanner s = new Scanner(new File("matrix.txt"))) {
        	N = s.nextInt();
        	C= new double[N+1][N+1];
        	D= new double[N+1][N+1];
        	A= new double[N+1][N+1];
        	
			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++){
						C[i][j]= s.nextFloat();
				}

			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++){
						D[i][j]= s.nextFloat();
				}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		ScanMainMatrix();
		GenerateMatrix();
		Iakobi.Start(A, N);
	}

}
