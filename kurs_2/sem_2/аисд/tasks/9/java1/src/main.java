import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Scanner;
public class main {
    static void quickSort(int l,int r, long[] a)
    {
        long x = a[l + (r - l) / 2];
        int i = l;
        int j = r;
        while(i <= j)
        {
            while(a[i] < x) i++;
            while(a[j] > x) j--;
            if(i <= j)
            {
                long c=a[i];
                a[i]=a[j];
                a[j]=c;

                i++;
                j--;
            }
        }
        if (i<r)
            quickSort(i, r, a);

        if (l<j)
            quickSort(l, j, a);
    }

    public static void main(String[] arg) {
        Scanner sc = new Scanner(System.in);
        int n=sc.nextInt();
        long[] a = new long[n];
        for (int i=0; i<n;i++) {
            a[i]=sc.nextLong();
        }
        quickSort(0,n-1,a);
        long left=a[0]*a[1];
        long right=a[n-2]*a[n-1];
        if(left > right)
            System.out.println(left);
        else
            System.out.println(right);
    }
}

