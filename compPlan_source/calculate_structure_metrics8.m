function combmetric = calculate_structure_metrics8 (basedirectory,nummetrics,structure_metrics,DVHs)
% written Lois Holloway March 2009 
% updated June 2009 to allow VX and isoY to be general terms, using any
% number
%updated 2010 to include median dose
%updated July 2011 to calculate from DVH data input from generate_DVHs,
%rather than DVHs read and calculated in this function

%input values
%nummetrics- the number of metrics to be calculated
%structure_metrics- a string array containing the structure name for which these metrics are being calculated
%and the metrics to be calculated e.g. 'TCP', 'NTCP', etc.
 % WARNING: Metrics to be calculated must correlate with the functions assigned in this code or the desired
%metrics will not be calculated or worse not calculated correctly
    
    % DVH data used (as generated in 'generate_DVHs.m' or otherwise
    %vcum is the cumulative volume
    %vdiff is the differential volume
    %nvdiff is the differential volume normalised over total volume
    
    d=DVHs.d;
    vdiff=DVHs.vdiff;
    nvdiff=DVHs.nvdiff;
    vcum=DVHs.vcum;
    nvcum=DVHs.nvcum;
    dvh=[d vcum];
    structure=DVHs.structure;
    %for use when previous metric was calculated with SED rather than d
  dbackup=d;
  
%calculate metrics based on the metric strings given as inputs. These
%strings are reasonably self-explanatory
for k=1:nummetrics  
   
    
        %check if SED is to be used rather than d
             if(strncmp(structure_metrics{k+1},'SED',3)==1)
                 structure_metrics{k+1};
                 
             calcmetric=textscan(structure_metrics{k+1},'SED_%s');
             calcmetric=calcmetric{1,1} ;
             if isempty(calcmetric)
            error('attempt to call SED with non valid syntax.   Structure: %s',structure)          
             end
              d=DVHs.SED;
              useSED=1;
             else
                 useSED=0;
                 d=dbackup;
                 calcmetric=structure_metrics{k+1};
             end
             
           calcmetric  ;
          
             
        if(strcmp(calcmetric,'vol')==1)
      metric(k)=vcum(1);
       metricparams{k}='no params' ;
      
    elseif(strncmp(calcmetric,'VX',2)==1)
        
        VXvalue=textscan(calcmetric,'VX%f');
      VX= VxGycum2(d,nvcum,VXvalue{1,1});
        metric(k)=VX*100;
        metricparams{k}=['VXvalue=' num2str(VXvalue{1,1})];

       elseif(strncmp(calcmetric,'iso',3)==1)
             isovalue=textscan(calcmetric,'iso%f');
            isoxparams=isoxparamsdata(basedirectory,structure);
        iso= isoxpercum(d,nvcum,isovalue{1,1},isoxparams.pres);
        metric(k)=iso*100;
         metricparams{k}=['isovalue=' num2str(isovalue{1,1})] ;
        
        elseif(strcmp(calcmetric,'mean')==1)
        MD=Get_MDdiff(d,vdiff);
        metric(k)=MD;
        metricparams{k}='no params' ;
        
             elseif(strcmp(calcmetric,'min')==1)
      mindose=mindosecumdvh(dvh);
         metric(k)= mindose;
         metricparams{k}='no params' ;
         
            elseif(strcmp(calcmetric,'max')==1)
       maxdose=max(d);
        metric(k)= maxdose;
        metricparams{k}='no params' ;
        
                    elseif(strcmp(calcmetric,'median')==1)
       meddose=mediandose(d,nvcum);
        metric(k)= meddose;
        metricparams{k}='no params' ;
        
                elseif(strcmp(calcmetric,'EUD')==1)
               eudparams=EUDparamsdata(basedirectory,structure) ;
            eud = generalisedEUD2(d,nvdiff,eudparams.a);
                 metric(k)= eud;
                 metricparams{k}=['a=' num2str(eudparams.a)] ;
        
                elseif(strcmp(calcmetric,'NTCPlkb')==1)
                  
                 NTCPlkbparams=NTCPlkbparamsdata(basedirectory,structure);
       metric(k)=NTCPlkb(d,nvdiff, NTCPlkbparams.n,NTCPlkbparams.m,NTCPlkbparams.d50);
       metricparams{k}=['n=' num2str(NTCPlkbparams.n) '  m=' num2str(NTCPlkbparams.m) '  d50=' num2str(NTCPlkbparams.d50)] ;
       
                        elseif(strcmp(calcmetric,'ntcpLEUD')==1) 
                 NTCPlkbparams=NTCPlkbparamsdata(basedirectory,structure);
                 eudparams=EUDparamsdata(basedirectory,structure) ;
            eud = generalisedEUD2(d,nvdiff,eudparams.a);
             vol=vcum(1);
      metric(k)= TCPprobitd50singlevalue(eud,vol,NTCPlkbparams.d50,NTCPlkbparams.m);
      metricparams{k}=['a=' num2str(eudparams.a) '  m=' num2str(NTCPlkbparams.m) '  d50=' num2str(NTCPlkbparams.d50)] ;
        
                       elseif(strcmp(structure_metrics{k+1},'NTCPrs')==1)
                 NTCPrsparams=NTCPrsparamsdata(basedirectory,structure);
       metric(k)=NTCPrs(d,nvdiff, NTCPrsparams.d50,NTCPrsparams.g50,NTCPrsparams.s);
       metricparams{k}=['d50=' num2str(NTCPrsparams.d50) '  g50=' num2str(NTCPrsparams.g50) '  s=' num2str(NTCPrsparams.s)] ;
      
                     elseif(strcmp(structure_metrics{k+1},'NTCPcv')==1)
                 NTCPcvparams=NTCPcvparamsdata(basedirectory,structure);
       metric(k)=NTCPcv(d,nvdiff, NTCPcvparams.n,NTCPcvparams.a,NTCPcvparams.a_b,NTCPcvparams.k,NTCPcvparams.N,NTCPcvparams.M);
     metricparams{k}=['n=' num2str(NTCPcvparams.n) '  a=' num2str(NTCPcvparams.a) '  a/b=' num2str(NTCPcvparams.a_b) '  k=' num2str(NTCPcvparams.k) '  N=' num2str(NTCPcvparams.N) '  M=' num2str(NTCPcvparams.M)] ;
       
     elseif(strcmp(calcmetric,'TCPpossiond50')==1)
                  TCPpossiond50params=TCPpossiond50paramsdata(basedirectory,structure);
                metric(k) = TCPpossiond50(d,nvdiff,TCPpossiond50params.d50,TCPpossiond50params.g50);
     metricparams{k}=['d50=' num2str(TCPpossiond50params.d50) '  g50=' num2str(TCPpossiond50params.g50) ]; 
                 
 
         elseif(strcmp(calcmetric,'TCPprobit')==1)
                  tcpprobitparams=TCPprobitparamsdata(basedirectory,structure);
                  metric(k) = TCPprobit(d,nvdiff,tcpprobitparams.d50,tcpprobitparams.g50);
               metricparams{k}=['d50=' num2str(tcpprobitparams.d50) '  g50=' num2str(tcpprobitparams.g50) ] ;
     
                
      elseif(strcmp(calcmetric,'TCPpossionLQ')==1)
                 tcpPossionLQparams=TCPpossionLQparamsdata(basedirectory,structure);
                tcpab = TCPpossionLQ(d,vdiff,tcpPossionLQparams.n,tcpPossionLQparams.a,tcpPossionLQparams.a_b,tcpPossionLQparams.p);
                metric(k)= tcpab;
                metricparams{k}=['n=' num2str(tcpPossionLQparams.n) '  a=' num2str(tcpPossionLQparams.a) '  a/b=' num2str(tcpPossionLQparams.a_b) '  p=' num2str(tcpPossionLQparams.p) ] ;
     
                      elseif(strcmp(calcmetric,'TCPpossionLQadist')==1)
                 TCPpossionLQadistparams=TCPpossionLQadistparamsdata(basedirectory,structure);
                tcpadist = TCPpossionLQadist3(TCPpossionLQadistparams.u,TCPpossionLQadistparams.sd, d,vdiff,TCPpossionLQadistparams.n,TCPpossionLQadistparams.a_b,TCPpossionLQadistparams.p,TCPpossionLQadistparams.dist{1,1});
                metric(k)= tcpadist;
                metricparams{k}=['u=' num2str(TCPpossionLQadistparams.u) '  sd=' num2str(TCPpossionLQadistparams.sd) '  n=' num2str(TCPpossionLQadistparams.n) 'a_b=' num2str(TCPpossionLQadistparams.a_b)  '  p=' num2str(TCPPossionLQadistparams.p) ]; 
     
                % The default logit model, here, uses the parameters d50 and g50
                     elseif(strcmp(calcmetric,'TCPlogit')==1)
                  tcplogitparams=TCPlogitparamsdata(basedirectory,structure);
                 tcplogit = TCPlogit(d,nvdiff,tcplogitparams.d50,tcplogitparams.g50);
                 metric(k)= tcplogit   ;             
                 metricparams{k}=['d50=' num2str(tcplogitparams.d50) '  g50=' num2str(tcplogitparams.g50) ] ;
     
                 % An additional logit model is here, which used EUD that
                 % is calculated prior to calculating the logit model
                                       elseif(strcmp(calcmetric,'logitEUD')==1)
                  logitEUDparams=logitEUDparamsdata(basedirectory,structure);
            eudparams=EUDparamsdata(basedirectory,structure_metrics{1}); 
            eud = generalisedEUD2(d,nvdiff,eudparams.a);
                 logitEUD = TCPlogitsingledose(eud,logitEUDparams.d50,logitEUDparams.g50);
                 metric(k)= logitEUD  ;
        metricparams{k}=['a=' num2str(eudparams.a) 'd50=' num2str(logitEUDparams.d50) '  g50=' num2str(logitEUDparams.g50) ] ;
        
      %if this metric is not required 
        elseif (strcmp(calcmetric,'null')==1)
     metric(k)=NaN;
metricparams{k}=NaN ;
        
        else            
            error ('metric %i (%s) for %s is not valid',k,calcmetric,structure)
        end

 

%combine metric and metricparams into single structure array so both can be
%printed out
combmetric.metric= metric;
combmetric.metricparams=metricparams;

end