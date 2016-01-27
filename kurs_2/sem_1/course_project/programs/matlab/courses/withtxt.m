function str=withtxt(txt,w)
% str=withtxt(txt,w)
%  txt  string input text
%  w    with column output text
%  str  output string text
%  Shelev@yahoo.com

%       I.V.Shelevitsky 27-05-02
%       Revised  27/05/02
%       Copyright (c) 2002 by the Shelevitsky
%

strrep(txt,char(13),' ');
n=length(txt);
nl=findstr(txt,char(10));
nl=[1,nl,n];
m=length(nl);
for i=2:m,
  k=nl(i-1);
  nw=0;
  while k<=nl(i),
     if txt(k)==' ',
        sp=k;
     end
     if nw>=w
        txt(sp)=char(10);
        k=sp;
        nw=0; 
     end
     nw=nw+1;
     k=k+1;
  end
end
str=txt;
