function varargout = DEMO_GMM(varargin)
% Models a distribution as a mixture of Gaussians (GMM).
% This GUI is only for 2D distributions, but the main algorithm is
% for any dimensionality. 

% INPUT: It can be of two types:
%                   a)a Nx2 (Patterns X Features) matrix
%                   b)Can be selected from an B&W image
%
% OUTPUT: It is the parameters of the GMM (Mean vectors, 
%   Covariance matrices and weights of Gaussian components)

% This DEMO is based on 
%   -D. Ververidis and C. Kotropoulos,"Gaussian mixture modeling by 
%    exploiting the Mahalanobis distance," IEEE Trans. Signal 
%    Processing, vol. 56, issue 7B, pp. 2797-2811, 2008.

% Copyright @ D. Ververidis Version 7.1.4
% Last Modified by GUIDE v2.5 04-May-2009 22:43:01
clc;
clear gloabal;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DEMO_GMM_OpeningFcn, ...
                   'gui_OutputFcn',  @DEMO_GMM_OutputFcn, ...
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

function DEMO_GMM_OpeningFcn(hObject, eventdata, handles, varargin)
global DrawingMode
DrawingMode = 'Gaussians';
handles.DataFile = [];
handles.DataPathname = [];

handles.output = hObject;
guidata(hObject, handles);

function varargout= DEMO_GMM_OutputFcn(hObject, eventdata, handles) 
global StopByUser
StopByUser = 0;
addpath(pwd);
varargout{1} = handles.output;

function OpenDataFile_ClickedCallback(hObject, eventdata, handles)
[handles.DataFile,handles.DataPathname] =...
   uigetfile('*.*',['Select a .mat (Gaussian mode) or'  ...
                                  ' a .tif file (Lines mode)']);
guidata(hObject, handles);
if handles.DataFile~=0                      
    ViewPatterns(handles)
    set(findobj(gcf,'Tag','RunGMM'), 'Enable', 'on');
    guidata(hObject, handles);
end

function RunGMM_ClickedCallback(hObject, eventdata, handles)
global patterns StopByUser
global MixtWeight MixtMean MixtCov EmRep Tlapsed ProbMixt
guidata(hObject, handles);
ViewPatterns(handles)
set(findobj(gcf,'Tag','StopGMM'), 'Enable', 'on');
StopByUser = 0;
cd('Main')
[MixtWeight, MixtMean, MixtCov, EmRep, Tlapsed, ProbMixt] =...
          PropEMPdfEstim(patterns, 1, handles.VisualizationEMStep);
cd('..')
EmRep
MixtWeight
set(findobj(gcf,'Tag','SaveResult'), 'Enable', 'on');
guidata(hObject, handles);


function StopGMM_ClickedCallback(hObject, eventdata, handles)
global StopByUser
StopByUser = 1;

function SaveResult_ClickedCallback(hObject, eventdata, handles)
global MixtWeight MixtMean MixtCov EmRep Tlapsed ProbMixt
[ResFileName,ResPathName,ResFilterIndex] = ...
                uiputfile('*.mat','Save GMM','ResGMMUntitled.mat');
if ResFileName~=0               
  save([ResPathName ResFileName],'MixtWeight', 'MixtMean',...
                       'MixtCov', 'EmRep', 'Tlapsed', 'ProbMixt');
end

% -----------------------------------------------------------------
function DrawButton_ClickedCallback(hObject, eventdata, handles)
global patterns DrawingMode
NPatternsPerGaussian = 350;
handles.DataFile = 'DrawByMouse';

cd('Main');
patterns = PlotByMouse(DrawingMode,NPatternsPerGaussian);
cd('..');
set(findobj(gcf,'Tag','RunGMM'), 'Enable', 'on');
guidata(hObject, handles);
return

% -----------------------------------------------------------------
function HelpOnButtons_Callback(hObject, eventdata, handles)
HelpStr = textread('Help\HelpFile.txt', '%s', 'whitespace', '');
helpdlg(HelpStr,['Buttons Map']);



% % ---------------------------------------------------------------
% function LinesModeMenu_Callback(hObject, eventdata, handles)
% global DrawingMode
% DrawingMode = 'Lines';
% set(hObject,'Checked','on');
% set(findobj(gcf,'Tag','GaussiansModeMenu'),'Checked','off');

function GaussiansModeMenu_Callback(hObject, eventdata, handles)
global DrawingMode
DrawingMode = 'Gaussians';
set(hObject,'Checked','on');
set(findobj(gcf,'Tag','LinesModeMenu'),'Checked','off');

function ViewPatterns(handles)
global patterns

cla reset
if strcmp(handles.DataFile,'DrawByMouse') 
    plot(patterns(:,1)', patterns(:,2)','k.', 'MarkerSize', 2);
elseif strcmp(handles.DataFile(end-2:end),'mat')
    load([handles.DataPathname handles.DataFile]); %patterns
    %is the 2-D data to model
    plot(patterns(:,1)', patterns(:,2)','k.', 'MarkerSize', 2);
elseif strcmp(handles.DataFile(end-2:end),'tif') 
                                  % Lines Mode from a picture file
    BitmapMatrix = imread([handles.DataPathname ...
        handles.DataFile]);
    [MaxLines,MaxCols] = size(BitmapMatrix);
    patterns = [];
    BitmapMatrix=fliplr(BitmapMatrix');
    [patterns(:,  1),patterns(:,2)] = find(BitmapMatrix < 200);

    patterns(:,1) = patterns(:,1)/MaxCols;
    patterns(:,2) = patterns(:,2)/MaxLines;
    cla reset
    plot(patterns(:,1)', patterns(:,2)','k.', 'MarkerSize', 2);
    msgbox('Line modeling not available in 7.1.4')
end
axes(handles.AxesOfPatterns);
axis([0 1 0 1])
axis manual
drawnow

% -----------------------------------------------------------------
function PublicationOpen_Callback(hObject, eventdata, handles)
open('Help\Verver_GMM_DoubCol.pdf')


function VisualizeEMStepMenu_Callback(hObject, eventdata, handles)
contents = get(hObject,'String');
handles.VisualizationEMStep= ...
                           str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);


% -----------------------------------------------------------------
function VisualizeEMStepMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                         get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
contents = get(hObject,'String');
handles.VisualizationEMStep=...
                           str2num(contents{get(hObject,'Value')});
guidata(hObject, handles);


% --------------------------------------------------------------------
function VerverMenu_Callback(hObject, eventdata, handles)
web(['http://jimver.justfree.com/Index.htm'])

% --------------------------------------------------------------------
function KotroMenu_Callback(hObject, eventdata, handles)
web(['http://poseidon.csd.auth.gr/LAB_PEOPLE/CKotropoulos.htm'])




