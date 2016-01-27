import java.util.Scanner;

/**
 * Created by Mihail on 12.05.15.
 */
public class main {

    public static void main(String[] arg) {

        Scanner sc = new Scanner(System.in);
        int n=sc.nextInt();
        int m=sc.nextInt();
        int x1=sc.nextInt();
        int y1=sc.nextInt();
        int x2=sc.nextInt();
        int y2=sc.nextInt();

        if(Math.abs(x1-x2)==Math.abs(y1-y2))
            System.out.println("NO");
        else
            System.out.println("YES");
    }
}

