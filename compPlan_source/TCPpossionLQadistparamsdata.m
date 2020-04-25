function TCPpossionLQadistparams=TCPpossionLQadistparamsdata(basedirectory,structurename)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.



%written by LCH to read in a standard format tcpPossion params data file named
%Lymanparams.txt stored in basedirectory
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure u sd n a_b p dist ref
%u is mean of the normal or lognormal distribution of alpha
%sd is the standard deviation of the normal or lognormal distribution of
%alpha
%d is the dose in Gy
%vdiff if the differential volume in cc
%n is the number of fractions
%a_b is the alpha/beta value
%p is the cell density cells/cc
%dist is the distribution, lognorm or norm and ref is the reference
%e.g. PTV 0.3 0.08 20 10 10000000 norm OkunieffWarkintin
% it should contain as many lines as structures that are required
% it will output a structure which contains the structure name,parameters
% and ref for the chosen structure

filename=strcat(basedirectory,'\TCPpossionLQadistparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %f %f %f %f %f %s %s');
    fclose(fid);
    [m,n] = size(C{2});
    structure=C{1};
    u=C{2};
    sd=C{3};
        n=C{4};
    a_b=C{5};
        p=C{6};
    dist=C{7};
    ref=C{8};
    for i=1:m
found=strcmp(structure(i),structurename);
if (found==1);
    TCPpossionLQadistparams.structure=structure(i);
    TCPpossionLQadistparams.u=u(i);
    TCPpossionLQadistparams.sd=sd(i);
    TCPpossionLQadistparams.n=n(i);
        TCPpossionLQadistparams.a_b=a_b(i);
    TCPpossionLQadistparams.p=p(i);
    TCPpossionLQadistparams.dist=dist(i);
    TCPpossionLQadistparams.ref=ref(i);
end
end

    end