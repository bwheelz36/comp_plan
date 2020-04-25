function TCP = TCPpossionLQadist3(u,sd,d,vdiff,n,a_b,p,dist)
% written Lois Holloway 
%Permission is granted to use or modify only for non-commercial use. No warranty is expressed or implied for any
% use whatever: use at your own risk.


% function to calculate TCP for a Possion distribtuion, using the LQ model
% with an alpha distribution which can be either log or lognormally
% distributed
% u is mean of the normal or lognormal distribution of alpha
%sd is the standard deviation of the normal or lognormal distribution of
%alpha
%d is the dose in Gy
%vdiff if the differential volume in cc
%n is the number of fractions
%a_b is the alpha/beta value
%p is the cell density cells/cc
%dist is the distribution chosen


%0.1 - 0.5 with nh=5 for comparison with excel
upper= u+4*sd ;
lower=max(0.0001,(u-4*sd )) ;
nh=9 ;
% upper= 0.5
% lower=0.1
% nh=5


h=(upper-lower)/(nh-1);
simpsons=0;
for i=1:nh
    if (strcmp(dist,'norm')==1)
    fi(i)=anormTCPvalue((i-1)*h+lower);
    elseif(strcmp(dist,'lognorm')==1)
            fi(i)=alognormTCPvalue((i-1)*h+lower);
    else
        error('distribution for log or lognormal not assigned correctly')
    end
    if( i==0 || i==nh)
        simpsons(i)=fi(i);
    elseif rem(i,2)==0
        simpsons(i)=4*fi(i);
    else
        simpsons(i)=2*fi(i);
    end
end
simpsonssum=sum(simpsons);
simpsons=(h/3)*sum(simpsons);
TCP=simpsons;

    function anormTCP= anormTCPvalue(a)
       value1=TCPpossionLQ(d,vdiff,n,a,a_b,p);
       value2=normprobdist (a,u,sd);
        anormTCP=value1*value2;
       
    end
    
   function alognormTCP= alognormTCPvalue(a)
       
        alognormTCP=TCPpossionLQ(d,vdiff,n,a,a_b,p)*lognormprobdist (a,u,sd);
       
	end

end