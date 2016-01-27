function [Apass,Astop,wmax,An]=viewsph(Fmax,m,Fs)
% [Apass,Astop,wmax,An]=viewsph(Fmax,m,Fs)
%   Survey of spectra at an interpolation hermite kubic spline
%   Fmax   Upper frequency of a signal (Hz)
%   m      Magnification of frequency (integer)
%   Fs     Sampling rate               (Hz)         
%   Apass  Nonuniformity in a passband  (dB)
%   Astop  Suppression in a band of a delay (dB)
%   wmax   The upper relative frequency of a signal
%   An     Suppression on bands of a signal  (dB)
%
%   See also spl1forr, viewspi
%   Shelev@yahoo.com

%       I.V.Shelevitsky 27-05-02
%       Revised  27/05/02
%       Copyright (c) 2002 by the Shelevitsky
%

if nargin>2
   wmax=Fmax/(m*Fs);
else
   wmax=Fmax;
end
b=spl1forr(m);
[h,x]=freqz(b,1,2048,'whole');
y=ones(size(x))*0.00000001;
h=h/max(abs(h));
I = find(abs(h)<=0);
h(I)=ones(size(I))*0.0000000001; 
h=20*log10(abs(h));
An=[];

for r=0:m
  m0=(r/m-wmax)*2*pi;
  m1=(r/m+wmax)*2*pi;
  if r>0
     wa(3*r-2)=0.000000001;
     wa(3*r-1)=0.1;
     wa(3*r)=0.000000001;
     w(3*r-2)=r/m-0.00001;
     w(3*r-1)=r/m;
     w(3*r)=r/m+0.00001;
  end
  z=[];
  for n=1:2048
    if  (x(n)>m0)
     if (x(n)<m1)
         y(n)=2;
         z=[z,h(n)];
     end
    end
  end
  if r>0
     if r<m
       An=[An,max(z)];
     else
       An=[An,max(z)-min(z)];
     end
  else
     An=[An,max(z)-min(z)];
  end
  
end
Apass=An(1);
Astop=max(An(2:m));
w=w*2*pi;
y=20*log10(y);
wa=20*log10(wa);
plot(x,y,[pi-0.0001,pi],[10,-200],w,wa,x,h,'b');
title(['Spectrum interpolation w=' num2str(wmax) ' m=' int2str(m) ' Av=' num2str(An(1)) ' Au=' num2str(max(An(2:m)))]);
set(gca,'Xlim',[0,2*pi]);
set(gca,'Ylim',[-160,20]);
