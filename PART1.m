function varargout = PART1(varargin)
% add the source files:
addpath('compPlan_source')
% PART1 MATLAB code for PART1.fig
%      PART1, by itself, creates a new PART1 or raises the existing
%      singleton*.
%
%      H = PART1 returns the handle to a new PART1 or the handle to
%      the existing singleton*.
%
%      PART1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART1.M with the given input arguments.
%
%      PART1('Property','Value',...) creates a new PART1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PART1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PART1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PART1

% Last Modified by GUIDE v2.5 03-Jul-2013 18:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PART1_OpeningFcn, ...
                   'gui_OutputFcn',  @PART1_OutputFcn, ...
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


% --- Executes just before PART1 is made visible.
function PART1_OpeningFcn(hObject, eventdata, handles, varargin)



% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PART1 (see VARARGIN)
handles.output = hObject;
% %set up the 'cum' and 'dif' button selection function
%set(handles.uipanel1,'SelectionChangeFcn',@DVHtype_buttongroup_SelectionChangeFcn);
set(handles.uipanel5,'SelectionChangeFcn',@DVHtype_buttongroup_SelectionChangeFcn);
set(handles.uipanel6,'SelectionChangeFcn',@DoseUnit_buttongroup_SelectionChangeFcn);
handles.DoseUnit='Gy';
handles.DVHtype='cum';
% % Update handles structure
 guidata(hObject, handles);


% Choose default command line output for PART1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PART1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PART1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function listbox1_Callback(hObject, eventdata, handles)
index_selected = get(hObject,'Value');
handles.index_selected=index_selected;
guidata(hObject, handles);

function listbox1_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_Callback(hObject, eventdata, handles)
fid=fopen(fullfile(handles.BaseDirectory,'plans.txt'),'w');

Unit=cellstr([repmat(handles.DoseUnit,numel(handles.Plans),1)])';
Type=cellstr([repmat(handles.DVHtype,numel(handles.Plans),1)])';

PrintToFile=[handles.Plans;Unit;Type];
fprintf(fid,'%s %s %s\r\n',PrintToFile{:});
fclose(fid);

%call part 2 and close part 1

setappdata(0,'DataToShare',handles);

PART2selectMetrics
%close(handles.figure1); %probably should fix the name here in case another figure is open first

function pushbutton2_Callback(hObject, eventdata, handles)

BaseDirectory=uigetdir(pwd,'select base directory');
d = dir(BaseDirectory);
isub = [d(:).isdir]; %# returns logical vector
PlanNames = {d(isub).name};
PlanNames(ismember(PlanNames,{'.','..'})) = [];

%Populate Plan Names section
 set(handles.text4,'String',PlanNames);
 
 %Populate ListBox of structures
 Structures=ls(fullfile(BaseDirectory,PlanNames{1},'*.xls*'));
 set(handles.listbox1,'String',Structures);
 %later will have to put in a routine for the situation where not all
 %structures are the same... 
 
handles.Structures=Structures;
handles.BaseDirectory=BaseDirectory;
handles.Plans=PlanNames;
guidata(hObject, handles);





function DVHtype_buttongroup_SelectionChangeFcn(hObject, eventdata)
%%
%retrieve GUI data, i.e. the handles structure

handles = guidata(hObject); 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton7'
        handles.DVHtype='cum';   
    case 'radiobutton8'
        handles.DVHtype='dif';
    otherwise
        %(don't actually think this line is needed but better safe...)
        handles.DVHtype='cum';    
end
%updates the handles structure
guidata(hObject, handles);

function DoseUnit_buttongroup_SelectionChangeFcn(hObject,eventdata)

handles=guidata(hObject);
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton9'
        handles.DoseUnit='Gy';   
    case 'radiobutton10'
        handles.DoseUnit='cGy';
    otherwise
        %(don't actually think this line is needed but better safe...)
        handles.DoseUnit='Gy';    
end
%updates the handles structure
guidata(hObject, handles);
