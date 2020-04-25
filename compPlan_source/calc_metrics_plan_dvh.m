%script to generate a given number of metrics for a given number of
%structures for a given number of plans, based on a directory structure
%including an excel file for each of the dvhs for each structure for each plan 
%and output these values into an excel file
% info required for reading in excel dvh file then calculating required
% metrics for study
%base directory is the directory in which the excel DVH files for the given
%plan are stored

%required variables- these together with the parameter files will need to
%be set for each calculation

%this was the final version of code for the EPSM manuscript July 2009

basedirectory='C:\directory here'
maxnum_metrics=4
number_structures=3
maxnum_plans=18

xlnum=1 %position of data in excel


% %read in list of plans which are to have metrics calculated for them
%  plan=read_list(basedirectory,'plans.txt')
% [m,n] = size(plan)
% numplans=m
% structure_metrics=read_structure_metrics2(basedirectory,maxnum_metrics,number_structures)

plans=read_plans2(basedirectory,maxnum_plans)

% %read in list of metrics to be calculated for each structure

 structure_metrics=read_structure_metrics2(basedirectory,maxnum_metrics,number_structures)

% %for each plan, for each structure calculate the required metrics and
%output them in excel

for i=1:maxnum_plans

 %for excel output
plannumber=maxnum_plans+1;
for l=1:number_structures
   
    %separate one cell string array per structure- for ease of
    %understanding
st_structure_metrics=cellstr(structure_metrics{l}{1})
   metric = calculate_structure_metrics4 (maxnum_metrics,basedirectory,plans{i},st_structure_metrics)
output_metrics_excel2(basedirectory,st_structure_metrics{1},i,maxnum_metrics,metric,xlnum,{plans{1,i}{1,1}{1,1}},st_structure_metrics)
 end
 end


