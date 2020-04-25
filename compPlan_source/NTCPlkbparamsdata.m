function NTCPlkbparams=NTCPlkbparamsdata(basedirectory,structurename)

% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%written by LCH to read in a standard format Lyman params data file named
%Lymanparams.txt stored in basedirectory
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure m n d50 ref
%e.g. lung 0.87 0.18 25 Emami209
% it should contain as many lines as structures that are potentially required
% it will output a structure which contains the structure name, m, n, d50
% and ref for the chosen structure

filename=sprintf('%s\\%s',basedirectory,'NTCPlkbparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %f %f %s');
    fclose(fid);
    [k,l] = size(C{2});
    structure=C{1};
    m=C{2};
    n=C{3};
    d50=C{4};
    ref=C{5};
    t=0;
    for i=1:k
found=strcmp(structure(i),structurename);
if (found==1);
    t=1;
    NTCPlkbparams.structure=structure(i);
     NTCPlkbparams.m=m(i);
      NTCPlkbparams.n=n(i);
    NTCPlkbparams.d50=d50(i);
     NTCPlkbparams.ref=ref(i);
end
    end
if t==0
    disp('match for'), structurename  
    disp(' not found in Lyman params file')
end
 
    end