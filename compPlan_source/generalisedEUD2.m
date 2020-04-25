function eud = generalisedEUD2(d,v,a)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

   %function to generate EUD values based on Niemierko's generalised EUD Gay
%and Niemierko Physica Medica 2007 23, 115-125
%d is a dose array, containing the dose data corresponding to the normalised differential volume
%array (v). Both these can be generated from DVH data.
% a determines the behaviour of the EUD model

value1=d.^a ;  
inv=v';
value2=v'*value1;
eud=value2^(1/a);



   
end