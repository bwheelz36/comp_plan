function tcp = TCPpossionLQ(d,vdiff,n,a,a_b,p)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%function to generate tcp values based on the Poisson model, using the
%Linear Quadratic model see Kallman and Keall and Webb amoung many others
%d is the dose matrix in Gy, vdiff is the differential volume matrix in cc, n is number of fractions, a the alpha value, a_b the alpha/beta value, p
% the cell density in cells/cc

BEDi=BEDcalc(n,d./n,a_b);
value1=exp(-a.*BEDi);
value2=p.*vdiff.*value1;
TCPi1=exp(-value2);
TCPi=exp(-p.*vdiff.*exp(-a.*BEDi));
TCPtotal=prod(TCPi);
 tcp=TCPtotal;
end