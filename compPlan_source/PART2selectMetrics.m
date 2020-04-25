function varargout = PART2selectMetrics(varargin)
% PART2SELECTMETRICS MATLAB code for PART2selectMetrics.fig
%      PART2SELECTMETRICS, by itself, creates a new PART2SELECTMETRICS or raises the existing
%      singleton*.
%
%      H = PART2SELECTMETRICS returns the handle to a new PART2SELECTMETRICS or the handle to
%      the existing singleton*.
%
%      PART2SELECTMETRICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART2SELECTMETRICS.M with the given input arguments.
%
%      PART2SELECTMETRICS('Property','Value',...) creates a new PART2SELECTMETRICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PART2selectMetrics_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PART2selectMetrics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PART2selectMetrics

% Last Modified by GUIDE v2.5 17-Jun-2014 13:20:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PART2selectMetrics_OpeningFcn, ...
                   'gui_OutputFcn',  @PART2selectMetrics_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PART2selectMetrics is made visible.
function PART2selectMetrics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PART2selectMetrics (see VARARGIN)

% Choose default command line output for PART2selectMetrics
handles.output = hObject;
%% get data from part1 and add relevant fields to handles
Part1Handles=getappdata(0,'DataToShare');
AllStructures=cellstr(Part1Handles.Structures);
SelectedStructures=AllStructures(Part1Handles.index_selected);
handles.Structures=[];
for i=1:numel(SelectedStructures)
    [pathstr name ext]=fileparts(SelectedStructures{i});
    handles.Structures=setfield(handles.Structures,name,[]);   
end
handles.BaseDirectory=Part1Handles.BaseDirectory;
handles.plansSelected=Part1Handles.index_selected;
handles.plans=Part1Handles.Plans;
handles.MaxMetrics=0;
%%
%populate Strucure listbox 
StructureNames=fieldnames(handles.Structures);
handles.StructureNames=StructureNames;
set(handles.listbox1,'String',StructureNames);
%Populate metrics listbox 
handles.metrics={'min' 'max' 'mean' 'median' 'vol' 'Vy' 'isoX' 'SED' 'EUD' 'LogitEUD' 'TCPpossionLQ' 'TCPpossionLQadist' 'TCPd50' 'TCPlogit' 'TCPprobit' 'NTCPlkb' 'NTCPrs' 'NTCPcv'}; 
set(handles.listbox2,'String',handles.metrics);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PART2selectMetrics wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PART2selectMetrics_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function listbox1_Callback(hObject, eventdata, handles)
ParamterDisplayState('none',eventdata,handles)
SEDdisplayState('SEDhide',hObject,eventdata,handles)

structure_selected = get(hObject,'Value');
handles.structure_selected=structure_selected;
%update 'organ selected field'
set(handles.text1,'String',handles.StructureNames(structure_selected));
set(handles.text9,'String',handles.StructureNames(structure_selected));
if  isempty(handles.Structures.(handles.StructureNames{handles.structure_selected}))
    set(handles.listbox3,'String','no metrics selected');
else
    MetricsForThisOrgan=fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
    set(handles.listbox3,'String',MetricsForThisOrgan);
    handles.MetricsInBox=MetricsForThisOrgan;
end
handles.metrics_remove=[];
set(handles.listbox3,'Value',[])
set(handles.text10,'String','No Metric Selected')
guidata(hObject, handles);

function listbox1_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function listbox2_Callback(hObject, eventdata, handles)
SEDdisplayState('SEDhide',hObject,eventdata,handles)
ParamterDisplayState('none',eventdata,handles);
metrics_selected = get(hObject,'Value');
handles.metrics_selected=metrics_selected;
guidata(hObject, handles);

function listbox2_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_Callback(hObject, eventdata, handles)
%update metrics selected from here
    for i=1:numel(get(handles.listbox2,'Value'))       
       handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.metrics{handles.metrics_selected(i)})=[];
    end
set(handles.listbox3,'String',fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected})));
handles.MetricsInBox=fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
%set all the values of metrics to 0 - effectively preallocating to avoid
%crashes later
for i=1:numel(handles.MetricsInBox)
    handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{i}){7}='NoReference';
end
if sum(ismember(handles.MetricsInBox,'SED'))
    handles.Structures.(handles.StructureNames{handles.structure_selected}).SED{4}='NA';
end

if numel(handles.MetricsInBox)>handles.MaxMetrics
    handles.MaxMetrics=numel(handles.MetricsInBox);
end

guidata(hObject, handles);

function pushbutton2_Callback(hObject, eventdata, handles)
%this is the fun bit where we generate all text files
% generate structure_metrics.txt
fid=fopen(fullfile(handles.BaseDirectory,'structure_metrics.txt'),'w');
MaxNumMetrics=handles.MaxMetrics;
NumStructures=numel(handles.StructureNames);

%generate a cell array of 'null' strings to be overwritten as needed
NullArray=cellstr([repmat('null',NumStructures,1)]);
NullArray=repmat(NullArray,1,MaxNumMetrics);

Structures=fieldnames(handles.Structures)';

%replace entries in null array with metric names
%Vectorise this?
for i=1:numel(Structures)  
  
    if ~isempty(handles.Structures.(Structures{i}));
        metrics=fieldnames(handles.Structures.(Structures{i}));       
    
        %set up IsoX and Vy parameters if called   
