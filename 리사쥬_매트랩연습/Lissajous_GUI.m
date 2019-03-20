function varargout = Lissajous_GUI(varargin)
% LISSAJOUS_GUI M-file for Lissajous_GUI.fig
%      LISSAJOUS_GUI, by itself, creates a new LISSAJOUS_GUI or raises the existing
%      singleton*.
%
%      H = LISSAJOUS_GUI returns the handle to a new LISSAJOUS_GUI or the handle to
%      the existing singleton*.
%
%      LISSAJOUS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISSAJOUS_GUI.M with the given input arguments.
%
%      LISSAJOUS_GUI('Property','Value',...) creates a new LISSAJOUS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Lissajous_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Lissajous_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Lissajous_GUI

% Last Modified by GUIDE v2.5 05-Apr-2015 21:05:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Lissajous_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Lissajous_GUI_OutputFcn, ...
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


% --- Executes just before Lissajous_GUI is made visible.
function Lissajous_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
global amp1;
global amp2;
global delay;
global ii;
global toggle;

amp1=get(handles.edit_ampA,'String');
amp2=get(handles.edit_ampB,'String');
delay=get(handles.edit_delay,'String');
toggle=get(handles.togglebutton2,'Value');
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Lissajous_GUI (see VARARGIN)

% Choose default command line output for Lissajous_GUI

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Lissajous_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Lissajous_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_ampA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ampA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ampA as text
%        str2double(get(hObject,'String')) returns contents of edit_ampA as a double

% --- Executes during object creation, after setting all properties.
function edit_ampA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ampA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ampB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ampB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ampB as text
%        str2double(get(hObject,'String')) returns contents of edit_ampB as a double


% --- Executes during object creation, after setting all properties.
function edit_ampB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ampB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in push_plot.
function push_plot_Callback(hObject, eventdata, handles)
% hObject    handle to push_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global amp1
global amp2
global delay
global ii
amp1=str2double(get(handles.edit_ampA,'String'));
amp2=str2double(get(handles.edit_ampB,'String'));
delay=eval(get(handles.edit_delay,'String'));

ii=1;

t=linspace(-pi,pi,1000);
slowness=150;

    while ii>0 && get(handles.togglebutton2,'Value')

        A=sin(amp1*2*pi*1*(ii/slowness));
        B=sin(amp2*2*pi*1*(ii/slowness)+delay);
        sin_graph=sin(amp1*2*pi*1*(t+ii/slowness));
        cos_graph=sin(amp2*2*pi*1*(t+ii/slowness)+delay);
        
        axes(handles.axes1);
        plot(handles.axes1,t,sin_graph);
        hold on;
        plot(handles.axes1,0,A,'r*','Markersize',10);
        hold off;
        axis([-pi pi -1 1]);
        grid on;

        
        axes(handles.axes2);
        plot(handles.axes2,t,cos_graph);
        
        hold on;
        plot(handles.axes2,0,B,'r*','MarkerSize',10);
        hold off;
        axis([-pi pi -1 1]);
        grid on;
        
        axes(handles.axes3);
        plot(handles.axes3,sin_graph,cos_graph);
        hold on;
        plot(handles.axes3,A,B,'r*','MarkerSize',10);
        grid on;
        hold off;
        pause(0.0001)
        
    ii=ii+1;
    end







function edit_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_delay as a double


% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
