
function Vx= VxGycum2(d,cumv,x)
%written by Julie-Anne Miller 2007
%edited by Lois Holloway 2009
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

% function to determine the percentage volume (Vx) radiated by at least xGy for a
% given dose volume histogram
%d is the dose of a dose volume histogram in Gy ( or the same units as x
%and the dose volume histogram data)
%v is the cumulative volume of a dose volume histogram
%x is the chosen dose level in Gy ( or the same units as x
%and the dose volume histogram data)
 
    for i=1:length(d)
        
        if (d(i)>x)
            Vx1=cumv(i);
            Vx2=cumv(i-1);
            Vx=Vx1-(Vx2-Vx1)*((x-d(i))/(d(i)-d(i-1)));
           break
        else
            Vx=0;
    end
end
 %   Vx=cumv(i);
