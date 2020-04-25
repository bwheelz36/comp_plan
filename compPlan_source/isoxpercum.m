
% JAM for Lung used by Oncologist
function isox= isoxpercum(d,vcum,x,pres)

% written by Julie-Anne Miller, edited by Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

% function to determine the volume (isox) radiated by at least x% of presGy for a
% given dose volume histogram
%d is the dose of a dose volume histogram in Gy ( or the same units as pres)
%vcum is the cumulative volume of a dose volume histogram
%x is the chosen percentage level
%pres is the prescribed dose in Gy ( or the same units as the dose volume histogram data)
 
    for Fx=1:length(d)
        
        if (d(Fx)<=((x/100)*pres))
            i=1;
            isox=vcum(Fx);
        end
        if ((d(Fx)>=((x/100)*pres))&&(i==1))
break
        end
    end
    isox=vcum(Fx);
end