%HAVE TO ADD SED
        if  sum(ismember(metrics,'Vy'))       
             if isempty(handles.Structures.(Structures{i}).Vy{1})
               warning('parameters for organ:%s metric:Vy not set',Structures{i})
               return
            end
            metrics(ismember(metrics,'Vy'))=strcat('VX',handles.Structures.(Structures{i}).Vy(1));
        end
        if  sum(ismember(metrics,'isoX'))
            if isempty(handles.Structures.(Structures{i}).isoX{1})
               warning('parameters for organ:%s metric:isoX not set',Structures{i})
               return
            end       
            metrics(ismember(metrics,'isoX'))=strcat('iso',handles.Structures.(Structures{i}).isoX(1));        
        end
         NullArray(i,1:numel(metrics))=metrics;
    end
end

formatSpec=repmat('%s ',1,MaxNumMetrics);
formatSpec=sprintf('%s %s',formatSpec,'%s\r\n');
PrintToFile=[Structures;NullArray'];

fprintf(fid,formatSpec,PrintToFile{:});
fclose(fid);
clear PrintToFile
%% Generate BaseDirectoryInfo.txt
fid=fopen(fullfile(handles.BaseDirectory,'BaseDirectoryInfo.txt'),'w');
fprintf(fid, 'maxNumMetrics %d\r\nmaxNumStructures %d\r\nmaxNumPlans %d\r\n', MaxNumMetrics, NumStructures, numel(handles.plans));

%% Generate the paramter files
%first we need to delete any parameter files which already exist as we are
%appending them
fclose('all');
TextFiles=dir([handles.BaseDirectory '\*.txt']);
TextFiles={TextFiles.name};
%remove the files we want to keep from this list
TextFiles(ismember(TextFiles,{'BaseDirectoryInfo.txt','plans.txt','structure_metrics.txt'}))=[];
for ii=1:numel(TextFiles)
    delete(fullfile(handles.BaseDirectory,TextFiles{ii}))
end

for i=1:numel(handles.StructureNames)
    if ~isempty(handles.Structures.(Structures{i}));
        metrics=fieldnames(handles.Structures.(handles.StructureNames{i}));
        for j=1:numel(metrics)
           
            try
            switch metrics{j} 
                case 'EUD'
                    fid=fopen(fullfile(handles.BaseDirectory,'eudparams.txt'),'at');
                    if isempty(handles.Structures.(handles.StructureNames{i}).EUD{1})
                        warning('parameters for %s EUD not set',handles.StructureNames{i})
                        return
                    end
                    PrintToFile=[handles.StructureNames(i) handles.Structures.(handles.StructureNames{i}).EUD(1) handles.Structures.(handles.StructureNames{i}).EUD(7)];
                    fprintf(fid,'%s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);                 
                case 'LogitEUD'
                    fid=fopen(fullfile(handles.BaseDirectory,'logitEUDparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).LogitEUD);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s LogitEUD not set',handles.StructureNames{i})
                        return
                    end
                    LogitEUDParamaters=handles.Structures.(handles.StructureNames{i}).LogitEUD(1:2);
                    PrintToFile=[handles.StructureNames{i} LogitEUDParamaters handles.Structures.(handles.StructureNames{i}).LogitEUD{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);  
                case 'TCPpossionLQ'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossionLQparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).TCPpossionLQ);
                    if sum(EmptyCheck(1:4))~=0
                        warning('parameters for %s TCPpossionLQ not set',handles.StructureNames{i})
                        return
                    end
                    TCPpossionLQparamters=handles.Structures.(handles.StructureNames{i}).TCPpossionLQ(1:4);
                    PrintToFile=[handles.StructureNames{i} TCPpossionLQparamters handles.Structures.(handles.StructureNames{i}).TCPpossionLQ{7}];
                    fprintf(fid,'%s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);                      
                case 'TCPpossionLQadist'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossionLQadistparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).TCPpossionLQadist);
                    if sum(EmptyCheck(1:6))~=0
                        warning('parameters for %s TCPpossionLQadist not set',handles.StructureNames{i})
                        return
                    end
                    TCPpossionLQadistParamters=handles.Structures.(handles.StructureNames{i}).TCPpossionLQadist(1:6);
                    PrintToFile=[handles.StructureNames{i} TCPpossionLQadistParamters handles.Structures.(handles.StructureNames{i}).TCPpossionLQadist{7}];
                    fprintf(fid,'%s %s %s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'TCPd50'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossiond50params.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).TCPd50);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s TCPd50 not set',handles.StructureNames{i})
                        return
                    end
                    TCPd50Paramters=handles.Structures.(handles.StructureNames{i}).TCPd50(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPd50Paramters handles.Structures.(handles.StructureNames{i}).TCPd50{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'TCPlogit'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPlogitparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).TCPlogit);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s TCPlogit not set',handles.StructureNames{i})
                        return
                    end
                    TCPlogitParamters=handles.Structures.(handles.StructureNames{i}).TCPlogit(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPlogitParamters handles.Structures.(handles.StructureNames{i}).TCPlogit{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'TCPprobit'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPprobitparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).TCPprobit);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s TCPprobit not set',handles.StructureNames{i})
                        return
                    end
                    TCPprobitParamters=handles.Structures.(handles.StructureNames{i}).TCPprobit(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPprobitParamters handles.Structures.(handles.StructureNames{i}).TCPprobit{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'NTCPlkb'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPlkbparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).NTCPlkb);
                    if sum(EmptyCheck(1:3))~=0
                        warning('parameters for %s NTCPlkb not set',handles.StructureNames{i})
                        return
                    end
                    NTCPlkbParamters=handles.Structures.(handles.StructureNames{i}).NTCPlkb(1:3);
                    PrintToFile=[handles.StructureNames{i} NTCPlkbParamters handles.Structures.(handles.StructureNames{i}).NTCPlkb{7}];
                    fprintf(fid,'%s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'NTCPrs'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPrsparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).NTCPrs);
                    if sum(EmptyCheck(1:3))~=0
                        warning('parameters for %s %s not set',handles.StructureNames{i},metrics{j})
                        return
                    end
                    NTCPrsParamters=handles.Structures.(handles.StructureNames{i}).NTCPrs(1:3);
                    PrintToFile=[handles.StructureNames{i} NTCPrsParamters handles.Structures.(handles.StructureNames{i}).NTCPrs{7}];
                    fprintf(fid,'%s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'NTCPcv'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPcvparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).NTCPcv);
                    if sum(EmptyCheck(1:6))~=0
                        warning('parameters for organ:%s metric:%s not set',handles.StructureNames{i},metrics{j})
                        return
                    end
                    NTCPcvParamters=handles.Structures.(handles.StructureNames{i}).NTCPcv(1:6);
                    PrintToFile=[handles.StructureNames{i} NTCPcvParamters handles.Structures.(handles.StructureNames{i}).NTCPcv{7}];
                    fprintf(fid,'%s %s %s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED'                 
                     fid=fopen(fullfile(handles.BaseDirectory,'SEDsatparams.txt'),'at');
                     EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED);
                     if sum(EmptyCheck(1:4))~=0
                        warning('parameters for organ:%s metric:%s not set',handles.StructureNames{i},metrics{j})
                        return
                     end
                    SEDsatParamters=handles.Structures.(handles.StructureNames{i}).SED(1:4);
                    PrintToFile=[handles.StructureNames{i} SEDsatParamters handles.Structures.(handles.StructureNames{i}).SED{7}];
                    fprintf(fid,'%s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);
                    
%Now account for situations where SED has been called
                 case 'SED_EUD'
                    fid=fopen(fullfile(handles.BaseDirectory,'eudparams.txt'),'at');
                    if isempty(handles.Structures.(handles.StructureNames{i}).SED_EUD{1})
                        warning('parameters for %s SED_EUD not set',handles.StructureNames{i})
                        return
                    end
                    PrintToFile=[handles.StructureNames(i) handles.Structures.(handles.StructureNames{i}).SED_EUD(1) handles.Structures.(handles.StructureNames{i}).SED_EUD(7)];
                    fprintf(fid,'%s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);                 
                case 'SED_LogitEUD'
                    fid=fopen(fullfile(handles.BaseDirectory,'logitEUDparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_LogitEUD);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s SED_LogitEUD not set',handles.StructureNames{i})
                        return
                    end
                    LogitEUDParamaters=handles.Structures.(handles.StructureNames{i}).SED_LogitEUD(1:2);
                    PrintToFile=[handles.StructureNames{i} LogitEUDParamaters handles.Structures.(handles.StructureNames{i}).SED_LogitEUD{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);  
                case 'SED_TCPpossionLQ'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossionLQparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQ);
                    if sum(EmptyCheck(1:4))~=0
                        warning('parameters for %s TCPpossionLQ not set',handles.StructureNames{i})
                        return
                    end
                    TCPpossionLQparamters=handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQ(1:4);
                    PrintToFile=[handles.StructureNames{i} TCPpossionLQparamters handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQ{7}];
                    fprintf(fid,'%s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);                      
                case 'SED_TCPpossionLQadist'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossionLQadistparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQadist);
                    if sum(EmptyCheck(1:6))~=0
                        warning('parameters for %s SED_TCPpossionLQadist not set',handles.StructureNames{i})
                        return
                    end
                    TCPpossionLQadistParamters=handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQadist(1:6);
                    PrintToFile=[handles.StructureNames{i} TCPpossionLQadistParamters handles.Structures.(handles.StructureNames{i}).SED_TCPpossionLQadist{7}];
                    fprintf(fid,'%s %s %s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_TCPd50'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPpossiond50params.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_TCPd50);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s SED_TCPd50 not set',handles.StructureNames{i})
                        return
                    end
                    TCPd50Paramters=handles.Structures.(handles.StructureNames{i}).SED_TCPd50(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPd50Paramters handles.Structures.(handles.StructureNames{i}).SED_TCPd50{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_TCPlogit'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPlogitparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_TCPlogit);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s SED_TCPlogit not set',handles.StructureNames{i})
                        return
                    end
                    TCPlogitParamters=handles.Structures.(handles.StructureNames{i}).SED_TCPlogit(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPlogitParamters handles.Structures.(handles.StructureNames{i}).SED_TCPlogit{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_TCPprobit'
                    fid=fopen(fullfile(handles.BaseDirectory,'TCPprobitparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_TCPprobit);
                    if sum(EmptyCheck(1:2))~=0
                        warning('parameters for %s SED_TCPprobit not set',handles.StructureNames{i})
                        return
                    end
                    TCPprobitParamters=handles.Structures.(handles.StructureNames{i}).SED_TCPprobit(1:2);
                    PrintToFile=[handles.StructureNames{i} TCPprobitParamters handles.Structures.(handles.StructureNames{i}).SED_TCPprobit{7}];
                    fprintf(fid,'%s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_NTCPlkb'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPlkbparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_NTCPlkb);
                    if sum(EmptyCheck(1:3))~=0
                        warning('parameters for %s SED_NTCPlkb not set',handles.StructureNames{i})
                        return
                    end
                    NTCPlkbParamters=handles.Structures.(handles.StructureNames{i}).SED_NTCPlkb(1:3);
                    PrintToFile=[handles.StructureNames{i} NTCPlkbParamters handles.Structures.(handles.StructureNames{i}).SED_NTCPlkb{7}];
                    fprintf(fid,'%s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_NTCPrs'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPrsparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_NTCPrs);
                    if sum(EmptyCheck(1:3))~=0
                        warning('parameters for %s %s not set',handles.StructureNames{i},metrics{j})
                        return
                    end
                    NTCPrsParamters=handles.Structures.(handles.StructureNames{i}).SED_NTCPrs(1:3);
                    PrintToFile=[handles.StructureNames{i} NTCPrsParamters handles.Structures.(handles.StructureNames{i}).SED_NTCPrs{7}];
                    fprintf(fid,'%s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid); 
                case 'SED_NTCPcv'
                    fid=fopen(fullfile(handles.BaseDirectory,'NTCPcvparams.txt'),'at');
                    EmptyCheck=cellfun(@isempty,handles.Structures.(handles.StructureNames{i}).SED_NTCPcv);
                    if sum(EmptyCheck(1:6))~=0
                        warning('parameters for organ:%s metric:%s not set',handles.StructureNames{i},metrics{j})
                        return
                    end
                    NTCPcvParamters=handles.Structures.(handles.StructureNames{i}).SED_NTCPcv(1:6);
                    PrintToFile=[handles.StructureNames{i} NTCPcvParamters handles.Structures.(handles.StructureNames{i}).SED_NTCPcv{7}];
                    fprintf(fid,'%s %s %s %s %s %s %s %s\r\n',PrintToFile{:});
                    clear PrintToFile
                    fclose(fid);             
                    
            end
            catch err
                warning('oops!!! something went wrong when creating the parameter files for  %s in %s',metrics{j},handles.StructureNames{i})
                rethrow(err)
            end
        end
    end
end



function pushbutton3_Callback(hObject, eventdata, handles)
%update metrics removed from here
MetricsInBox= fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
    for i=1:numel(handles.metrics_remove)         
handles.Structures.(handles.StructureNames{handles.structure_selected})=rmfield(handles.Structures.(handles.StructureNames{handles.structure_selected}),MetricsInBox{handles.metrics_remove(i)});
    end
    set(handles.listbox3,'Value',[])
set(handles.listbox3,'String',fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected})));
handles.MetricsInBox=fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
if numel(handles.MetricsInBox)>handles.MaxMetrics
    handles.MaxMetrics=numel(handles.MetricsInBox);
end
guidata(hObject, handles);
if numel(handles.MetricsInBox)<1
    set(handles.SED_checkbox,'Enable','Off')
end
guidata(hObject, handles);


function listbox3_Callback(hObject, eventdata, handles)
if sum(ismember(handles.MetricsInBox,'SED'))
    SEDdisplayState('SEDshow',hObject,eventdata,handles)
end
metrics_remove = get(hObject,'Value'); %not really an appropriate name actually...
handles.metrics_remove=metrics_remove;
if numel(metrics_remove)>1
    set(handles.text10,'String','Multiple Metrics Selected');
    ParamterDisplayState('none',eventdata,handles)
else
     MetricsInBox= fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
    set(handles.text10,'String',MetricsInBox{metrics_remove});
    
    switch(MetricsInBox{metrics_remove})
     
            case 'min'
            ParamterDisplayState('0',eventdata,handles)
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'max'
            ParamterDisplayState('0',eventdata,handles)
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'mean' 
            ParamterDisplayState('0',eventdata,handles)
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'median'
            ParamterDisplayState('0',eventdata,handles)
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'vol'
            ParamterDisplayState('0',eventdata,handles)
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'Vy'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','V(ydose) y');  
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'isoX'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','D(X%) X'); 
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'EUD'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','a');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'SED'
            ParamterDisplayState('4',eventdata,handles)
            set(handles.text11,'String','NumFract n');
            set(handles.text12,'String','StandDose.Fract std');
            set(handles.text14,'String','alpha/beta');
            set(handles.text13,'String','Saturation Dose?');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            SEDdisplayState('SEDhide',hObject,eventdata,handles)
            case 'LogitEUD'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','Gamma50');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'TCPpossionLQ'
            ParamterDisplayState('4',eventdata,handles)
            set(handles.text11,'String','NumFractions n');
            set(handles.text12,'String','alpha');
            set(handles.text14,'String','alpha/beta');
            set(handles.text13,'String','CellDensity p');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'TCPpossionLQadist'
             ParamterDisplayState('6',eventdata,handles)
            set(handles.text11,'String','MeanOfAlpha u');
            set(handles.text12,'String','SDofAlpha sd');            
            set(handles.text14,'String','NumFractions n');
             set(handles.text13,'String','alpha/beta');
            set(handles.text21,'String','cellDensity p');
            set(handles.text23,'String','dist: lognorm or norm');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'TCPd50'
             ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'TCPlogit'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'TCPprobit'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'NTCPlkb'
            ParamterDisplayState('3',eventdata,handles)
            set(handles.text11,'String','m');
            set(handles.text12,'String','n');
            set(handles.text14,'String','d50');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'NTCPrs'
            ParamterDisplayState('3',eventdata,handles)
            set(handles.text11,'String','d50');
            set(handles.text12,'String','gamm50');
            set(handles.text14,'String','s');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            case 'NTCPcv'
            ParamterDisplayState('6',eventdata,handles)
            set(handles.text11,'String','NumFract n');
            set(handles.text12,'String','alpha');            
            set(handles.text14,'String','alpha/beta');
             set(handles.text13,'String','Cells/FunctSubUnit k');
            set(handles.text21,'String','NumFunctSubUnit N');
            set(handles.text23,'String','NumSubUnitLoss M');
            SEDdisplayState('SEDoff',hObject,eventdata,handles)
            
            case 'SED_Vy'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','V(ydose) y');
            SEDdisplayState('SEDon',hObject,eventdata,handles)
            case 'SED_isoX'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','D(X%) X'); 
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_EUD'
            ParamterDisplayState('1',eventdata,handles)
            set(handles.text11,'String','a');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_LogitEUD'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','Gamma50');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_TCPpossionLQ'
            ParamterDisplayState('4',eventdata,handles)
            set(handles.text11,'String','NumFractions n');
            set(handles.text12,'String','alpha');
            set(handles.text14,'String','alpha/beta');
            set(handles.text13,'String','CellDensity p');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_TCPpossionLQadist'
             ParamterDisplayState('6',eventdata,handles)
            set(handles.text11,'String','MeanOfAlpha u');
            set(handles.text12,'String','SDofAlpha sd');            
            set(handles.text14,'String','NumFractions n');
             set(handles.text13,'String','alpha/beta');
            set(handles.text21,'String','cellDensity p');
            set(handles.text23,'String','dist: lognorm or norm');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_TCPd50'
             ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_TCPlogit'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_TCPprobit'
            ParamterDisplayState('2',eventdata,handles)
            set(handles.text11,'String','D50');
            set(handles.text12,'String','gamma50');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_NTCPlkb'
            ParamterDisplayState('3',eventdata,handles)
            set(handles.text11,'String','m');
            set(handles.text12,'String','n');
            set(handles.text14,'String','d50');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_NTCPrs'
            ParamterDisplayState('3',eventdata,handles)
            set(handles.text11,'String','d50');
            set(handles.text12,'String','gamm50');
            set(handles.text14,'String','s');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
            case 'SED_NTCPcv'
            ParamterDisplayState('6',eventdata,handles)
            set(handles.text11,'String','NumFract n');
            set(handles.text12,'String','alpha');            
            set(handles.text14,'String','alpha/beta');
             set(handles.text13,'String','Cells/FunctSubUnit k');
            set(handles.text21,'String','NumFunctSubUnit N');
            set(handles.text23,'String','NumSubUnitLoss M');
            SEDdisplayState('SEDon',hObject,eventdata,handles);
    end
end
guidata(hObject, handles);

function listbox3_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
parameter1=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1}=parameter1;
guidata(hObject, handles);

function edit3_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
parameter2=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2}=parameter2;
guidata(hObject, handles);

function edit4_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
parameter3=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){3}=parameter3;
guidata(hObject, handles);

function edit5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
parameter4=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){4}=parameter4;
guidata(hObject, handles);

function edit6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
parameter5=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){5}=parameter5;
guidata(hObject, handles);

function edit7_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit8_Callback(hObject, eventdata, handles)
parameter6=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){6}=parameter6;
guidata(hObject, handles);

function edit8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
reference=get(hObject,'String');
handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7}=reference;
guidata(hObject, handles);

function edit9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


    

% --- Executes on button press in pushbutton_Library.

function pushbutton_Library_Callback(hObject, eventdata, handles)
%%
%this function updates the handles.Structures info based on any relevant information in the "Library' folder 
    %the first file must be read by line by line as it is of unknown lenghth
fid=fopen(fullfile(pwd,'Library','structure_metrics.txt'));
i=0;
while ~feof(fid)
    i=i+1;
    LibraryData{i}=fgetl(fid);
    LibraryData2{i}=regexp(LibraryData{i},'\s','split');    
 
end
% reformat library structures to something meaningful
% my cell fun
LibraryStructures=cellfun(@(x) x{:}, LibraryData2, 'UniformOutput', false);

%now extract the available metrics and add them onto the available
%structures
for i=1:numel(LibraryStructures)
LibraryMetrics={LibraryData2{i}{2:end}};
Library.(LibraryStructures{i})=LibraryMetrics(:);
end

% Now, check to see if we have a library reference for our selected metrics.
StructuresToCheck=fieldnames(handles.Structures);
for i=1:numel(StructuresToCheck)   
index = strfind(lower(StructuresToCheck),lower(LibraryStructures{i}));
index = find(~cellfun(@isempty,index));

if numel(index)==1
    try
   metricsToCheck=fieldnames(handles.Structures.(StructuresToCheck{index}));
   metricsToRemove=ismember(metricsToCheck,{'min','max','mean','median','vol'});
   metricsToCheck(metricsToRemove)=[];
   member=ismember(Library.(LibraryStructures{i}),metricsToCheck);
   %Vx and Iso have to be checked and handled seperately which is a pain.
   if ~isempty(cellfun(@ (s) (strfind(s,'VX')), Library.(LibraryStructures{i}),'UniformOutput',false)) ...
           && sum(ismember(metricsToCheck,'Vy'))==1       
       Library.(LibraryStructures{i}){numel(Library.(LibraryStructures{i}))+1}='VolumeDose';
       member(numel(member)+1)=1;
   end
   if ~isempty(cellfun(@ (s) (strfind(s,'iso')), Library.(LibraryStructures{i}),'UniformOutput',false)) ...
           && sum(ismember(metricsToCheck,'isoX'))==1
       Library.(LibraryStructures{i}){numel(Library.(LibraryStructures{i}))+1}='IsoDose';
       member(numel(member)+1)=1;
   end
   FoundMetrics=find(member);
    catch
        display(sprintf('no metrics selected for %s',StructuresToCheck{index}));
        continue
    end
end


if sum(member)>=1
   for j=1:numel(FoundMetrics)
       LibraryMetric=Library.(LibraryStructures{i}){FoundMetrics(j)};
      
       switch LibraryMetric
           case 'VolumeDose' %Vy
              check=cellfun(@ (s) (strfind(s,'VX')), Library.(LibraryStructures{i}),'UniformOutput',false);
              MetricPosition=find(cellfun(@(x) any(x==1),check));
              MetricString=Library.(LibraryStructures{i}){MetricPosition};
              xval=MetricString(3:end);
              handles.Structures.(StructuresToCheck{index}).Vy{1}=xval; 
           case 'IsoDose' %isoX
             check=cellfun(@ (s) (strfind(s,'IsoDose')), Library.Bladder,'UniformOutput',false);
             MetricPosition=find(cellfun(@(x) any(x==1),check));
             MetricString=Library.(LibraryStructures{i}){MetricPosition};
             xval=MetricString(4:end);  
             handles.Structures.(StructuresToCheck{index}).isoX{1}=xval;  
           case 'SED'
               filename=fullfile(pwd,'Library','SEDsatparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %f %f %s %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));               
               n=C{2}(StructurePosition);
               std=C{3}(StructurePosition);
               a_b=C{4}(StructurePosition);
               sat=C{5}(StructurePosition);
               ref=C{6}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).SED{1}=num2str(n);
               handles.Structures.(StructuresToCheck{index}).SED{2}=num2str(std);
               handles.Structures.(StructuresToCheck{index}).SED{3}=num2str(a_b);
               handles.Structures.(StructuresToCheck{index}).SED{4}=sat;
               handles.Structures.(StructuresToCheck{index}).SED{7}=ref{:};                             
           case 'EUD' %EUD
               filename=fullfile(pwd,'Library','eudparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %s');
               fclose(fid);               
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               a=C{2}(StructurePosition);
               ref=C{3}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).EUD{1}=num2str(a);
               handles.Structures.(StructuresToCheck{index}).EUD{7}=ref{:};            
           case 'logitEUD'
               filename=fullfile(pwd,'Library','logitEUDparams.txt');
               fid = fopen(filename) ;      
               C=textscan (fid,'%s %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               d50=C{2}(StructurePosition);
               g50=C{3}(StructurePosition);
               ref=C{4}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).LogitEUD{1}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).LogitEUD{2}=num2str(g50);
               handles.Structures.(StructuresToCheck{index}).LogitEUD{7}=ref{:};               
           case 'TCPpossionLQ'
               filename=fullfile(pwd,'Library','TCPpossionLQparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %f %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));               
               n=C{2}(StructurePosition);
               a=C{3}(StructurePosition);
               a_b=C{4}(StructurePosition);
               p=C{5}(StructurePosition);
               ref=C{6}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQ{1}=num2str(n);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQ{2}=num2str(a);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQ{3}=num2str(a_b);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQ{4}=num2str(p);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQ{7}=ref{:};
           case 'TCPpossionLQadist'
               filename=fullfile(pwd,'Library','TCPpossionLQadistparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %f %f %f %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               u=C{2}(StructurePosition);
               sd=C{3}(StructurePosition);
               n=C{4}(StructurePosition);
               a_b=C{5}(StructurePosition);
               p=C{6}(StructurePosition);
               dist=C{7}(StructurePosition);
               ref=C{8}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{1}=num2str(u);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{2}=num2str(sd);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{3}=num2str(n);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{4}=num2str(a_b);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{5}=num2str(p);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{6}=num2str(dist);
               handles.Structures.(StructuresToCheck{index}).TCPpossionLQadist{7}=ref{:};
              
           case 'TCPpossiond50'
               filename=fullfile(pwd,'Library','TCPpossiond50params.txt');
               fid = fopen(filename);
               C=textscan (fid,'%s %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               d50=C{2}(StructurePosition);
               g50=C{3}(StructurePosition);
               ref=C{4}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).TCPd50{1}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).TCPd50{2}=num2str(g50);
               handles.Structures.(StructuresToCheck{index}).TCPd50{7}=ref{:};
           case 'TCPlogit'
               filename=fullfile(pwd,'Library','TCPlogitparams.txt');
               fid = fopen(filename) ;               
               C=textscan (fid,'%s %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               d50=C{2}(StructurePosition);
               g50=C{3}(StructurePosition);
               ref=C{4}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).TCPlogit{1}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).TCPlogit{2}=num2str(g50);
               handles.Structures.(StructuresToCheck{index}).TCPlogit{7}=ref{:};
           case 'TCPprobit'
               filename=fullfile(pwd,'Library','TCPprobitparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               d50=C{2}(StructurePosition);
               g50=C{3}(StructurePosition);
               ref=C{4}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).TCPprobit{1}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).TCPprobit{2}=num2str(g50);
               handles.Structures.(StructuresToCheck{index}).TCPprobit{7}=ref{:};           
           case 'NTCPlkb'
               filename=fullfile(pwd,'Library','NTCPlkbparams.txt');
               fid = fopen(filename);
               C=textscan (fid,'%s %f %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               m=C{2}(StructurePosition);
               n=C{3}(StructurePosition);
               d50=C{4}(StructurePosition);
               ref=C{5}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).NTCPlkb{1}=num2str(m);
               handles.Structures.(StructuresToCheck{index}).NTCPlkb{2}=num2str(n);
               handles.Structures.(StructuresToCheck{index}).NTCPlkb{3}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).NTCPlkb{7}=ref{:};
           case 'NTCPrs'
               filename=fullfile(pwd,'Library','NTCPrsparams.txt');
               fid = fopen(filename);
               C=textscan (fid,'%s %f %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               d50=C{2}(StructurePosition);
               g50=C{3}(StructurePosition);
               s=C{4}(StructurePosition);
               ref=C{5}(StructurePosition);
               handles.Structures.(StructuresToCheck{index}).NTCPrs{1}=num2str(d50);
               handles.Structures.(StructuresToCheck{index}).NTCPrs{2}=num2str(g50);
               handles.Structures.(StructuresToCheck{index}).NTCPrs{3}=num2str(s);
               handles.Structures.(StructuresToCheck{index}).NTCPrs{7}=ref{:};           
           case 'NTCPcv'
               filename=fullfile(pwd,'Library','NTCPcvparams.txt');
               fid = fopen(filename) ;
               C=textscan (fid,'%s %f %f %f %f %f %f %s');
               fclose(fid);
               StructurePosition=find(strcmp(C{1},LibraryStructures{i}));
               n=C{2}(StructurePosition);
               a=C{3}(StructurePosition);
               a_b=C{4}(StructurePosition);
               k=C{5}(StructurePosition);
               N=C{6}(StructurePosition);
               M=C{7}(StructurePosition);
               ref=C{8};
               handles.Structures.(StructuresToCheck{index}).NTCPcv{1}=num2str(n);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{2}=num2str(a);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{3}=num2str(a_b);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{4}=num2str(k);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{5}=num2str(N);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{6}=num2str(M);
               handles.Structures.(StructuresToCheck{index}).NTCPcv{7}=ref{:};
      end
end
end  

end
listbox3_Callback(hObject, eventdata, handles);


% --- Executes on button press in pushbutton_HelpMetrics.
function pushbutton_HelpMetrics_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_HelpMetrics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(['Select the structures one at a time. For each structure, select all the metrics you want to assess and click "Add Selected Metrics".'...
    ' In the third listbox, select each metric one at a time and enter any required data. The GUI does not check what data you enter - this is'...
    ' your responsibility! Repeat this process for each structure. Once you have finished, click "Create text Files". You have the option to'...
    ' analyse the base directory now, or you can do it later by running "Comp_plan_main". Best practice is to create seperate base directories for'...
    ' each set of plans you are working on. Note that using this GUI will overwrite ALL text files in the base directory you select. Finally,'...
    ' note that this GUI assumes that each of the plan folders in the base directory contain exactly the same structure names.'],'HELP')




function ParamterDisplayState(numberParamterInputsToDisplay, eventdata,handles)
switch numberParamterInputsToDisplay
    case 'none'
            set(handles.text20,'Visible','off');
            set(handles.text11,'Visible','off');
            set(handles.edit9,'Visible','off');            
            set(handles.edit3,'Visible','off');             
            set(handles.text12,'Visible','off');
            set(handles.edit4,'Visible','off');           
            set(handles.text14,'Visible','off');
            set(handles.edit5,'Visible','off');           
            set(handles.text13,'Visible','off');
            set(handles.edit6,'Visible','off');            
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');           
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '0'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','No Parameters Required');
            set(handles.text11,'Visible','off');
            set(handles.edit9,'Visible','off');          
            set(handles.edit3,'Visible','off');            
            set(handles.text12,'Visible','off');
            set(handles.edit4,'Visible','off');            
            set(handles.text14,'Visible','off');
            set(handles.edit5,'Visible','off');           
            set(handles.text13,'Visible','off');
            set(handles.edit6,'Visible','off');             
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');            
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '1'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');            
            set(handles.edit3,'Visible','on');
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','off');
            set(handles.edit4,'Visible','off');           
            set(handles.text14,'Visible','off');
            set(handles.edit5,'Visible','off');            
            set(handles.text13,'Visible','off');
            set(handles.edit6,'Visible','off');             
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');            
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '2'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');            
            set(handles.edit3,'Visible','on'); 
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','on');
            set(handles.edit4,'Visible','on'); 
            set(handles.edit4,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2})
            set(handles.text14,'Visible','off');
            set(handles.edit5,'Visible','off');           
            set(handles.text13,'Visible','off');
            set(handles.edit6,'Visible','off');             
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');           
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '3'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');            
            set(handles.edit3,'Visible','on');
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','on');
            set(handles.edit4,'Visible','on'); 
            set(handles.edit4,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2})
            set(handles.text14,'Visible','on');
            set(handles.edit5,'Visible','on'); 
            set(handles.edit5,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){3})
            set(handles.text13,'Visible','off');
            set(handles.edit6,'Visible','off');            
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');           
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '4'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');            
            set(handles.edit3,'Visible','on');
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','on');
            set(handles.edit4,'Visible','on');
            set(handles.edit4,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2})
            set(handles.text14,'Visible','on');
            set(handles.edit5,'Visible','on');
            set(handles.edit5,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){3})
            set(handles.text13,'Visible','on');
            set(handles.edit6,'Visible','on');
            set(handles.edit6,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){4})
            set(handles.text21,'Visible','off');
            set(handles.edit7,'Visible','off');           
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '5'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');           
            set(handles.edit3,'Visible','on');
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','on');
            set(handles.edit4,'Visible','on');
            set(handles.edit4,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2})
            set(handles.text14,'Visible','on');
            set(handles.edit5,'Visible','on');
            set(handles.edit5,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){3})
            set(handles.text13,'Visible','on');
            set(handles.edit6,'Visible','on');
            set(handles.edit6,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){4})
            set(handles.text21,'Visible','on');
            set(handles.edit7,'Visible','on');
            set(handles.edit7,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){5})
            set(handles.text23,'Visible','off');
            set(handles.edit8,'Visible','off');
    case '6'
            set(handles.text20,'Visible','on');
            set(handles.text20,'String','Reference:');
            set(handles.edit9,'Visible','on');
            set(handles.edit9,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){7})
            set(handles.text11,'Visible','on');           
            set(handles.edit3,'Visible','on');
            set(handles.edit3,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){1})
            set(handles.text12,'Visible','on');
            set(handles.edit4,'Visible','on');
            set(handles.edit4,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){2})
            set(handles.text14,'Visible','on');
            set(handles.edit5,'Visible','on');
            set(handles.edit5,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){3})
            set(handles.text13,'Visible','on');
            set(handles.edit6,'Visible','on');
            set(handles.edit6,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){4})
            set(handles.text21,'Visible','on');
            set(handles.edit7,'Visible','on');
            set(handles.edit7,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){5})
            set(handles.text23,'Visible','on');
            set(handles.edit8,'Visible','on');
             set(handles.edit8,'String',handles.Structures.(handles.StructureNames{handles.structure_selected}).(handles.MetricsInBox{handles.metrics_remove}){6})
