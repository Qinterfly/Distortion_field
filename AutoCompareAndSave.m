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

CoordName.External = 'ExternalCoordinateWingPanel.xlsx'; %Name of file with cartesian coordinates of external geometry
FileNameCompare = 'CompareWing.xlsx'; % Name of file with compare numbers
CoordActionNum = [1, -3]; % Number of coordinates for distortion calculation (X == 1, Y == 2, Z == 3)

%% ====================== Technical input =================================

ContourNumber = 20; %Number of contour lines
GridDensity = 250; %Number of grid point
PhysFactor = 1000; %Unit conversation ratio (m -> mm)
FillContourSign = -1; % Derivative sign of fill contour

nColCompare = 2; % Сolumn number of indicies of comparing signals
nColResidue = 4; % Сolumn number of indicies of residue signals
ShiftCompareTab = 2; % Row shift of compare tab

%% ================ Reading and transformation input data =================

[~, ~, CompareTab] = xlsread(FileNameCompare); %Reading compare table

[dirContent, isDir] = GetDirContent('Results/WingPanel', '-d'); % Get directory content and ID by type of file

% Sort dir by compare tab
for i = ShiftCompareTab:size(CompareTab, 1)
    for j = 1:length(dirContent)
        if contains(dirContent{j}, CompareTab{i, nColCompare}) % Index #2: comparing file name
            dirContentSort{i - 1} = dirContent{j};
        end
    end
end

% Get indices of comparing signal
k = 0; % Initialize counter
for i = ShiftCompareTab:size(CompareTab, 1)
    string = CompareTab{i, nColResidue};
    if prod(~isnan(string)) % Checking format of string
        string = strrep(string, ' ', ''); % Parse string
        while true
            k = k + 1; % Increase counter
            endSymbol = strfind(string, ';'); % Find trailing character in a string
            midSymbol = strfind(string, '-'); % Find delimiter character in a string
            if isempty(endSymbol) % Checking the end of compraison in a string
                endSymbol = length(string) + 1;
            end
            indexForCompare(k, :) = [str2num(string(1:midSymbol - 1)), str2num(string(midSymbol + 1:endSymbol - 1))];
            string = string(endSymbol + 1:end); % Clear string
            if isempty(string)
                break;
            end
        end
    end
end

for FileInd = 1:size(indexForCompare, 1)
%     try
        firstName = dirContentSort{indexForCompare(FileInd, 1)};
        secondName = dirContentSort{indexForCompare(FileInd, 2)};
        FileName = {firstName, secondName}; %Correct input format
        
        % -- Function code ------------------------------------------------------------------------------------------
        
        AbsCoordActionNum = abs(CoordActionNum); % Absolute value of coordinates numbers
        Coord.External = GetCoordinates(CoordName.External, PhysFactor, CoordActionNum); %Cartesian coordinate of external points
        
        % +++
        SignalNumb = length(FileName); %Number of signals
        for i = 1:SignalNumb
            Signal{i} = OutputOperate('Results', [FileName{i},'/Distortion.txt'], 0, 'r'); %Read signals
            % Slice signal by coordinate number set
            Coord.Base(:, AbsCoordActionNum(1)) = Signal{i}(:, 1);
            Coord.Base(:, AbsCoordActionNum(2)) = Signal{i}(:, 2);
            %Calculate mesh for each signal
            [X_Mesh, Y_Mesh, DistortionSignal{i}] = MeshAndInterpolate2D(Coord, Signal{i}(:, 3),...
                GridDensity, AbsCoordActionNum); %Mesh grid and interpolate resulting function
        end
        Screen_size = get(0, 'ScreenSize'); %Get screen size
        for i = 1:SignalNumb
            for j = i + 1:SignalNumb
                Fig = figure(i + j);
                Fig.Color = [1 1 1]; %Set color of figure
                OutputFileName = [FileName{i} ' \ ' FileName{j}]; %Assign filename for results
                contourf(X_Mesh, Y_Mesh, abs(DistortionSignal{i} - DistortionSignal{j}), ContourNumber); %Plot a contour lines
                hold on;
                title(OutputFileName, 'Fontsize', 17); %Title of graphic
                xlabel('x, mm', 'Fontsize', 16, 'BackgroundColor', 'w');
                ylabel('y, mm', 'Fontsize', 16, 'BackgroundColor', 'w', 'Rotation', 90);
                InverseContour(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), FillContourSign); %Inverse contour filling
                plot(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), 'LineWidth', 2,'Color','r') %Plot external contour
                cb = colorbar('Fontsize', 15); cb.Label.FontSize = 23; cb.Label.String = '\xi'; %Show gradient of colors
                PushbuttonCompare = uicontrol('Style', 'pushbutton',... %Create popupmenu
                    'String', 'Save figure',...
                    'Position', [485 7 70 20],...
                    'Callback', @Save_figure, 'Parent', Fig, 'units', 'normalized');
                Fig.Position = [0 0 Screen_size(3) Screen_size(4)];
                guidata(Fig,  {OutputFileName PushbuttonCompare} ); %Transfering local variables to callback function
                ax = gca; ax.Box = 1; %Correct axes
                
                % --- Autosave figure ----------------------------------------------------------------------
                
                PushbuttonCompare.Callback(Fig, []); %Autosave figure
                close(Fig); %Close figure
                
                % ------------------------------------------------------------------------------------------
            end
        end
%    catch
%        disp(['The file: ', FileName, ' can not be saved']); %Exception
%    end
end

toc %End of time



