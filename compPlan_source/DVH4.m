function []=DVH4(basedirectory, number_structures,maxnum_plans,DVH,option)
%Written by Brendan Whelan, 2011

%Generate DVH comparisons for different radiotherapy plans. runs within 
%calc_metrics_plan_dvh. 
%basedirectory, number_structures, maxnum_plans,DVH are all generated
%within calc_metrics_plan_dvh. option can be 'cumulative', 'all', or 'none'
%DVH is usually DVHcombined an array of structures containing DVH data as
%generated with generate_DVHs and combined

%%%%%ASSIGN COLOUR STRINGS TO ARRAY FOR USE IN PLOTTING%%%%%

% if 'maxnum_plans' is >12, the code will crash in the plotting stage. Easy
% to fix if it ever proves necessary
colours={'-r','--k',':b','-.c','g','-y',':m','-.r','-.r','k','-b','--c'};
close all;

switch option
    
    case 'cumulative'
      for i=1:number_structures  
          figure;
        hold on;
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.vcum,col)
            PLANS{j}=DVH{j,i}.plan;;
        end        
        xlabel('dose');
        ylabel('volume');
        title(DVH{j,i}.structure);;
        legend(PLANS,'Location','Best');
        hold off
        
        xlswritefig(figure(i),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'J12');
      end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    case 'all'
%dose vs vdiff
for i=1:number_structures
        figure;
        hold on;
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.vdiff,col) ;
            PLANS{j}=DVH{j,i}.plan;
        end        
        xlabel('dose');
        ylabel('volume');
        title([DVH{j,i}.structure ' ' 'vdiff']);
        legend(PLANS,'Location','Best');
        hold off;
        
        xlswritefig(figure(1),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'A12');
         
        %dose vs vcum
        figure;
        hold on
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.vcum,col)
            PLANS{j}=DVH{j,i}.plan;
        end        
        xlabel('dose');
        ylabel('volume');
        title('DVH of PTV for distorted plans recalculated on original ED');
        legend(PLANS,'Location','Best');
        hold off;
        
        xlswritefig(figure(1),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'J12');
        
        
%          %dose vs nvcum
        figure;
        hold on;
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.nvcum,col)  ;           
        end        
        xlabel('dose');
        ylabel('volume');
        title([DVH{j,i}.structure ' ' 'nvcum']);
        legend(PLANS,'Location','Best');
        hold off;
        
        xlswritefig(figure(3),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'P12');

                 %dose vs nvdiff
        figure;
        hold on;
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.nvdiff,col);        
        end        
        xlabel('dose');
        ylabel('volume');
        title([DVH{j,i}.structure ' ' 'nvdiff']);
        legend(PLANS,'Location','Best');
        hold off;
        
        xlswritefig(figure(4),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'V12');

       names=fieldnames(DVH{j,i});
       [m,n]=size(names);
        if m==8 
        %dose vs. SED
         figure;
        hold on;
        for j=1:maxnum_plans
            col=char(colours(j));
            plot(DVH{j,i}.d,DVH{j,i}.SED,col) ;
        end        
        xlabel('dose');
        ylabel('SED');
        title([DVH{j,i}.structure ' ' 'SED']);
        legend(PLANS,'Location','Best');
        hold off;
        
        xlswritefig(figure(5),fullfile(basedirectory,'metricresults.xls'),DVH{j,i}.structurecomplete,'Z12');
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'none';
return
end
close all;
end