end

function SEDdisplayState(displayState,hObject,eventdata,handles)
switch displayState
    case 'SEDshow'
        set(handles.SED_checkbox,'Enable','on');
    case 'SEDhide'
        set(handles.SED_checkbox,'Enable','off');
    case 'SEDon'        
         set(handles.SED_checkbox,'Value',1)
    case 'SEDoff'
        set(handles.SED_checkbox,'Value',0)
end


% --- Executes on button press in SED_checkbox.
function SED_checkbox_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to SED_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.SED_checkbox,'Value')==1 %add SED in front of every selected metric
    %first check for metrics which cannot be calculated with SED or already
    %have SED selected and remove these.
    addSEDMetrics=handles.MetricsInBox(get(handles.listbox3,'Value'));
    metricsToRemove=ismember(addSEDMetrics,{'min','max','mean','median','vol'});
    SEDalreadySelected=strfind(addSEDMetrics,'SED');
    SEDalreadySelected=find(cellfun(@(x) any(x==1),SEDalreadySelected));
    metricsToRemove(SEDalreadySelected)=1;
    addSEDMetrics(metricsToRemove)=[];     
    for i=1:numel(addSEDMetrics)
       metricSEDname{i}=strcat('SED_',addSEDMetrics{i});   
       [handles.Structures.(handles.StructureNames{handles.structure_selected}).(metricSEDname{i})]=handles.Structures.(handles.StructureNames{handles.structure_selected}).(addSEDMetrics{i});
       handles.Structures.(handles.StructureNames{handles.structure_selected})=rmfield(handles.Structures.(handles.StructureNames{handles.structure_selected}),addSEDMetrics{i});
    end
    % select the added SED metrics    
    NumMetrics=numel(handles.MetricsInBox);
    NewSEDmetrics=(NumMetrics-i+1:NumMetrics);
    set(handles.listbox3,'Value',NewSEDmetrics);
    SEDdisplayState('SEDon',hObject,eventdata,handles)
    
