import java.util.Scanner;

/**
 * Created by Mihail on 04.05.15.
 */
public class Main {

    public static void main(String[] arg) {

        Scanner sc = new Scanner(System.in);
        int a=sc.nextInt();
        int b=sc.nextInt();
        int r=sc.nextInt();
        if(a > b)
        {
            int c=a;
            a=b;
            b=c;
        }
        if (2*r<=a)
        {
            System.out.print("YES");
        }else
        {
            if((4*r*r)>=(a*a+b*b) )
            {
                System.out.print("YES");
            }else
                System.out.print("NO");
        }
    }
}
