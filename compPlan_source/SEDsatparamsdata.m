function sedparams=SEDsatparamsdata(basedirectory,structurename)
%written by Lois Charlotte Holloway 2009, to read in a standard format 
%SED params data file named
%SEDsatparams.txt stored in basedirectory. 
% The input is the base directory and the structure name which the
% parameters are required for
% This file must contain data in the following format
% structure n std a_b D satper ref
%e.g. lung 35 2 10.2 50 110 Emami209
% it should contain as many lines as structures that are required
% it will output a structure which contains the structure name and the values
% listed below

%n number of fractions in the given schedule
%std standard dose per fraction, commonly 2
% a_b= tumor alpha/beta ratio 
% D prescribed dose for the standard schedule
%satper is the percentage dose at which any dose above this value
%should be adjusted to this saturated value  ( i.e. if 110% and a prescribed dose
% of 50 Gy, this would occur above 55Gy so if the calculated dose was 58Gy, it would 
% be set to 55Gy) If you do not wish to use a saturation value, set this
% value to a really large value e.g. 1000%.
% and ref for the chosen structure

   
filename=strcat(basedirectory,'\SEDsatparams.txt');
fid = fopen(filename) ;
    C=textscan (fid,'%s %d %f %f %f %s %s');
    fclose(fid);
    [m,n] = size(C{2});
    structure=C{1};
    n=C{2};
    std=C{3};
    a_b=C{4};
    D=C{5};
    satper=C{6};
    ref=C{7};
    if satper='NA' %just calculate normal SED
            for i=1:m
                found=strcmp(structure(i),structurename);
                    if (found==1);
                        sedparams.n=n(i);
                        sedparams.std=std(i);
                        sedparams.a_b=a_b(i);
                        sedparams.ref=ref(i);
                    end
            end
    else %assume use the entered saturation dose
        satper=str2double(satper);
        for i=1:m
        found=strcmp(structure(i),structurename);
            if (found==1);
                sedparams.n=n(i);
                sedparams.std=std(i);
                sedparams.a_b=a_b(i);
                sedparams.D=D(i);
                sedparams.satper=satper(i);
                sedparams.ref=ref(i);
            end
        end
end

    end