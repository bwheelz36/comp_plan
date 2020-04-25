function EUDparams=EUDparamsdata(basedirectory,structurename)

% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.




%written by Lois Charlotte Holloway 2009, to read in a standard format 
%EUD params data file named
%EUDparams.txt stored in basedirectory. This is for use in the function
%eudmodelarguments
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure nf dose_type answer2 tissue_type a gamma50 td50 standard_fractionation ab ref
%e.g. lung 35 2 1 1 3.1 0.87 20.3 2.1 10.2 Emami209
% it should contain as many lines as structures that are required
% it will output a structure which contains the structure name the values
% listed below
% and ref for the chosen structure

filename=sprintf('%s\\%s',basedirectory,'eudparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %s');
    fclose(fid);
    [k,l] = size(C{2});
    structure=C{1};
    a=C{2};
    ref=C{3};
    t=0;
    for i=1:k
        
found=strcmp(structure(i),structurename);
if (found==1);
    t=1;
    EUDparams.structure=structure(i);
     EUDparams.a=a(i);
     EUDparams.ref=ref(i);
end
    end
if t==0
    disp('match for'), structurename  
    disp(' not found in eud params file')
end
 
    end