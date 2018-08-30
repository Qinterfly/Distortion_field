tic %starting time
profile on; %Turn profiler
addpath('Export_fig'); %Add to path external library
addpath(genpath('Signals'), 'Geometry', 'Results'); %Add to path file of input data (recursively)

%Clean the workspace and variables
clc; clear variables; close all;

%% ====================== Intial data set =================================

CoordName.Base = 'CoordinateWingPanel.xlsx'; %Name of file with cartesian coordinates of points
CoordName.External = 'ExternalCoordinateWingPanel.xlsx'; %Name of file with cartesian coordinates of external geometry
ChannelsDelNumb = []; %Define numbers of excluding channels (format: array of number of channel <= see Channels_name)
NumCoordAction = [1, 3]; % Number of coordinates for distortion calculation (X == 1, Y == 2, Z == 3)

%% ====================== Technical input =================================

ContourNumber = 20; %Number of contour lines
GridDensity = 250; %Number of grid point
PhysFactor = 1000; %Unit conversation ratio (m -> mm)

%% ================ Reading and transformation input data =================

RawDir = dir('Signals/WingPanel'); %Read content of directory
DirContent = [{}, RawDir.name]; %Add file names
DirContent(1:2) = []; %Del technical information
for FileInd = 1:length(DirContent)
    try
        FileName = DirContent{FileInd}(1:strfind(DirContent{FileInd}, '.mat') - 1); %Correct input format
        
