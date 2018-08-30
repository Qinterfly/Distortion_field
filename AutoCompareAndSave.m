tic %starting time
profile on; %Turn profiler
addpath('Export_fig'); %Add to path external library
addpath('Geometry', 'Results'); %Add to path file of input data (recursively)

%Clean the workspace and variables
clc; clear variables; close all;

%% ====================== Intial data set =================================

% ++ Example ++
% -------------------------------------------------------------------------
% FileName: multiple results (find name in 'Results' folder) = {'7Hz 12,8kHz 0,5N Eps=0.8 ExCh:#1', '12,3Hz 12,8kHz 5N Eps=0.8'} 
%           one channel = {'7Hz 12,8kHz 0,5N'}
% -------------------------------------------------------------------------
% ShowOption: multiselect = {'Distortion', 'Lissage', 'TimeSignal'}
%             one option = {'DistortionFourier'}
% -------------------------------------------------------------------------

CoordName.Base = 'CoordinateWingPanel3.xlsx'; %Name of file with cartesian coordinates of points
CoordName.External = 'ExternalCoordinateWingPanel.xlsx'; %Name of file with cartesian coordinates of external geometry
FileNameCompare = 'CompareWing.xlsx'; % Name of file with compare numbers
NumCoordAction = [1, 3]; % Number of coordinates for distortion calculation (X == 1, Y == 2, Z == 3)

%% ====================== Technical input =================================

ContourNumber = 20; %Number of contour lines
GridDensity = 250; %Number of grid point
PhysFactor = 1000; %Unit conversation ratio (m -> mm)

%% ====================== Calculate =================================

RawDir = dir('Results'); %Read content of directory
dirContent = [{}, RawDir.name]; %Add file names
isDir = [{}, RawDir.isdir]; %Add directory indicators
% Filter input directories
for i = length(isDir):-1:3
    if ~isDir{i}
        dirContent(i) = []; %Add file names
    end
end
dirContent(1:2) = []; % Delete technical paths

%Read contour cartesian coordinates
Coord.External = GetCoordinates(CoordName.External, PhysFactor); %Cartesian coordinate of external points
[~, ~, CompareTab] = xlsread(FileNameCompare); %Reading compare table

%Sort dir by compare tab
for i = 2:size(CompareTab, 1)
   for j = 1:length(dirContent)
      if contains(dirContent{j}, CompareTab{i, 2}) % Index #2: comparing file name 
        dirContentSort{i - 1} = dirContent{j};
      end       
   end       
end




