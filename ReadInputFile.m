function Output = ReadInputFile(Input, Option)
% Read input data by parameter

switch Option
    case 'Single'
        % -- Get parameters from container --------------------------------        
        FileName = Input{1};
        CoordName = Input{2};
        DIRNAME_SIGNALS = Input{3};
        DIRNAME_GEOMETRY = Input{4};
        PhysFactor = Input{5};
        CoordActionNum = Input{6};
        StartRangeRead = Input{7};
        ChannelsDelNumb = Input{8};        
        % -----------------------------------------------------------------
        
        [FreqProcess, ThroughpFreq, Period, GeometryID] = ParseFileName(FileName); % Get charechteristics from filename
        FileName = strcat(DIRNAME_SIGNALS, FileName); % Add path to filename
        CoordName.Base = strcat(DIRNAME_GEOMETRY, CoordName.Base, GeometryID, '.xlsx'); % Concate geometry filename
        CoordName.External = strcat(DIRNAME_GEOMETRY, CoordName.External); % Concate geometry filename
        
        %Reading the input data from a file
        load(FileName); %Reading data signal
        Coord.Base = GetCoordinates(CoordName.Base, PhysFactor, CoordActionNum); %Cartesian coordinate of inner points
        Coord.External = GetCoordinates(CoordName.External, PhysFactor, CoordActionNum); %Cartesian coordinate of external points
        
        MeasurmentNumber = ceil(Period * ThroughpFreq); %Number of measurement points
        AccelQuant = size(Coord.Base, 1); %Number of accelerometers
        RowsRangeData = [StartRangeRead; MeasurmentNumber + StartRangeRead - 1]; ColsRangeData = [1; AccelQuant]; %Range reading data
        %Formation of data arrays
        SignalTimeGlob = Signal_0.y_values.values; %Reading the time signal from Signal_0
        ChannelsName = Signal_0.function_record.name'; %Reading channel names from Signal_0
        AccelForce = size(Signal_1.y_values.values,2); %Find quantity the accel. of force
        for i = 1:AccelForce
            SignalTimeGlob(:, AccelQuant + i) = Signal_1.y_values.values(:, i); %Reading the time signal from Signal_1
            ChannelsName{AccelQuant + i} = Signal_1.function_record.name(:, i); %Reading channel names from пїЅ Signal_1
        end
        ColsRangeData(2,1) = ColsRangeData(2,1) + AccelForce; %Add increment
        SignalTimeFix = SignalTimeGlob(RowsRangeData(1,1):RowsRangeData(2,1), ColsRangeData(1,1):ColsRangeData(2,1)); %Reading a of the time signal
        
        for i = 1:length(ChannelsName)
            ChannelsName{i} = ChannelsName{i}'; %Correct format of Channels_name
            ChannelsName{i} = char(ChannelsName{i});
        end
        TimeSim = zeros(MeasurmentNumber,1); %Create array of zeros
        for i = 1:MeasurmentNumber
            TimeSim(i,1) = 1 / ThroughpFreq * (i - 1); %Simulation time array
        end
        if AccelForce > 1   %Correct format of Channels_name
            for i = 1:AccelForce
                ChannelsName{AccelQuant + i} = ChannelsName{AccelQuant + i}'; %Last AccelForce
            end
        end
        
        %Exclude selected channels
        if ChannelsDelNumb
            ChannelsDelNumb = sort(ChannelsDelNumb, 'descend'); %Sort excluding array
            AccelQuant = AccelQuant - length(ChannelsDelNumb); %Correct numbers of accelerometers
            ColsRangeData(2) = AccelQuant; %Correct range of data
            for i = 1:length(ChannelsDelNumb) %Correct input data
                Coord.Base(ChannelsDelNumb(i), :) = [];
                ChannelsName(ChannelsDelNumb(i)) = [];
                SignalTimeFix(:, ChannelsDelNumb(i)) = [];
            end
        end
        AbsCoordActionNum = abs(CoordActionNum); % Absolute value of coordinates numbers
        
        % -- Set parameters to container --------------------------------
        Output{1} = FileName;
        Output{2} = CoordName;
        Output{3} = AbsCoordActionNum;
        Output{4} = Period;
        Output{5} = FreqProcess;
        Output{6} = TimeSim;
        Output{7} = SignalTimeFix;
        Output{8} = ColsRangeData;
        Output{9} = AccelQuant;
        Output{10} = Coord;
        Output{11} = ChannelsName;        
        % -----------------------------------------------------------------
    case 'Compare'
        % -- Get parameters from container --------------------------------        
        CoordName = Input{1};
        DIRNAME_GEOMETRY = Input{2};
        DIRNAME_RESULTS = Input{3};
        PhysFactor = Input{4};
        CoordActionNum = Input{5};
        FileNameCompare = Input{6}; 
        ModeCalculate = Input{7};
        % -----------------------------------------------------------------     
        
        %Read contour cartesian coordinates
        Coord.External = GetCoordinates(strcat(DIRNAME_GEOMETRY, CoordName.External), PhysFactor, CoordActionNum); %Cartesian coordinate of external points
        if strcmp(ModeCalculate, 'AutoCompare')
            FileName = GetComparingFileName(strcat(DIRNAME_GEOMETRY, FileNameCompare), DIRNAME_RESULTS);
        else
            FileName = [];
        end
        AbsCoordActionNum = abs(CoordActionNum); % Absolute value of coordinates numbers
        
        % -- Set parameters to container --------------------------------
        Output{1} = Coord;
        Output{2} = FileName;
        Output{3} = AbsCoordActionNum;       
        % -----------------------------------------------------------------        
end

