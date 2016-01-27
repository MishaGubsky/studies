#include <stdio.h>
#include <stdlib.h>

int *form_spline(int *x, int n, int mas)
/*
  x[4,n] - части кубического эрмитового базисного сплайна 
  n      - число отсчетов на фрагменте сплайна 
  mas    - масштабный коэф. для приведения к целым значениям
*/
{
int i ;
double i1,i2,i3,nd ;
double q=1/(double)(2.*(double)n*(double)n*(double)n);

if (mas<10) mas=10;
q=(double)mas*q;
nd=(double)n;

for ( i=0 ; i<n ; i++ ) {
 i1=(double)i;
 i2=i1*i1;
 i3=i1*i1*i1;
 x[i]=(int)(-q*(i3-2*nd*i2+nd*nd*i1));        /* i */
 x[i+n]=(int)(q*(3*i3-(5*nd)*i2+2*nd*nd*nd));
 x[i+n+n]=(int)(q*(-3*i3+4*nd*i2+nd*nd*i1));
 x[i+n+n+n]=(int)mas-x[i]-x[i+n]-x[i+n+n];    /* i+3n */
			}
 return x;
}


int main(int argv, char *argc[])
{
FILE *out;
char buf[18]="               ";
char fname[40]="spl00001.hex";
int val=0, adr=0, mas=1, nbit=0;
int *x;
int n,i;

if (argv<3) {
   puts("\n Write base spline data to intel hex format \n");
   puts("synt: bsplhex <length in fragment> <number bits (<=16)> <start addres> \n");
   return 0;
	    }

 nbit=atoi(argc[2])-1;
 if (nbit<4) nbit=4;
 for (n=0;n<nbit-1;n++) mas*=2;
 adr=atoi(argc[3]);
 n=atoi(argc[1]);
 if (n<2) n=2;
 if (n>99) { fname[3]=argc[1][0];
	     fname[4]=argc[1][1];
	     fname[5]=argc[1][2]; }
 if (n>9)  { fname[4]=argc[1][0];
	     fname[5]=argc[1][1]; }
     else  { fname[5]=argc[1][0]; }

 x=calloc(n*4,sizeof(int));
 if (x==NULL) return -3;

 form_spline(x, n, mas);

 out=fopen(fname,"wt");
 if (out==NULL) return -4;
 for (i=0; i<n; i++) {
    val=x[i];
    sprintf(buf,":02%04x00%04x00\n",adr,val);
    fputs(buf,out);
    adr+=2;
		     }
 fputs(":00000001ff",out);
 fclose(out);

 fname[7]='2';
 out=fopen(fname,"wt");
 adr=atoi(argc[3]);
 if (out==NULL) return -4;
 for (i=0; i<n; i++) {
    val=x[i+n];
    sprintf(buf,":02%04x00%04x00\n",adr,val);
    fputs(buf,out);
    adr+=2;
		     }
 fputs(":00000001ff",out);
 fclose(out);

 fname[7]='3';
 out=fopen(fname,"wt");
 adr=atoi(argc[3]);
 if (out==NULL) return -4;
 for (i=0; i<n; i++) {
    val=x[i+n+n];
    sprintf(buf,":02%04x00%04x00\n",adr,val);
    fputs(buf,out);
    adr+=2;
		     }
 fputs(":00000001ff",out);
 fclose(out);

 fname[7]='4';
 out=fopen(fname,"wt");
 adr=atoi(argc[3]);
 if (out==NULL) return -4;
 for (i=0; i<n; i++) {
    val=x[i+n+n+n];
    sprintf(buf,":02%04x00%04x00\n",adr,val);
    fputs(buf,out);
    adr+=2;
		     }
 fputs(":00000001ff",out);
 fclose(out);

return 0;
}