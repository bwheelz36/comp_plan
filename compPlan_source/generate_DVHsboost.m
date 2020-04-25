function DVH = generate_DVHs2 (nummetrics,basedirectory,plan,structure_metrics)
% original written Lois Holloway March 2009
%split with calculate_structure_metrics function July 2011

%input values
%nummetrics- the number of metrics to be calculated
%basedirectory- the base directory in which the excel files are stored,
%plan-an array containing all the plans names (or directory folders which
%will be searched) 
%structure_metrics- a string array containing the structure name for which these metrics are being calculated
%and the metrics to be calculated e.g. 'TCP', 'NTCP', etc.
 % WARNING: Metrics to be calculated must correlate with the functions assigned in this code or the desired
%metrics will not be calculated or worse not calculated correctly


% dvh should be in absolute dose, in Gy, with the volume absolute
% cumulative, in cc
% variations of the dvh calculated
% read excel dvh file based on directory structure and name of structure
% being considered
% filename=sprintf('%s\\%s',basedirectory,structure)


DVH.plan=plan{1,1}{1,1};
DVH.structure=structure_metrics{1,1};
DVH.structurecomplete=DVH.structure;
%check if structure requires a boost

if(strncmp(DVH.structurecomplete,'boost',5)==1)
    DVH.boost='yes';
     boostdetails=textscan(DVH.structurecomplete,'boostD%fn%f_%s');
     DVH.boostD=boostdetails{1,1};
     DVH.boostn=boostdetails{1,2};
     DVH.structure=boostdetails{1,3}{1,1};
else DVH.boost='no';
end

 filename= strcat(basedirectory,'\',plan{1,1}{1,1},'\',DVH.structure);
    dvh = xlsread(filename);
    
    % variations of the dvh calculated
    %vcum is the cumulative volume
    %vdiff is the differential volume
    %nvdiff is the differential volume normalised over total volume
 
    % firstly adjust the dose to Gy, if in cGy originally
    if(strcmp(plan{1,1}{2,1},'Gy')==1)
        d=getcolumn(dvh,1);
        
    elseif(strcmp(plan{1,1}{2,1},'cGy')==1)
        d=getcolumn(dvh,1)./100;
        

        
    else
      error( 'dose format for %s in plan %s is not valid',DVH.structure,plan{1,1}{3,1}) ;
      
           
    end
    if d(1,1)==0
        d(1,1)=0.0001;
    end
     %check if SED is required for metric calcs and if so calculate this
     %including boost where necessary
for k=1:nummetrics
    useSED=0;
             if(strncmp(structure_metrics{k+1},'SED',3)==1)
            SEDparams=SEDsatparamsdata(basedirectory,DVH.structure);
            SED=SEDcalc_sat(SEDparams.n,SEDparams.std,d,SEDparams.a_b,SEDparams.D,SEDparams.satper);
            SED=SED;
            
             if (strcmp(DVH.boost,'yes')==1) 
                 SEDboost=SEDcalc(DVH.boostn,SEDparams.std,(DVH.boostD/DVH.boostn),SEDparams.a_b);
                 SED=SED+SEDboost;
                 
                  %check if SED is above saturation value now boost is added on 
             
                SEDsat=SEDcalc(SEDparams.n,SEDparams.std,(SEDparams.D*(SEDparams.satper/100)),SEDparams.a_b);
                [a,b] = size(SED);
                for i=1:a
                 if SED(i)>SEDsat
                     SED(i)=SEDsat;
                 end
                end
             end
             
              DVH.SED=SED;
            break
             end
end

    
    %add boost dose if necessary
     if (strcmp(DVH.boost,'yes')==1) 
                 d=d+DVH.boostD;
             end
          
    
    
   
    % secondly calculate appropriate volume matrix'
     if(strcmp(plan{1,1}{3,1},'cum')==1)
       vcum=getcolumn(dvh,2);
    for i=1:(length(vcum)-1)
        vdiff(i)=vcum(i)-vcum(i+1);
    end
    vdiff(length(vcum))=vcum(length(vcum));
    vdiff=vdiff';
        
    elseif(strcmp(plan{1,1}{3,1},'diff')==1)
       vdiff=getcolumn(dvh,2);
    for i=1:(length(vdiff)-1)
        vcum(i)=sum(vdiff(i:length(vdiff)));
        vcum=vcum';
    end     
    else
     error( 'volume format for %s in plan %s is not valid',DVH.structure,plan{1,1}{3,1});
      return;
    end
        
        nvdiff=vdiff./sum(vdiff);
    
    nvcum=vcum./max(vcum);
 

   % dbackup=d
    
    DVH.d=d;
    DVH.vdiff=vdiff;
    DVH.nvdiff=nvdiff;
    DVH.vcum=vcum;
    DVH.nvcum=nvcum;
  


end