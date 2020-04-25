function TCPlogitEUDparams=TCPlogitEUDparamsdata(basedirectory,structurename)

% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


%written by LCH to read in a standard format tcpPossion params data file named
%Lymanparams.txt stored in basedirectory
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure d50 g50 ref
%e.g. lung 0.87 0.18 Emami209
% it should contain as many lines as structures that are required
% it will output a structure which contains the structure name, d50, g50
% and ref for the chosen structure

filename=strcat(basedirectory,'\TCPlogitEUDparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %f %s');
    fclose(fid);
    [m,n] = size(C{2});
    structure=C{1};
    d50=C{2};
    g50=C{3};
    ref=C{4};
    for i=1:m
found=strcmp(structure(i),structurename);
if (found==1)
    TCPlogitEUDparams.structure=structure(i);
    TCPlogitEUDparams.d50=d50(i);
    TCPlogitEUDparams.g50=g50(i);
     TCPlogitEUDparams.ref=ref(i);
end
end

    end