function BED=BEDcalc(n,d,a_b)
% This function calculated the Biological Effective Dose ( BED) for given
% number of fractions (n), dose per fraction (d) and a/b (a_b) values

BED=n.*d.*(1+d./a_b);
end