else
    %remove SED from all selected metrics
    removeSEDmetrics=handles.MetricsInBox(get(handles.listbox3,'Value'));
    for i=1:numel(removeSEDmetrics)
        if numel(removeSEDmetrics{i})>3 && strcmp(removeSEDmetrics{i}(1:4),'SED_')
            NewFieldName{i}=removeSEDmetrics{i}(5:end);
            [handles.Structures.(handles.StructureNames{handles.structure_selected}).(NewFieldName{i})]=handles.Structures.(handles.StructureNames{handles.structure_selected}).(removeSEDmetrics{i});
            handles.Structures.(handles.StructureNames{handles.structure_selected})=rmfield(handles.Structures.(handles.StructureNames{handles.structure_selected}),removeSEDmetrics{i});
        end
    end  
    %set selected metric to SEDric 
    NumMetrics=numel(handles.MetricsInBox);
    NewMetrics=(NumMetrics-i+1:NumMetrics);
    set(handles.listbox3,'Value',NewMetrics);
    SEDdisplayState('SEDoff',hObject,eventdata,handles)
end    
     set(handles.listbox3,'String',fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected})));
     handles.MetricsInBox=fieldnames(handles.Structures.(handles.StructureNames{handles.structure_selected}));
     guidata(hObject, handles);
     %this is not being updated....
   
% Hint: get(hObject,'Value') returns toggle state of SED_checkbox



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_HelpMetricsSelected.
function pushbutton_HelpMetricsSelected_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_HelpMetricsSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(['For each structure, you have to enter the necessary data for each metric you have selected. You can also try and do this using the'...
    'update from library button. See the "readme" file in the Library folder for more information. The code will not check that the data you enter'...
    'is correct or makes any sense. This is your responsiblity! Once all data has been entered and checked, click "create Text Files".'...
    'You are now ready to assess the base directory you have just created by running "Comp_Plan_Main.m" on it'],'HELP')

% --- Executes on button press in pushbutton_HelpStructures.
function pushbutton_HelpStructures_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_HelpStructures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(['Select the structures one at a time, and add whichever metrics you want to assess using the "add selected metrcs" button'],'HELP')

% --- Executes on button press in pushbuttop_HelpDataEntry.



