
% =========================================================================
%
% Contributors: Lakiza Pavel, Zhukov Egor
% Version: 0.9
% Changes: - Function of ploting Lissage's figures is changed.
%          - GetFirstHarmonic function is deleted. 
%          - Excess functionality from CalculateSingle function are deleted.
%                                                                        
% =========================================================================

tic; % Start timer
% profile on; % Turn profiler
clc; clear variables; close all; % Clean the workspace and variables

%% ===================== Read-write constants =============================

DIRNAME_GEOMETRY = 'Geometry/';
DIRNAME_SIGNALS = 'Signals/RRJFuzPanel/Str2';
DIRNAME_RESULTS = 'Results/RRJFuzPanel/Str2';
DIRNAME_FOR_SAVE_DISTORTION_FIELD = 'Distortion field/RRJFuzPanelStr2';
LIBRARY_NAME = {'Export_fig'};

%% =================== Preprocessing ======================================

% Correcting format of RW constans 
DIRNAME_GEOMETRY = GetCorrectPath(DIRNAME_GEOMETRY, 'Slash');
DIRNAME_SIGNALS = GetCorrectPath(DIRNAME_SIGNALS, 'Slash');
DIRNAME_RESULTS = GetCorrectPath(DIRNAME_RESULTS, 'Slash');
DIRNAME_FOR_SAVE_DISTORTION_FIELD = GetCorrectPath(DIRNAME_FOR_SAVE_DISTORTION_FIELD, 'Slash');
% Add to path external library
for i = 1:length(LIBRARY_NAME)
    addpath(LIBRARY_NAME{i}); 
end
% addpath(genpath(SIGNALS_FILENAME), GEOMETRY_FILENAME, RESULTS_FILENAME); %Add to path file of input data (recursively)

%% ====================== Intial data set =================================

% ++ Example ++
% -------------------------------------------------------------------------
% FileName: multiple results (find name in 'Results' folder) = {'7Hz 12,8kHz 0,5N Eps=0.8 ExCh:#1', '12,3Hz 12,8kHz 5N Eps=0.8'}
%           one channel = {'7Hz 12,8kHz 0,5N'}
% -------------------------------------------------------------------------
% ShowOption: multiselect = {'Distortion', 'Lissage', 'TimeSignal'}
%             one option = {'DistortionFourier'}
% -------------------------------------------------------------------------
% ModeCalculate: 'Single' - for single files;
%                'Compare' - multiple file compraisons
%                'AutoSingle' - auto calculate all files in directory @DIRNAME_SIGNALS
%                'AutoCompare' - auto compare all files in directory @DIRNAME_RESULTS by @FileNameCompare
% -------------------------------------------------------------------------

ModeCalculate = 'Single';  % Calculation types = ['Single', 'Compare', 'AutoSingle', 'AutoCompare']
FileName = {'33,5Hz 25,6kHz Str2-75%Polka+BTr G3 1,5g'}; % Name of the file with input data
FileNameCompare = 'RRJFuzPanelCompare2.xlsx'; % Name of the file with compare table
CoordName.Base = 'RRJFuzPanelCoord_'; % Base part of filename with cartesian coordinates of points
CoordName.External = 'RRJFuzPanelExternCoord.xlsx'; % Name of file with cartesian coordinates of external geometry
Channel = 1; %Data evaluation channel
ChannelsDelNumb = []; %Define numbers of excluding channels (format: array of number of channel <= see Channels_name)
ShowOption = {'TimeSignal'}; %Show figure params{'TimeSignal', 'Distortion', 'Lissage'}. When comparing signals of an option of display are inactive
CoordActionNum = [1, -3]; % Numbers of coordinates axes for distortion calculation (X == 1, Y == 2, Z == 3) with sign.

%% ====================== Technical input =================================

ContourNumber = 20; % Number of contour lines
GridDensity = 250; % Number of grid point
PhysFactor = 1000; % Unit conversation ratio (m -> mm)
FillContourSign = -1; % Derivative sign of fill contour
StartRangeRead = 10; % Start of range reading data

%% +++++++++++++++++++ Single or AutoSingle +++++++++++++++++++++++++++++++

