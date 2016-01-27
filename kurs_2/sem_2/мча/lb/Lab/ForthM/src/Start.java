import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;


public class Start {
//	tg(xy+m)=x
//	ax^2+2y^2=1
	
//	tg(x1*x2+m)=x1
//	((a*x1^2-1)/2)^(1/2)=x2
	
//	пусть x10=1 x20=1 
//	  где x>0, y>0,
	  
	public static double a[]=new double[14];
	public static double m[]=new double[14];
	
	
	public static void Scan(){
		int i;
        try (Scanner s = new Scanner(new File("matrix.txt"))) {
        	for(i=0;i<14;i++)
        		m[i] = s.nextFloat();
        	for(i=0;i<14;i++)
            	a[i] = s.nextFloat();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		Scan();
		Iteration.Start();
		Niuton.Start();
	}

}
