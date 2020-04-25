function xlswritefig(hFig,filename,sheetname,xlcell)

% XLSWRITEFIG  Write a MATLAB figure to an Excel spreadsheet
%
% xlswritefig(hFig,filename,sheetname,xlcell)
%
% All inputs are optional:
%
%    hFig:      Handle to MATLAB figure.  If empty, current figure is
%                   exported
%    filename   (string) Name of Excel file, including extension.  If not specified, contents will
%                  be opened in a new Excel spreadsheet.
%    sheetname:  Name of sheet to write data to. The default is 'Sheet1'
%                       If specified, a sheet with the specified name must
%                       exist
%    xlcell:     Designation of cell to indicate the upper-left corner of
%                  the figure (e.g. 'D2').  Default = 'A1'
%
% Requirements: Must have Microsoft Excel installed.  Microsoft Windows
% only.
%
% Ex:
% Paste the current figure into a new Excel spreadsheet which is left open.
%         plot(rand(10,1))
%         xlswritefig
%
% Specify all options.  
%         hFig = figure;      
%         surf(peaks)
%         xlswritefig(hFig,'MyNewFile.xlsx','Sheet2','D4')
%         winopen('MyNewFile.xlsx')   

% Scott Hirsch
% The MathWorks
% shirsch@mathworks.com
%
% Is this function useful?  Drop me a line to let me know!


if nargin==0 || isempty(hFig)
    hFig = gcf;
end

if nargin<2 || isempty(filename)
    filename ='';
    dontsave = true;
else
    dontsave = false;
end

if nargin < 3 || isempty(sheetname)
    sheetname = 'Sheet1';
end;

if nargin<4
    xlcell = 'A1';
end;


% Put figure in clipboard
hgexport(hFig,'-clipboard')


% Open Excel, add workbook, change active worksheet,
% get/put array, save.
% First, open an Excel Server.
Excel = actxserver('Excel.Application');

% Two cases:
% * Open a new workbook, save with given file name
% * Open an existing workbook

if exist(filename,'file')==0
    % The following case if file does not exist (Creating New File)
    op = invoke(Excel.Workbooks,'Add');
    %     invoke(op, 'SaveAs', [pwd filesep filename]);
    new=1;
else
    % The following case if file does exist (Opening File)
    %     disp(['Opening Excel File ...(' filename ')']);
    %Excel.Workbooks
    filename;
    op = invoke(Excel.Workbooks, 'open', [filename]);
    new=0;
end

% set(Excel, 'Visible', 0);

% Make the specified sheet active.
try
    Sheets = Excel.ActiveWorkBook.Sheets;
    target_sheet = get(Sheets, 'Item', sheetname);
catch %#ok<CTCH>   Suppress so that this function works in releases without MException
    % Error if the sheet doesn't exist.  It would be nice to create it, but
    % I'm too lazy.
    % The alternative to try/catch is to call xlsfinfo to see if the sheet exists, but
    % that's really slow.
    error(['Sheet ' sheetname ' does not exist!']);
end;

invoke(target_sheet, 'Activate');
Activesheet = Excel.Activesheet;


% Paste to specified cell
Paste(Activesheet,get(Activesheet,'Range',xlcell,xlcell))

% Save and clean up
if new && ~dontsave
    invoke(op, 'SaveAs', [pwd filesep filename]);
elseif ~new
    invoke(op, 'Save');
else  % New, but don't save
    set(Excel, 'Visible', 1);
    return  % Bail out before quitting Excel
end
invoke(Excel, 'Quit');
delete(Excel)
