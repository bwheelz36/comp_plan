function mindose=mindosecumdvh(dvh)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


% this function establishes the minimum dose of a dvh matrix containing
% dose and volume information
[nb,N]=size(dvh);
mindose=0;
try
for i=1:nb
     if(((dvh(i,2)-dvh(i+1,2))>0.00001))
        mindose=dvh(i,1);
        break
     end
end
catch
    print('helo')
end
end
    