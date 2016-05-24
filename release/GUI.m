function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 14-May-2016 09:48:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;
handles.p1 = 0;
handles.p2 = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtImage_Callback(hObject, eventdata, handles)
% hObject    handle to txtImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtImage as text
%        str2double(get(hObject,'String')) returns contents of txtImage as a double


% --- Executes during object creation, after setting all properties.
function txtImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnBrowseImg.
function btnBrowseImg_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.*','Select an image');
if isequal(filename,0)
   % disp('User selected Cancel')
else
    image_path = fullfile(pathname, filename);
    set(handles.txtImage, 'String', image_path);
    axes(handles.axesImage)
    matlabImage = imread(image_path);
    image(matlabImage)
    axis off
    axis image
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject, 'Value');
set(handles.txtC,'String',num2str(value));
set(handles.txtError, 'Visible', 'off');

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function txtC_Callback(hObject, eventdata, handles)
% hObject    handle to txtC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtC as text
%        str2double(get(hObject,'String')) returns contents of txtC as a double
str = get(hObject,'String');
value = str2double(str);
if value >= 0 && value <= 1
    set(handles.slider3, 'Value', value);
    set(handles.txtError, 'Visible', 'off');
else
    set(handles.txtError, 'Visible', 'on');
end

% --- Executes during object creation, after setting all properties.
function txtC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txtP2y_Callback(hObject, eventdata, handles)
% hObject    handle to txtP2y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtP2y as text
%        str2double(get(hObject,'String')) returns contents of txtP2y as a double


% --- Executes during object creation, after setting all properties.
function txtP2y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtP2y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtP2x_Callback(hObject, eventdata, handles)
% hObject    handle to txtP2x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtP2x as text
%        str2double(get(hObject,'String')) returns contents of txtP2x as a double


% --- Executes during object creation, after setting all properties.
function txtP2x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtP2x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtP1x_Callback(hObject, eventdata, handles)
% hObject    handle to txtP1x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtP1x as text
%        str2double(get(hObject,'String')) returns contents of txtP1x as a double


% --- Executes during object creation, after setting all properties.
function txtP1x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtP1x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtP1y_Callback(hObject, eventdata, handles)
% hObject    handle to txtP1y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtP1y as text
%        str2double(get(hObject,'String')) returns contents of txtP1y as a double


% --- Executes during object creation, after setting all properties.
function txtP1y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtP1y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtDx_Callback(hObject, eventdata, handles)
% hObject    handle to txtDx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDx as text
%        str2double(get(hObject,'String')) returns contents of txtDx as a double


% --- Executes during object creation, after setting all properties.
function txtDx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axesImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesImage


% --- Executes on button press in btnDeghost.
function btnDeghost_Callback(hObject, eventdata, handles)
% hObject    handle to btnDeghost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[configs.dx, configs.dy] = calculate_shift_d(handles);
configs.c = str2double(get(handles.txtC, 'String'));
image_path = get(handles.txtImage, 'String');
fprintf('Starting deghost prova_%s...\n', image_path);
scale = 0.09;
my_deghost(image_path, configs, scale);


% --- Executes on button press in btndReset.
function btndReset_Callback(hObject, eventdata, handles)
% hObject    handle to btndReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txtP1x, 'String', '0');
set(handles.txtP1y, 'String', '0');
set(handles.txtP2x, 'String', '0');
set(handles.txtP2y, 'String', '0');
set(handles.txtDx, 'String', '0');
set(handles.txtDy, 'String', '0');
set(handles.slider3, 'Value', 0);
set(handles.p1, 'Visible', 'off');
set(handles.p2, 'Visible', 'off');
calculate_shift_d(handles);


% --- Executes on button press in btnSelectP1.
function btnSelectP1_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[p1, pts] = readImPoints();
if p1 ~= 0
    if handles.p1 ~= 0
        set(handles.p1, 'Visible', 'off');
    end
    handles.p1 = p1;
    guidata(hObject, handles);
    set(handles.p1, 'Visible', 'on');
    set(handles.txtP1x, 'String', num2str(floor(pts(1))));
    set(handles.txtP1y, 'String', num2str(floor(pts(2))));
    calculate_shift_d(handles);
end


% --- Executes on button press in btnSelectP2.
function btnSelectP2_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[p2, pts] = readImPoints();
if p2 ~= 0
    if handles.p2 ~= 0
        set(handles.p2, 'Visible', 'off');
    end
    handles.p2 = p2;
    guidata(hObject, handles);
    set(handles.p2, 'Visible', 'on');
    set(handles.txtP2x, 'String', num2str(floor(pts(1))));
    set(handles.txtP2y, 'String', num2str(floor(pts(2))));
    calculate_shift_d(handles);
end


function [p, pts] = readImPoints()

pts = zeros(2, 1);
hold on;           % keep it there while we plot
[xi, yi, but] = ginput(1);      % get a point
if isequal(but, 1)             % stop if not button 1
    pts(1) = xi;
    pts(2) = yi;
    p = plot(xi, yi, 'go');
end
hold off;

function [dx, dy] = calculate_shift_d(handles)
p1x = str2double(get(handles.txtP1x, 'String'));
p1y = str2double(get(handles.txtP1y, 'String'));
p2x = str2double(get(handles.txtP2x, 'String'));
p2y = str2double(get(handles.txtP2y, 'String'));
dx = p2x - p1x;
dy = p2y - p1y;
set(handles.txtDx, 'String', num2str(dx));
set(handles.txtDy, 'String', num2str(dy));


function txtDy_Callback(hObject, eventdata, handles)
% hObject    handle to txtDy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDy as text
%        str2double(get(hObject,'String')) returns contents of txtDy as a double


% --- Executes during object creation, after setting all properties.
function txtDy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
