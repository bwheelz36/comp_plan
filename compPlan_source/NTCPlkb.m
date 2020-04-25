function ntcp=NTCPlkb(d,nvdiff, n,m,d50)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

    % note d,v have to be column vectors
%d is the dose matrix
%v is the normalised differential volume matrix
    %Effective Volume
    value1=(d/max(d)).^(1/n);
    Veff=nvdiff'*((d/max(d)).^(1/n));
    d50veff=d50/(Veff^n);
    t=(max(d)-d50veff)*d50veff/m ;
    ntcp=NTCPint(t);
end

function y=NTCPint(t)


y=quad(@expvalue,-1000,t);

	function y = expvalue(x) % Compute the exponential value required
	y = (1/(sqrt(2*pi)))*exp(-((x.^2)/2));
	end
end

