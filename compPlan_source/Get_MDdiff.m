function MD=Get_MDdiff(d,vdiff)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

% function to calculate mean dose based on the dvh of the structure
% concerned
    %disp ('MLD');
    TotV=sum(vdiff);
    DxV=d.*vdiff;
    MD=(sum(DxV))/TotV;
end