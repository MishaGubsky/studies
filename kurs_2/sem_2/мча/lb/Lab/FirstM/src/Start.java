import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Scanner;


public class Start {

    static int Var=26-15;
	public static int N;
	static float A[][];
    static float D[][];
	static float B[];
	static float Bc[];
	static float C[][];
	
	public static void GenerateMatrix(){
		int i,j;
		for (i = 0; i < N; i++){
			for (j = 0; j < N; j++){
					A[i][j]=C[i][j]*Var+D[i][j];
			}
			B[i]=Bc[i];
		}
	}
	
	public static void PrintMatrix(){
		int i,j;
		for (i = 0; i < N; i++){
			for (j = 0; j < N; j++){
					System.out.print(" " + A[i][j]);
			}
			System.out.println("   "+B[i]);
		}

        System.out.println("------------------------------------");
	}

	public static void FirstMetod() throws IOException{
		int i,j,k;		
		
        float delta = 0;
        for (k = 0; k < N; k++){
        	for (i = k+1; i < N; i++){
        		if ((A[i][k]!=0)&&(A[k][k]!=0)) delta=A[i][k]/A[k][k];
        		else
        			delta=0;
        		B[i]-=B[k]*delta;
				for (j = k; j < N; j++){
					A[i][j]-=A[k][j]*delta;
				}
        	}
        }
             
        EndMethod();
	}
	
	public static void ScanMainMatrix(){
		int i,j;
        try (Scanner s = new Scanner(new File("matrix.txt"))) {
        	N = s.nextInt();
        	C= new float[N+1][N+1];
        	D= new float[N+1][N+1];
        	A= new float[N+1][N+1];
        	B= new float[N+1];
        	Bc= new float[N+1];
        	
			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++){
						C[i][j]= s.nextFloat();
				}

			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++){
						D[i][j]= s.nextFloat();
				}

			for (j = 0; j < N; j++){
					Bc[j]= s.nextFloat();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static void EndMethod(){
		int i,j,k;
		float delta = 0;
        for (k = N-1; k >= 0; k--){
        	for (i = k-1; i >= 0; i--){
        		if ((A[i][k]!=0)&&(A[k][k]!=0)) delta=A[i][k]/A[k][k];
        		else
        			delta=0;
        		B[i]-=B[k]*delta;
				for (j = 1; j < N; j++){
					A[i][j]-=A[k][j]*delta;
					if (Math.abs(A[i][j])<1E-5 ) A[i][j]=0;
				}
        	}
        }
        
		PrintMatrix();
        for (j = 0; j < N; j++){
			System.out.println(B[j]/A[j][j]);
		}
	}
	
	public static int MaxInColum(int k){
		int m = k;
		for (int i=k+1; k<N; k++){
			if (Math.abs(A[i][k])>A[i][m]) m=k;
		}
		return m;
	}
	
	public static boolean ChangeRow(int k, int m){
		if (k==m) return true;
		float temp;
		for(int i=0;i<N;i++){
			temp=A[k][i];
			A[k][i]=A[m][i];
			A[m][i]=temp;
		}
		temp=B[k];
		B[k]=B[m];
		B[m]=temp;
		return false;
	}
	
	public static void SecondMetod() throws IOException{
		GenerateMatrix();
		int i,j,k;
		float delta = 0;
	       for (k = 0; k < N; k++){
	    	   	ChangeRow(k,MaxInColum(k));
	        	for (i = k+1; i < N; i++){
	        		if ((A[i][k]!=0)&&(A[k][k]!=0)) delta=A[i][k]/A[k][k];
	        		else
	        			delta=0;
	        		B[i]-=B[k]*delta;
					for (j = k; j < N; j++){
						A[i][j]-=A[k][j]*delta;
					}
	        	}
	        }
	        
	        EndMethod();
	        System.in.read();
	}
	
	public static void main(String[] args) throws NumberFormatException, IOException {     
        
		ScanMainMatrix();
        GenerateMatrix();
        PrintMatrix(); 
        System.out.println("\n|===|FIRST METOD|=========================================|");
        FirstMetod();
         
        System.out.println("\n|===|SECOND METOD|========================================|");
        SecondMetod();
	}

}
