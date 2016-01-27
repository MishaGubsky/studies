import java.math.BigDecimal;
import java.util.Scanner;

/**
 * Created by Mihail on 12.05.15.
 */
public class main {

    public static void main(String[] arg) {

        Scanner sc = new Scanner(System.in);
        int x=2*sc.nextInt();
        BigDecimal p = new BigDecimal(x);
        p = p.setScale(4, BigDecimal.ROUND_HALF_UP);
        System.out.println("0.0000 0.0000");
        System.out.println("1.0000 0.0000");
        System.out.println("1.0000 "+p);
    }
}
