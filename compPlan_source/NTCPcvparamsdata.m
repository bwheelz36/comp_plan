function NTCPcvparams=NTCPcvparamsdata(basedirectory,structurename)
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

filename=sprintf('%s\\%s',basedirectory,'NTCPcvparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %f %f %f %f %f %s');
    fclose(fid);
    [j,l] = size(C{2});
    structure=C{1};
        n=C{2};
    a=C{3};
    a_b=C{4};
   k=C{5};
    N=C{6};
   M=C{7};
    ref=C{8};
    t=0;
    for i=1:j
found=strcmp(structure(i),structurename);
if (found==1);
    t=1;
    NTCPcvparams.structure=structure(i);
         NTCPcvparams.n=n(i);
     NTCPcvparams.a=a(i);
      NTCPcvparams.a_b=a_b(i);
   NTCPcvparams.k=k(i);
         NTCPcvparams.N=N(i);
   NTCPcvparams.M=M(i);
     NTCPcvparams.ref=ref(i);
end
    end
if t==0
    disp('match for')  ;
    disp(' not found in NTCPcv params file');
end
 
    end