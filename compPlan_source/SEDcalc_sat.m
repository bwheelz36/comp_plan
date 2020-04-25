function SED=SEDcalc_sat(n,std,d,a_b,Dp,satper)


% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No 
% warranty is expressed or implied for any use whatever: use at your 
% own risk.
% This function calculated the Biological Effective Dose (BED) for given
% number of fractions (n), chosen standard dose per fraction (std),
% dose per fraction (d) and a/b (a_b) values
% prescribed dose (Dp)
% a saturation value- percentage related to prescribed dose
%(at which point dose is considered ineffective, i.e. all cells have been killed) (satper)

%calc original SED
if satper=='NA'; %calculate normal SED
SED=d.*((1+(d./double(n))/double(a_b))./(1+double(std)/double(a_b)));
else
   
SED=d.*((1+(d./double(n))/double(a_b))./(1+double(std)/double(a_b)));

%calc saturation dose and replace any value above this value with this
%value
Dpsat=Dp*satper/100;
dpsat=double(Dpsat)/double(n);
SEDsat=Dpsat*((1+(double(dpsat))/double(a_b))/(1+double(std)/double(a_b)));

[a,b] = size(SED);

for i=1:a
    
    if SED(i)>SEDsat
        SED(i)=SEDsat;
    end
end


end
