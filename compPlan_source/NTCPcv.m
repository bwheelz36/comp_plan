function ntcp=NTCPcv(d,nvdiff,n,a,a_b,k,N,M)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.

  
%d is the dose matrix
%nvdiff is the normalised differential volume matrix

BEDi=BEDcalc(n,d./n,a_b);
S=exp(-a.*BEDi);
    Pfsu=(1-S).^k;
    Peff=nvdiff'*Pfsu;
  sigma=sqrt(N*Peff*(1-Peff));
    t=(M-N*Peff)/(sigma);
    ntcp=NTCPint(t);
end

function y=NTCPint(t)


y=quad(@expvalue,-1000,t);

	function y = expvalue(x) % Compute the exponential value required
	y = (1/(sqrt(2*pi)))*exp(-((x.^2)/2));
	end
end

