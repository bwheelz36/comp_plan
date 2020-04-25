function tcp = TCPpossiond50(d,nvdiff,d50,g50)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%written Lois Holloway 2009
%function to generate tcp values based on the Poisson model- see Kallman

value1=exp(exp(1)*g50*(1-d./d50));
value1a=nvdiff.*value1;
   value2=nvdiff'*value1;
    tcp=0.5^(nvdiff'*value1);
end