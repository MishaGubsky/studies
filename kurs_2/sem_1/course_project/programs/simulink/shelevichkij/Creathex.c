#include <stdio.h>
#include <stdlib.h>

int main(int argv, char *argc[])
{
FILE *in, *out;
char buf[16]="               ";
char str[33];
int val=0, adr=0;

if (argv<3) {
   puts("\n Converted int decimal data to intel hex format \n");
   puts("synt: creathex <filein> <fileout> <start addres> \n");
   return 0;
	    }
 if ((in=fopen(argc[1], "rt"))==NULL) return -1;
 if ((out=fopen(argc[2],"wt"))==NULL) return -2;
 adr=atoi(argc[3]);

 while (fgets(str,32,in)!=NULL) {
    val=atoi(str);
    sprintf(buf,":02%04x00%04x00\n",adr,val);
    fputs(buf,out);
    adr+=2;
		  }
    fputs(":00000001ff",out);

 fcloseall();

return 0;
}