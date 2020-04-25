function tcp = TCPprobit(d,nvdiff,d50,g50)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%written Lois Holloway 2009
    %function to generate tcp values based on the Logit model- see Goitein
%1985, Kallman

    value1=sqrt(pi).*g50.*(1-(d./d50));
    value1a=erf(value1);
    value2=(1-erf(value1)).^nvdiff;
    tcp=(1/2)*prod(value2);
end