function ntcp=NTCPrs(d,nvdiff, d50,g50,s)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%written LH
% relative seriality model Kallman
%d is the dose column
%v is the normalised differential volume
%s is the seriality parameter as per Kallman
   
Pdi=(1/2).^exp((exp(1).*g50.*(1-d./d50)));

value1=(1-Pdi.^s).^nvdiff;
ntcp=(1-prod(value1))^(1/s);
    

    end