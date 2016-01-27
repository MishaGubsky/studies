import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Start {
	static float a = -10;
	static float b = 10;
	static int N = 3;
	static float[][] index = new float[100][N + 1];

	public static void ScanNumber() {
		try (Scanner s = new Scanner(new File("matrix.txt"))) {

			index[0][3] = 1;
			index[0][2] = s.nextFloat();
			index[0][1] = s.nextFloat();
			index[0][0] = s.nextFloat();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		ScanNumber();
		First.Start(N);
		Second.Start(N);
		Third.Start(N);
	}

}
