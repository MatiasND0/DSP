function varargout = TP3(varargin)
% TP3 MATLAB code for TP3.fig
%      TP3, by itself, creates a new TP3 or raises the existing
%      singleton*.
%
%      H = TP3 returns the handle to a new TP3 or the handle to
%      the existing singleton*.
%
%      TP3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TP3.M with the given input arguments.
%
%      TP3('Property','Value',...) creates a new TP3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TP3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TP3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TP3

% Last Modified by GUIDE v2.5 30-Jun-2024 12:05:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TP3_OpeningFcn, ...
                   'gui_OutputFcn',  @TP3_OutputFcn, ...
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


% --- Executes just before TP3 is made visible.
function TP3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TP3 (see VARARGIN)

% Choose default command line output for TP3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TP3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TP3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in TB_muestra.
function TB_muestra_Callback(hObject, eventdata, handles)
% hObject    handle to TB_muestra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TB_muestra
% only image Bitmap
global Orig_Sig;
global sampfreq;
global time;
global valor_medio;
valor_medio=0;
[filename1, pathname1] = uigetfile('*.dat', 'Open file .dat');
if isequal(filename1, 0) || isequal(pathname1, 0)
    disp('File input canceled.');
    ECG_Data = [];
else
    fid=fopen(filename1,'r');
end;
time=10;
sampfreq=360;
f=fread(fid,2*360*time,'ubit12');
Orig_Sig=(f(1:2:length(f)));

plot(handles.axes1,Orig_Sig);
grid(handles.axes1);
xlim(handles.axes1,[0 sampfreq*time]);

% --- Executes on button press in PB_ValorMedio.
function PB_ValorMedio_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ValorMedio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Orig_Sig;
global sampfreq;
global time;

Orig_Sig = Orig_Sig/(1024*200);
Orig_Sig = (Orig_Sig-mean(Orig_Sig));
Orig_Sig = Orig_Sig/max(Orig_Sig);

fc = 60;

wc = fc/(sampfreq/2);  
bw = wc/35;
[b,a] = iirnotch(wc,bw);

% Aplicar el filtro a la señal
Orig_Sig_Filtrada = filter(b, a, Orig_Sig);

plot(handles.axes2,Orig_Sig_Filtrada);
grid(handles.axes2);
xlim(handles.axes2,[0 sampfreq*time]);
