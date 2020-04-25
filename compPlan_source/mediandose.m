function mediandosevalue = mediandose(d,nvcum)
% this function establishes the minimum dose of a dvh matrix containing
% dose and volume information
[nb,N]=size(nvcum);

for i=2:nb
    if(((nvcum(i)<0.5)&&(nvcum(i-1)>0.5000))||(nvcum(i)==0.5))
        mediandosevalue=d(i);
     end
end
end
    