if strcmp(ModeCalculate, 'Single') || strcmp(ModeCalculate, 'AutoSingle')
    
    FileTab = FileName; % ModeCalculate == Single
    if strcmp(ModeCalculate, 'AutoSingle')
        [FileTab, ~] = GetDirContent(DIRNAME_SIGNALS, '-f'); % Get directory content and ID by type of file
        ShowOption = {'Distortion'}; % Show figure params
    end
    CoordName.BaseIn = CoordName.Base; % Save base name of base coordinate file
    CoordName.ExternalIn = CoordName.External; % Save base name of external coordinate file
    
    for i = 1:length(FileTab)
      
        % ================ Reading and transformation input data ==============
        
        CoordName.Base = CoordName.BaseIn; % Set input base name of base coordinate file
        CoordName.External = CoordName.ExternalIn; % Set input base name of external coordinate file
        ResultsSingle = ReadInputFile({FileTab{i}, CoordName, DIRNAME_SIGNALS, DIRNAME_GEOMETRY, PhysFactor,...
            CoordActionNum, StartRangeRead, ChannelsDelNumb}, 'Single');
        
        % -- Set results ------------------------------------------------------
        FileName = ResultsSingle{1};
        CoordName = ResultsSingle{2};
        AbsCoordActionNum = ResultsSingle{3};
        Period = ResultsSingle{4};
        FreqProcess = ResultsSingle{5};
        ThroughpFreq = ResultsSingle{6};
        TimeSim = ResultsSingle{7};
        SignalTimeFix = ResultsSingle{8};
        ColsRangeData = ResultsSingle{9};
        nAccel = ResultsSingle{10};
        Coord = ResultsSingle{11};
        ChannelsName = ResultsSingle{12};
        % ---------------------------------------------------------------------
        
        % ========================= Calculating ===============================
        
        [Distortion, MaxDistortionFix, SignalChInt, FirstHarmonic, FirstHarmonicPhaseShift, TimeInt] = CalculateSingle(Period,...
            ThroughpFreq, TimeSim, SignalTimeFix, ColsRangeData, nAccel);
        
        % ========================= Saving results ============================
        
        % Assign filename for results
        OutputFileName = CreateOutputFileName(FileName, ChannelsDelNumb, DIRNAME_SIGNALS);
        % Save base distortion field (non-mesh)
        OutputOperate([DIRNAME_RESULTS, OutputFileName], 'Distortion.txt', [Coord.Base(:, abs(CoordActionNum(1))),...
            Coord.Base(:, abs(CoordActionNum(2))), MaxDistortionFix], 'w');
        
        % ========================= Displaying results ========================
        
        for i = 1:length(ShowOption)
            switch ShowOption{i}
                case 'TimeSignal' % Display the time signal for selected channel
                    FigTimeSignal = PlotTimeSignal(TimeInt, SignalChInt, FirstHarmonic, Distortion, Channel);
                case 'Distortion' % Display of distortion field
                    [FigDistortion, PushbuttonDistortion]= PlotDistortion(Coord, MaxDistortionFix, GridDensity, ...
                        AbsCoordActionNum, ContourNumber, OutputFileName, FillContourSign, ChannelsName);
                    PushbuttonDistortion.Callback(FigDistortion, [], DIRNAME_SIGNALS, strcat(DIRNAME_FOR_SAVE_DISTORTION_FIELD, ModeCalculate, '/')); % Autosave distortion field
                case 'Lissage' % Display Lissage figure for selected channel
                    FigLissage = PlotLissage(SignalChInt, FirstHarmonicPhaseShift, ChannelsName, Channel);
            end
        end
        % Save distortion field in AutoSingle mode
        if strcmp(ModeCalculate, 'AutoSingle')
            PushbuttonDistortion.Callback(FigDistortion, [], DIRNAME_SIGNALS, strcat(DIRNAME_FOR_SAVE_DISTORTION_FIELD, ModeCalculate, '/')); % Autosave figure
            close(FigDistortion);
        end
    end
end 

%% +++++++++++++++++++ Compare or AutoCompare +++++++++++++++++++++++++++++

if strcmp(ModeCalculate, 'Compare') || strcmp(ModeCalculate, 'AutoCompare')    
    
    % ================ Reading and transformation input data ==============
    
    ResultCompare = ReadInputFile({CoordName, DIRNAME_GEOMETRY, DIRNAME_RESULTS, PhysFactor,...
        CoordActionNum, FileNameCompare, ModeCalculate}, 'Compare'); 
    % -- Set results ------------------------------------------------------
    Coord = ResultCompare{1}; 
    if strcmp(ModeCalculate, 'AutoCompare') 
        FileName = ResultCompare{2}; 
    end
    AbsCoordActionNum = ResultCompare{3};
    % ---------------------------------------------------------------------
    
    % ========================= Displaying results ========================
    
    FileNameSize = size(FileName);
    ScreenSize = get(0, 'ScreenSize'); %Get screen size
    for i = 1:FileNameSize(1)
        for j = 1:FileNameSize(2)
        Signal{i, j} = OutputOperate(DIRNAME_RESULTS, [FileName{i, j}, '/Distortion.txt'], 0, 'r'); %Read signals
        Coord.Base = zeros(size(Signal{i, j}, 1), 3); %Allocate memory for coordinates
        % Slice signal by coordinate number set
        Coord.Base(:, AbsCoordActionNum(1)) = Signal{i, j}(:, 1);
        Coord.Base(:, AbsCoordActionNum(2)) = Signal{i, j}(:, 2);
        % Calculate mesh for each signal
        [XMesh, YMesh, DistortionSignal{i, j}] = MeshAndInterpolate2D(Coord, Signal{i, j}(:, 3), GridDensity, AbsCoordActionNum); %Mesh grid and interpolate resulting function
        end
    end
    
    for i = 1:FileNameSize(1)
        for j = 1:FileNameSize(2) - 1
            OutputFileName = [FileName{i, j} ' & ' FileName{i, j + 1}]; % Assign filename for results
            [FigCompare, PushbuttonCompare] = PlotCompareDistortion(Coord, XMesh, YMesh, (DistortionSignal{i, j} - DistortionSignal{i, j + 1}),...
                OutputFileName, ScreenSize, ContourNumber, FillContourSign, AbsCoordActionNum);
            % Save distortion field in AutoCompare mode
            if strcmp(ModeCalculate, 'Compare') || strcmp(ModeCalculate, 'AutoCompare') 
                PushbuttonCompare.Callback(FigCompare, [], DIRNAME_SIGNALS, strcat(DIRNAME_FOR_SAVE_DISTORTION_FIELD, ModeCalculate, '/')); %Autosave figure
                close(FigCompare); % Close figure
            end
        end
    end
end

toc %End of time
