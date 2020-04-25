function structure_metrics=read_structure_metrics2(basedirectory,maxnum_metrics,number_structures)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

%written by LCH to read in a standard format structure and metrics to be
%calculated for that structure
% This can be utilised to calculate values and to output values to a
% standard format
% The input is the base directory 
% This file must contain data in the following format
% structure requiredmetrics
%e.g. lung NTCP V20 V10
% it should contain as many lines as structures that are required to have
% metrics calculated for

filename=sprintf('%s\\%s',basedirectory,'structure_metrics.txt');
fid = fopen(filename) ;
for i=1:number_structures
    C{i}=textscan (fid,'%s',(maxnum_metrics+1));
end
    fclose(fid);
    [m,n] = size(C{1});
    structure_metrics = C;
    

    end