function TCPpossionLQparams=TCPpossionLQparamsdata(basedirectory,structurename)

% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

%written by LCH to read in a standard format tcpPossion params data file named
%Lymanparams.txt stored in basedirectory
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure n a a_b p ref
% n is number of fractions, a the alpha value, a_b the alpha/beta value, p
% the cell density
%e.g. lung 30 0.3 10 10000000 Emami209
% it should contain as many lines as structures that are required
% it will output a structure which contains the structure name parameters 
%and ref for the chosen structure

filename=strcat(basedirectory,'\TCPpossionLQparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %f %f %f %s');
    fclose(fid);
    [m,n] = size(C{2});
    structure=C{1};
    n=C{2};
    a=C{3};
    a_b=C{4};
    p=C{5};
    ref=C{6};
    for i=1:m
found=strcmp(structure(i),structurename);
if (found==1);
    TCPpossionLQparams.structure=structure(i);
    TCPpossionLQparams.n=n(i);
    TCPpossionLQparams.a=a(i);
        TCPpossionLQparams.p=p(i);
    TCPpossionLQparams.a_b=a_b(i);
     TCPpossionLQparams.ref=ref(i);
end
end

    end