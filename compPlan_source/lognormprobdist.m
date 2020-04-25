function lognormprobdist = lognormprobdist (x,u,sd)

%function to determine the normal probability distribution for value x where there is a mean of u,
%standard deviation of sd

m=log((u^2/sqrt(u^2+sd^2)));
s=sqrt(log((sd/u)^2+1));
x;
test1=(1./x);
test=1/(x.*s*sqrt(2*pi()));
lognormprobdist=(1./(x.*s.*sqrt(2.*pi()))).*exp(-((log(x)-m).^2)./(2.*(s).^2));
end