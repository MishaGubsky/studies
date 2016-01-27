import java.util.Scanner;
public class main {

    static void quickSort(int l,int r, int[] a)
    {
        int x = a[l + (r - l) / 2];
        //запись эквивалентна (l+r)/2,
        //но не вызввает переполнения на больших данных
        int i = l;
        int j = r;
        while(i <= j)
        {
            while(a[i] < x) i++;
            while(a[j] > x) j--;
            if(i <= j)
            {
                int c=a[i];
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
        int[] a = new int[n];
        for (int i=0; i<n;i++) {
            a[i]=sc.nextInt();
        }
        quickSort(0,n-1,a);

        System.out.println(a[n-1]*a[n-2]);
    }
}
