function  s = splherm(xi,tu,a)
% s = splherm(t,tu,a)
% Account of values interpolation hermit cubic spline with a unlimited
% prolongation of extreme fragments
%       t      Ordinates of points of an interpolation
%       tu     Ordinates knots  
%       a      Abscissas of knots 
%       s      Value spline in t

%	I.V.Shelevitsky 26-09-96
%	Revised 05-11-01 
%	Copyright (c) 2000 by The Igor V.Shelevitsky.

[l,r]=size(tu);
if r==1
   tu=tu';
   a = a';
   [l,r]=size(tu);
end
[l,n]=size(xi);
if n==1
   xi=xi';
   [l,n]=size(xi);
end
for l=1:n  
       t=xi(l); 
       if t<tu(1)
          i=1;
       else
          for  i = 1:r-1
               if ( (tu(i)<=t)&(t < tu(i+1) ))
                   break ;
               end
          end
          if t>=tu(r)
             i=r-1;
          end
       end

       if   i>1
            tu1 = tu(i-1) ;
            a1  =  a(i-1) ;
       else
            a1  = 0  ;
       end
       tu2 = tu(i)   ;
       tu3 = tu(i+1) ;
       a2  = a(i)    ;
       a3  = a(i+1)  ;

       if   i<r-1
            tu4 = tu(i+2) ;
            a4  =  a(i+2) ;
       else
            a4  = 0 ;
       end
       hn = tu3-tu2 ;

       if   i>1
          hp = tu2-tu1 ;
       else
          hp = hn      ;
       end

       if   i<r-1
            hb = tu4-tu3 ;
       else
            hb = hn      ;
       end

     if (i>1)
       p1 = hn/hp   ;
       p4 = hn/(hp+hn);
     else
       p1=0;
       p4=0;
     end

     if (i<r-1)
       p2 = hn/(hb+hn);
       p3 = hn/hb   ;
     else
       p2=0;
       p3=0;
     end

     aa = ( t-tu2 )/hn ;
     b  = 1 - aa       ;

     c  =  aa * b * b ;
     d  =  aa * aa * b ;
     x1 = -p1 * p4 * c  ;
     x2 =  p1 * c - p2 * d + b ;
     x3 = -p4 * c + p3 * d + aa ;
     x4 = -p3 * p2 * d ;

     s(l)  = x1*a1 + x2*a2 + x3*a3 + x4*a4 ;
end
