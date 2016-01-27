function [hp,err]=preIntS(c0,c1)
% [hp,err]=preIntS(c0,c1)
% Account prefilter for an interpolation B-spline
% c0  Value in a central knot
% c1  Value in side knots   
%
%   Shelev@yahoo.com

%       I.V.Shelevitsky 27-05-02
%       Revised  27/05/02
%       Copyright (c) 2002 by the Shelevitsky
%

q=c0*c0*c0*c0-4*c0*c0*c1*c1+2*c1*c1*c1*c1;
d0=c0*(c0*c0-2*c1*c1)/q;
d1=-c1*(c0*c0-c1*c1)/q;
d2=c0*c1*c1/q;
d3=-c1*c1*c1/q;
hp=[d3,d2,d1,d0,d1,d2,d3];
err=2*c1*d3;