import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Scanner;

public class Start {
	static int Var = 26 - 15;
	public static int N;
	static float A[][];
	static float D[][];
	static float B[];
	static float Bc[];
	static float C[][];

	static float X[];

	public static void GenerateMatrix() {
		int i, j;
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				A[i][j] = C[i][j] * Var + D[i][j];
			}
			B[i] = Bc[i];
		}
	}

	public static void PrintMatrix() {
		int i, j;
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				System.out.print(" " + A[i][j]);
			}
			System.out.println("   " + B[i]);
		}

		System.out.println("------------------------------------");
	}

	public static void ChangeMatrix() {
		int i, j;
		float delta;
		for (i = 0; i < N; i++) {
			delta = A[i][i];
			for (j = 0; j < N; j++) {
				A[i][j] = -A[i][j] / delta;
			}
			B[i] = B[i] / delta;
		}
		for (i = 0; i < N; i++) {
			A[i][i] += 1;
		}
	}

	public static float Step(float delta) {
		int i, j;
		float temp;
		float X1[] = new float[N + 1];
		for (i = 0; i < N; i++) {
			temp = X[i];
			X1[i] = 0;

			for (j = 0; j < N; j++)
				X1[i] += A[i][j] * X[j];

			X1[i] += B[i];
			if (Math.abs(delta) < Math.abs(X1[i] - temp))
				delta = X1[i] - temp;
		}

		for (i = 0; i < N; i++)
			X[i] = X1[i];
		return delta;
	}

	public static float ZedStep(float delta) {
		int i, j;
		float temp;
		for (i = 0; i < N; i++) {
			temp = X[i];
			X[i] = 0;

			for (j = 0; j < N; j++)
				if (j == i)
					X[i] += A[i][j] * temp;
				else
					X[i] += A[i][j] * X[j];

			X[i] += B[i];
			if (Math.abs(delta) < Math.abs(X[i] - temp))
				delta = X[i] - temp;
		}
		return delta;
	}

	public static void PrintX() {
		int i;
		for (i = 0; i < N; i++)
			System.out.println(X[i]);
	}

	public static void Iteration() throws IOException {
		ChangeMatrix();
		PrintMatrix();
		int i;
		for (i = 0; i < N; i++)
			X[i] = 1;
		float delta = 1;
		i = 0;
		while ((Math.abs(delta) > 0.0001) && (i < 100)) {
			delta = 0;
			delta = Step(delta);
			i++;
		}
		System.out.println("-|" + i + "|-------------------------------");
	}

	public static void ZedIteration() throws IOException {
		ChangeMatrix();
		PrintMatrix();
		int i;
		for (i = 0; i < N; i++)
			X[i] = 1;
		float delta = 1;
		i = 0;
		while ((Math.abs(delta) > 0.0001) && (i < 100)) {
			delta = ZedStep(0);
			i++;
		}
		System.out.println("-|" + i + "|-------------------------------");
	}

	public static void ScanMainMatrix() {
		int i, j;
		try (Scanner s = new Scanner(new File("matrix.txt"))) {
			N = s.nextInt();
			C = new float[N + 1][N + 1];
			D = new float[N + 1][N + 1];
			A = new float[N + 1][N + 1];
			B = new float[N + 1];
			Bc = new float[N + 1];
			X = new float[N + 1];

			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++) {
					C[i][j] = s.nextFloat();
				}

			for (i = 0; i < N; i++)
				for (j = 0; j < N; j++) {
					D[i][j] = s.nextFloat();
				}

			for (j = 0; j < N; j++) {
				Bc[j] = s.nextFloat();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static void SecondMetod() throws IOException {

	}

	public static void main(String[] args) throws NumberFormatException, IOException {

		ScanMainMatrix();
		GenerateMatrix();
		PrintMatrix();
		System.out.println("\n|===|FIRST METOD|=========================================|");
		Iteration();
		PrintX();

		GenerateMatrix();
		System.out.println("\n|===|SECOND METOD|========================================|");
		ZedIteration();
		SecondMetod();
		PrintX();
	}

}
