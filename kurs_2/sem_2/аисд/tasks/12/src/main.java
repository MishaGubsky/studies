import java.math.BigDecimal;
import java.util.Scanner;

/**
 * Created by Mihail on 04.05.15.
 */
public class main {

    public static void main(String[] arg) {

        Scanner sc = new Scanner(System.in);
        double x=sc.nextDouble();
        double y=sc.nextDouble();
        double z=sc.nextDouble();

        x=Math.pow(x,y)/z;
        BigDecimal p = new BigDecimal(x);
        p = p.setScale(11, BigDecimal.ROUND_HALF_UP);
        System.out.println(p);
    }
}