% -- Function code ------------------------------------------------------------------------------------------

        %Reading the input data from a file
        load(FileName); %Reading data signal
        Coord.Base = GetCoordinates(CoordName.Base, PhysFactor); %Cartesian coordinate of inner points
        Coord.External = GetCoordinates(CoordName.External, PhysFactor); %Cartesian coordinate of external points
        Hz_num = min(strfind(FileName,'Hz')); kHz_num = strfind(FileName,'kHz');
        Hz_string = FileName(1, 1:(Hz_num - 1)); kHz_string = FileName(1, min(strfind(FileName,' '))+1:(kHz_num - 1));
        Freq_process = str2double(strrep(Hz_string, ',', '.')); %Setting the operating frquency, Hz
        Throughp_Freq = str2double(strrep(kHz_string, ',', '.'))*1000; %Sampling rate
        Period = 1 / Freq_process; %Setting the oscillation period, s
        
        MeasurmentNumber = ceil(Period * Throughp_Freq); %Number of measurement points
        Accel_quant = size(Coord.Base, 1); %Number of accelerometers
        StartRangeRead = 10; %Start of range reading data
        Rows_range_data = [StartRangeRead; MeasurmentNumber + StartRangeRead - 1]; Cols_range_data = [1; Accel_quant]; %Range reading data
        
        %Formation of data arrays
        Signal_time_glob = Signal_0.y_values.values; %Reading the time signal from Signal_0
        Channels_name = Signal_0.function_record.name'; %Reading channel names from Signal_0
        AccelForce = size(Signal_1.y_values.values,2); %Find quantity the accel. of force
        for i = 1:AccelForce
            Signal_time_glob(:, Accel_quant + i) = Signal_1.y_values.values(:, i); %Reading the time signal from Signal_1
            Channels_name{Accel_quant + i} = Signal_1.function_record.name(:, i); %Reading channel names from пїЅ Signal_1
        end
        Cols_range_data(2,1) = Cols_range_data(2,1) + AccelForce; %Add increment
        Signal_time_fix = Signal_time_glob(Rows_range_data(1,1):Rows_range_data(2,1),Cols_range_data(1,1):Cols_range_data(2,1)); %Reading a of the time signal
        
        for i = 1:length(Channels_name)
            Channels_name{i} = Channels_name{i}'; %Correct format of Channels_name
            Channels_name{i} = char(Channels_name{i});
        end
        Time_sim = zeros(MeasurmentNumber,1); %Create array of zeros
        for i = 1:MeasurmentNumber
            Time_sim(i,1) = 1 / Throughp_Freq * (i - 1); %Simulation time array
        end
        if AccelForce > 1   %Correct format of Channels_name
            for i = 1:AccelForce
                Channels_name{Accel_quant + i} = Channels_name{Accel_quant + i}'; %Last AccelForce
            end
        end
        
        %Exclude selected channels
        if ChannelsDelNumb
            ChannelsDelNumb = sort(ChannelsDelNumb, 'descend'); %Sort excluding array
            Accel_quant = Accel_quant - length(ChannelsDelNumb); %Correct numbers of accelerometers
            Cols_range_data(2) = Accel_quant; %Correct range of data
            for i = 1:length(ChannelsDelNumb) %Correct input data
                Coord.Base(ChannelsDelNumb(i), :) = [];
                Channels_name(ChannelsDelNumb(i)) = [];
                Signal_time_fix(:, ChannelsDelNumb(i)) = [];
            end
        end
        
        %% ========================= Calculating ==================================
        
        %Interpolate time signal
        h = Period/10^3; %Time step
        Time_int = (0:h:Period)'; %Grid for interpolation
        Signal_ch_int = interp1(Time_sim, Signal_time_fix, Time_int, 'spline', 'extrap'); %Interpolating the input time signal
        
        %Separation of harmonics
        DistortionFourierLength = floor(5000 / Freq_process); %Harmonics number
        EpsCoeffForce.Base = 0.8; %Accuracy coefficient
        Freq_fourier = 2 * pi /Period; %Fourier frequency
        FSeries = Fourier_series(Signal_ch_int, Time_int, Period, Cols_range_data, DistortionFourierLength, 1);
        Signal_fourier_coeffs = FSeries{1}; Signal_fourier = FSeries{2}; Signal_fourier_PhaseShift = FSeries{3};
        a0 = Signal_fourier_coeffs(2, :); %First fourier coefficient
        a = Signal_fourier_coeffs(3:DistortionFourierLength + 2, :); %Fourier cosinus coefficients
        b = Signal_fourier_coeffs(DistortionFourierLength + 3:size(Signal_fourier_coeffs, 1), :); %Fourier sinus coefficients
        
        FSeries_fix = Fourier_series_fix(a0, a, b, EpsCoeffForce.Base, Time_int, Freq_fourier, DistortionFourierLength); %Call FSerires function
        %Signal_fourier_fix = FSeries_fix{1};
        MaxSignal_fourier_fix = FSeries_fix{2}; %Format output data
        cFixIndex = FSeries_fix{3};
        for p = 1:size(a,2)
            s = 1; %Intial number of increment
            for i = 1:length(cFixIndex{end})
                aFix(s,p) = a(cFixIndex{end}(i),p); %Fix fourier coeffs on force accel.
                bFix(s,p) = b(cFixIndex{end}(i),p);
                s = s + 1; %Increment
            end
            for k = 1:length(Time_int)
                t = Time_int(k); %Current time
                Signal_fourier_fix(k,p) = a0(1,p) + aFix(:,p)'*cos(t*Freq_fourier.*cFixIndex{end}) + bFix(:,p)'*sin(t*Freq_fourier.*cFixIndex{end}); %Full fourier series
            end
        end
        
        %Calculating of twists
        for i = Cols_range_data(1):Cols_range_data(2)
            Distortion(:,i) = Signal_ch_int(:,i) - Signal_fourier_fix(:,i); %Finding the twist vector !TODO! - Last force accel.
            MaxDistortion(i,:) = max(abs(Distortion(:,i)))/max(abs(Signal_fourier_fix(:))); %Maximum of distortions
        end
        
        %Fourier series for distortion
        FSeries = Fourier_series(Distortion, Time_int, Period, Cols_range_data, DistortionFourierLength, 0); %Call Fourier_series function
        Distortion_fourier_coeffs = FSeries{1}; Distortion_fourier = FSeries{2}; %Result
        a0 = Distortion_fourier_coeffs(2,:); %First fourier coefficient
        a = Distortion_fourier_coeffs(3:DistortionFourierLength+2,:); %Fourier cosinus coefficients
        b = Distortion_fourier_coeffs(DistortionFourierLength+3:size(Distortion_fourier_coeffs,1),:); %Fourier sinus coefficients
        
        EpsCoeffForce.Fourier = 1e-1; %Accuracy coefficient
        FSeries_fix = Fourier_series_fix(a0, a, b, EpsCoeffForce.Fourier, Time_int, Freq_fourier, DistortionFourierLength); %Call FSerires function
        %Reduction of distortions from force sensor
        MaxDistortion_fix = MaxDistortion(1:Accel_quant,:); %Base
        
        %% ========================= SAVING RESULTS ===============================
        
        %Assign filename for results
        OutputFileName.Base = CreateOutputFileName(FileName, ChannelsDelNumb, EpsCoeffForce.Base);
        OutputFileName.Fourier = CreateOutputFileName(FileName, ChannelsDelNumb, EpsCoeffForce.Fourier);
        %Save base distortion field (non-mesh)
        OutputOperate(['Results/', OutputFileName.Base], 'Distortion.txt', [Coord.Base(:,NumCoordAction(1)),...
            Coord.Base(:,NumCoordAction(2)), MaxDistortion_fix], 'w');
        
        %% ========================= DISPLAYING RESULTS ===========================
        
        Fig1 = figure; %Create a graphic window
        Fig1.Color = [1 1 1]; %Set color of figure
        [X_Mesh, Y_Mesh, Z_Mesh] = MeshAndInterpolate2D(Coord, MaxDistortion_fix, GridDensity, NumCoordAction); %Mesh grid and interpolate resulting function
        contourf(X_Mesh, Y_Mesh, Z_Mesh, ContourNumber); %Plot a contour lines
        hold on; %Plot in one axes
        plot(Coord.Base(:, NumCoordAction(1)), Coord.Base(:, NumCoordAction(2)), 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', 'black',...
            'MarkerEdgeColor', 'none', 'Markersize', 10);
        title('Distortion field','Fontsize', 17); %Title of graphic
        xlabel('x, mm', 'Fontsize', 16, 'BackgroundColor', 'w');
        ylabel('y, mm', 'Fontsize', 16, 'BackgroundColor', 'w', 'Rotation', 90);
        zlabel('Max_distortion'); %Names of axes
        set(gca,'Fontsize', 15);
        cb = colorbar('Fontsize', 15); cb.Label.FontSize = 23; cb.Label.String = '\xi'; %Show gradient of colors
        Pushbutton1 = uicontrol('Style', 'pushbutton',... %Create popupmenu
            'String', 'Save figure',...
            'Position', [485 7 70 20],...
            'Callback', @Save_figure, 'Parent', Fig1, 'units', 'normalized');
        Screen_size = get(0, 'ScreenSize'); %Get screen size
        Fig1.Position = [0 0 Screen_size(3) Screen_size(4)];
        guidata(Fig1, {OutputFileName.Base Pushbutton1}); %Transfering local variables to callback function
        InverseContour(Coord.External(:, NumCoordAction(1)), Coord.External(:, NumCoordAction(2))); %Inverse contour filling
        plot(Coord.External(:, NumCoordAction(1)), Coord.External(:, NumCoordAction(2)), 'LineWidth', 2,'Color','r') %Plot external contour
        CreateLabelsCompositePanel(Coord.Base(:, NumCoordAction(1)), Coord.Base(:, NumCoordAction(2)), Channels_name); %Create lables for points
        ax = gca; ax.Box = 1; %Correct axes 

% ------------------------------------------------------------------------------------------------------------
        Pushbutton1.Callback(Fig1, []); %Autosave figure
        close(Fig1); %Close figure
%         disp(['The file: ', FileName, ' saved successfully']); %Exception
    catch
        disp(['The file: ', FileName, ' can not be saved']); %Exception
    end
end

toc %End of time
