function []=Comp_Plan_main(BaseDirectoryLocation)

% Analyse a comp plan 'base directory'
% BaseDirectoryLocation is the directory in which the excel DVH files for the given
% plan are stored. If no base directory is input, a UI will be loaded to select one.
% For instructions on setting up a baseDirectory, please see the 
% instruction on GitHub.

% add the source files:
addpath('compPlan_source')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% user defined variables:
Mode='singleDirectory'; %'singleDirectory' or 'batch'. Batch simply loops over all supplied directories.
plotDVHs=1; % set values below to 1 to plot DVHs or the parameter
plotparams=0; % set values below to 1 to plot parameters
xlnum=1; %position of data in excel, if you wish to add data to a previous file this
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch Mode
    case 'singleDirectory'
        if nargin==0
            BaseDirectoryLocation=uigetdir('V:\Brendan\ED study\radiobiology base directory\IMRT\F3','select base directory');
        end
        fid=fopen(fullfile(BaseDirectoryLocation,'BaseDirectoryInfo.txt'));
        BaseDirectoryInfo=textscan(fid,'%s %f');

        maxnum_metrics=BaseDirectoryInfo{1,2}(1);
        number_structures=BaseDirectoryInfo{1,2}(2);
        maxnum_plans=BaseDirectoryInfo{1,2}(3);

        %read in list of plans which are to have metrics calculated for them

        plans=read_plans2(BaseDirectoryLocation,maxnum_plans);

        %read in list of metrics to be calculated for each structure

        structure_metrics=read_structure_metrics2(BaseDirectoryLocation,maxnum_metrics,number_structures);

        % %for each plan, for each structure calculate the required metrics and
        %output them in excel

        for i=1:maxnum_plans 

         %for excel output

        for l=1:number_structures
            %separate one cell string array per structure- for ease of
            %understanding
            st_structure_metrics=cellstr(structure_metrics{l}{1});
            DVHs=generate_DVHsboost (maxnum_metrics,BaseDirectoryLocation,plans{i},st_structure_metrics);
            DVHcombined{i,l}=DVHs;
            combmetric = calculate_structure_metrics8 (BaseDirectoryLocation,maxnum_metrics,st_structure_metrics,DVHs);
            metric=combmetric.metric;
            output_metrics_excel3(BaseDirectoryLocation,st_structure_metrics{1},i,maxnum_metrics,metric,xlnum,{plans{1,i}{1,1}{1,1}},st_structure_metrics);
        if plotparams==1
        output_metrics_excel3( BaseDirectoryLocation,[st_structure_metrics{1} 'params'],i,maxnum_metrics,combmetric.metricparams,xlnum,{plans{1,i}{1,1}{1,1}},st_structure_metrics);
        end
        end

        end
         if plotDVHs==1
        DVH4( BaseDirectoryLocation, number_structures,maxnum_plans,DVHcombined,'cumulative')
        close all
         end

    case 'batch'
        warning('not coded yet')
        if nargin==0
            BaseDirectoryLocation=uigetdir('V:\Brendan\ED study\radiobiology base directory\IMRT\F3','select base directory');
        end
    fid=fopen(fullfile(BaseDirectoryLocation,'BaseDirectoryInfo.txt'));
    BaseDirectoryInfo=textscan(fid,'%s %f');

    maxnum_metrics=BaseDirectoryInfo{1,2}(1);
    number_structures=BaseDirectoryInfo{1,2}(2);
    maxnum_plans=BaseDirectoryInfo{1,2}(3);


    %set values below to 1 if you want to plot the DVHs or the parameter
    %values or set it to anything else if you don't want to ( much quicker)
    plotDVHs=1;
    plotparams=0;

    %position of data in excel, if you wish to add data to a previous file this
    %can be changed to start where the previous data finished
    xlnum=1;


    % %read in list of plans which are to have metrics calculated for them

    plans=read_plans2(BaseDirectoryLocation,maxnum_plans);

    % %read in list of metrics to be calculated for each structure

     structure_metrics=read_structure_metrics2(BaseDirectoryLocation,maxnum_metrics,number_structures);

    % %for each plan, for each structure calculate the required metrics and
    %output them in excel

    for i=1:maxnum_plans 

     %for excel output

    for l=1:number_structures

        %separate one cell string array per structure- for ease of
        %understanding
    st_structure_metrics=cellstr(structure_metrics{l}{1});
    DVHs=generate_DVHsboost (maxnum_metrics,BaseDirectoryLocation,plans{i},st_structure_metrics);
    DVHcombined{i,l}=DVHs;
       combmetric = calculate_structure_metrics8 (BaseDirectoryLocation,maxnum_metrics,st_structure_metrics,DVHs);
       metric=combmetric.metric;
    output_metrics_excel3(BaseDirectoryLocation,st_structure_metrics{1},i,maxnum_metrics,metric,xlnum,{plans{1,i}{1,1}{1,1}},st_structure_metrics);
    if plotparams==1
    output_metrics_excel3( BaseDirectoryLocation,[st_structure_metrics{1} 'params'],i,maxnum_metrics,combmetric.metricparams,xlnum,{plans{1,i}{1,1}{1,1}},st_structure_metrics);
    end
    end

    end
     if plotDVHs==1
    DVH4( BaseDirectoryLocation, number_structures,maxnum_plans,DVHcombined,'cumulative')
    close all
     end
end

fclose all