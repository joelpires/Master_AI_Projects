function varargout = mainGUI(varargin)
% MAINGUI MATLAB code for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 11-Nov-2017 16:06:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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

function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
%Set the default options to the popmenus and textboxes
set(handles.performanceFcn, 'Value',1);
set(handles.batchTrainingMethod, 'Value', 1);
set(handles.activationFunction, 'Value', 1);
set(handles.balance, 'Value', 1);
set(handles.specialization, 'Value', 1);
set(handles.postProcessing, 'Value', 1);
set(handles.trainingSetMenu, 'Value', 1);
set(handles.testSetMenu, 'Value', 1);
set(handles.numberLayers, 'String', '1');
set(handles.neuronsPerLayer, 'String', '4');
set(handles.epochs, 'String', '1000');
set(handles.learningRate, 'String', '0.05');
set(handles.goal, 'String', '1e-6');
set(handles.characteristics, 'String', '29');
set(handles.testPercentage, 'String', '0.3');
set(handles.trainPercentage, 'String', '0.7');


%Initializing the variables that we need
handles.trainingSet = '44202.mat';
handles.testSet = '44202.mat';
handles.preference = 'prever';
handles.specialization = 'media';
handles.balance = true;
handles.trainPercentage = 0.7;
handles.testPercentage = 0.3;
handles.postProcessing = '10 relaxed';
handles.characteristics = 29;
	

%Network Struct
handles.networkType = 'Feed Forward';
handles.numberLayers = 1;
handles.neuronsPerLayer = 4;
handles.activationFunction = 'logsig';
handles.learningRate = 0.05;
handles.epochs = 1000;
handles.goal = 1e-6;
handles.performanceFcn = 'sse';
handles.batchTrainingMethod = 'trainscg';



% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = mainGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function networkType_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trainingSetMenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function testSetMenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function networkType_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.networkType = contents{get(hObject,'Value')};
    guidata(hObject, handles);

function trainingSetMenu_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.trainingSet = contents{get(hObject,'Value')};
    strcat(handles.trainingSet, '.mat');
    
    guidata(hObject, handles);
    
function testSetMenu_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.testSet = strcat(contents{get(hObject,'Value')}, '.mat');
    guidata(hObject, handles);


function trainPercentage_Callback(hObject, eventdata, handles)
    handles.trainPercentage = str2double(get(hObject,'String'));
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function trainPercentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testPercentage_Callback(hObject, eventdata, handles)
    handles.testPercentage = str2double(get(hObject,'String'));
    guidata(hObject, handles);
    
% --- Executes during object creation, after setting all properties.
function testPercentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in balance.
function balance_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.balance = contents{get(hObject,'Value')};
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function balance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in preference.
function preference_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.preference = contents{get(hObject,'Value')};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function preference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in specialization.
function specialization_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.specialization = contents{get(hObject,'Value')};
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function specialization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to specialization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in performanceFcn.
function performanceFcn_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.performanceFcn = contents{get(hObject,'Value')};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function performanceFcn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performanceFcn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in activationFunction.
function activationFunction_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.activationFunction = contents{get(hObject,'Value')};
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function activationFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to activationFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neuronsPerLayer_Callback(hObject, eventdata, handles)
    handles.neuronsPerLayer = str2double(get(hObject,'String'));
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function neuronsPerLayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuronsPerLayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epochs_Callback(hObject, eventdata, handles)
    handles.epochs = str2double(get(hObject,'String'));
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function epochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberLayers_Callback(hObject, eventdata, handles)
    handles.numberLayers = str2double(get(hObject,'String'));
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function numberLayers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learningRate_Callback(hObject, eventdata, handles)
    handles.learningRate = str2double(get(hObject,'String'));
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function learningRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learningRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in batchTrainingMethod.
function batchTrainingMethod_Callback(hObject, eventdata, handles)
    contents = cellstr(get(hObject,'String'));
    handles.batchTrainingMethod = contents{get(hObject,'Value')};
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function batchTrainingMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batchTrainingMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function goal_Callback(hObject, eventdata, handles)
    handles.goal = str2double(get(hObject,'String'));
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function goal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in postProcessing.
function postProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to postProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns postProcessing contents as cell array
%        contents{get(hObject,'Value')} returns selected item from postProcessing


% --- Executes during object creation, after setting all properties.
function postProcessing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postProcessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in testButton.
function testButton_Callback(hObject, eventdata, handles)
    [ trainFeatVect, trainTrgMatrix, testFeatVect, testTrgMatrix ] = prepareDatasets(handles);
    [specificityPreIctal, sensitivityPreIctal, sensitivityIctal, specificityIctal, preIctaltp, Ictaltp, preIctalfp, Ictalfp, preIctaltn, Ictaltn, preIctalfn, Ictalfn] = testNetwork(handles,testFeatVect, testTrgMatrix);
    set(handles.sensitivityPreIctal,'String', strcat('Sensitivity:', num2str(sensitivityPreIctal)));
    set(handles.specificityPreIctal,'String', strcat('Specificity:', num2str(specificityPreIctal)));
    set(handles.preIctaltp,'String', strcat('True Positives:', num2str(preIctaltp)));
    set(handles.preIctaltn,'String', strcat('True Negatives:', num2str(preIctaltn)));
    set(handles.preIctalfp,'String', strcat('False Positives:', num2str(preIctalfp)));
    set(handles.preIctalfn,'String', strcat('False Negatives:', num2str(preIctalfn)));
    
    set(handles.sensitivityIctal,'String', strcat('Sensitivity:', num2str(sensitivityIctal)));
    set(handles.specificityIctal,'String', strcat('Specificity:', num2str(specificityIctal)));
    set(handles.Ictaltp,'String', strcat('True Positives:', num2str(Ictaltp)));
    set(handles.Ictaltn,'String', strcat('True Negatives:', num2str(Ictaltn)));
    set(handles.Ictalfp,'String', strcat('False Positives:', num2str(Ictalfp)));
    set(handles.Ictalfn,'String', strcat('False Negatives:', num2str(Ictalfn)));
    

% --- Executes on button press in trainingButton.
function trainingButton_Callback(hObject, eventdata, handles)
    handles.FeatVectSel = analyseCorrelation(handles);
    %First we prepare the dataset
    [ trainFeatVect, trainTrgMatrix, testFeatVect, testTrgMatrix] = prepareDatasets(handles);
   
    %Second we build the network
    Net = createNet(trainFeatVect, trainTrgMatrix, handles);

    %Third we train it
    trainNetwork(handles.trainingSet,trainFeatVect, trainTrgMatrix, Net, handles);



function characteristics_Callback(hObject, eventdata, handles)
    handles.learningRate = str2double(get(hObject,'String'));
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function characteristics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to characteristics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
