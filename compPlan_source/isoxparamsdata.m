function isoxparams=isoxparamsdata(basedirectory,structurename)

% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

%written by LCH to read in a standard format isox params data file named
%isoxparams.txt stored in basedirectory ( i.e. to find volume encompassing
%95% isodose for a given prescription dose
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure pres
%e.g. PTV 60
% it should contain as many lines as structures that are potentially required
% it will output a structure which contains the structure name, pres for the chosen structure

filename=sprintf('%s\\%s',basedirectory,'isoxparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f');
    fclose(fid);
    [m,n] = size(C{2});
    structure=C{1};
    pres=C{2};
    for i=1:m
found=strcmp(structure(i),structurename);
if (found==1);
    isoxparams.structure=structure(i);
     isoxparams.pres=pres(i);
      
end

    end

 
    end