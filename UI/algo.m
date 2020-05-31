function varargout = algo(varargin)
%ALGO MATLAB code file for algo.fig
%      ALGO, by itself, creates a new ALGO or raises the existing
%      singleton*.
%
%      H = ALGO returns the handle to a new ALGO or the handle to
%      the existing singleton*.
%
%      ALGO('Property','Value',...) creates a new ALGO using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to algo_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ALGO('CALLBACK') and ALGO('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ALGO.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help algo

% Last Modified by GUIDE v2.5 04-Dec-2017 18:48:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @algo_OpeningFcn, ...
                   'gui_OutputFcn',  @algo_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before algo is made visible.
function algo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

addpath('H:\UVa\Courses\Fall 2017\Algorithms\Final Project\');

threshPix = 0.9;

img = imread('H:\UVa\Courses\Fall 2017\Algorithms\Final Project\apple.jpg');
imshow(img);

[imgPIX, pts] = getImagePixInfo(img,threshPix);

% pts = pts(ceil(size(pts,1)*rand(samplePts,1)),:);
disp(['# of points: ' num2str(length(pts))]);

handles.currentPoints = pts;
handles.currentImage = img;
handles.currentPixImage = imgPIX;

% Choose default command line output for algo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes algo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = algo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choose_pb.
function choose_pb_Callback(hObject, eventdata, handles)
% hObject    handle to choose_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,~] = uigetfile('H:\UVa\Courses\Fall 2017\Algorithms\Final Project\.jpg');
img = imread([PathName FileName]);
imshow(img);

threshPix = 0.9;

[imgPIX, pts] = getImagePixInfo(img,threshPix);

% pts = pts(ceil(size(pts,1)*rand(samplePts,1)),:);
disp(['# of points: ' num2str(length(pts))]);

handles.currentPoints = pts;
handles.currentImage = img;
handles.currentPixImage = imgPIX;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imshow(handles.currentImage);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % MST Prim
disp('MST - Prims');
pts4mst = handles.currentPoints;
outMST = getMSTPrims( pts4mst );

% Plot MST
nanPos = find(isnan(outMST) == 1);
imshow(handles.currentPixImage);title('MST');hold on;
for i=2:length(nanPos)
    treePart = outMST(nanPos(i-1)+1:nanPos(i)-1);
    plot(pts4mst(treePart,2),pts4mst(treePart,1));
end
hold off;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Nearest neighbour
disp('Started NN TSP');
pts4tsp = handles.currentPoints;
NNcnctPts = NNtsp(pts4tsp);

imshow(handles.currentPixImage);hold on;
plot(NNcnctPts(:,2),NNcnctPts(:,1));hold off;

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Nearest neighbour
disp('Started NN TSP');
pts4tsp = handles.currentPoints;
NNcnctPts = NNtsp(pts4tsp);

% 2-opt
disp('Started 2opt TSP');
twoOPTcnctPots = twoOPTtsp(NNcnctPts,3);

imshow(handles.currentPixImage);title('TSP + 2-Opt');hold on;
plot(twoOPTcnctPots(:,2),twoOPTcnctPots(:,1));hold off;

function [outImg, outPts] = getImagePixInfo(img,threshPix)

imgGray = rgb2gray(img);
threshBW = graythresh(imgGray);
imgBW = im2bw(imgGray,threshBW);

% check size
[m, n] = size(imgGray);

% Grid size
grid_m = 5;
grid_n = 5;

imgGridResize = imgBW(1:floor(m/grid_m)*grid_m,1:floor(n/grid_n)*grid_n);
[mResize, nResize] = size(imgGridResize);
imgPIX = ones(mResize,nResize);

% Pixilate the image
for i=1:grid_m:mResize
    for j=1:grid_n:nResize
        
        gridVals = imgGridResize(i:i+grid_m-1,j:j+grid_n-1);
        if mean(gridVals(:)) < threshPix
            imgPIX(i+floor((grid_m-1)*rand(1)),j+floor((grid_n-1)*rand(1))) = 0;
        end
        
    end
end

% Get the points
[ptsX, ptsY] = find(imgPIX == 0);
pts = [ptsX ptsY];
pts = unique(pts,'rows');

outImg = imgPIX;
outPts = pts;