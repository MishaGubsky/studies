import java.util.Scanner;
class  main{

    public static void main(String[] arg) {

        Scanner sc = new Scanner(System.in);
        int d=2*sc.nextInt();
        double a=sc.nextInt();
        double b=sc.nextInt();

        int n=0;
        while (d*d<(b*b+a*a))
        {
            if (b>a)
                b/=2;
            else
                a/=2;
            n+=1;
        }
        System.out.print(n);
    }
}
