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
        load(FileName); % Reading data signal
        Coord.Base = GetCoordinates(CoordName.Base, PhysFactor, CoordActionNum); % Cartesian coordinate of inner points
        Coord.External = GetCoordinates(CoordName.External, PhysFactor, CoordActionNum); % Cartesian coordinate of external points
        
        % Calculate dimensions of the input data
        MeasurmentNumber = ceil(Period * ThroughpFreq); % Number of measurement points
        nAccel = size(Signal_0.y_values.values, 2); % Number of accelerometers
        RowsRangeData = [StartRangeRead; MeasurmentNumber + StartRangeRead - 1]; ColsRangeData = [1; nAccel]; % Range reading data
        
        % Formation of data arrays
        SignalTimeGlob = Signal_0.y_values.values; % Reading the time signal from Signal_0
        ChannelsName = Signal_0.function_record.name'; % Reading channel names from Signal_0
        nForceTrans = size(Signal_1.y_values.values, 2); % Find quantity of the accel of force
        for i = 1:nForceTrans
            SignalTimeGlob(:, nAccel + i) = Signal_1.y_values.values(:, i); % Reading the time signal from Signal_1
            ChannelsName{nAccel + i} = Signal_1.function_record.name(:, i); % Reading channel names from пїЅ Signal_1
        end
        ColsRangeData(2, 1) = ColsRangeData(2, 1) + nForceTrans; % Add increment
        SignalTimeFix = SignalTimeGlob(RowsRangeData(1, 1):RowsRangeData(2, 1), ColsRangeData(1,1):ColsRangeData(2,1)); % Reading a of the time signal
        
        % Correct format of Channels_name
        for i = 1:length(ChannelsName)
            ChannelsName{i} = ChannelsName{i}'; 
            ChannelsName{i} = char(ChannelsName{i});
        end
        
        % Add channel names of the accel force
        if nForceTrans > 1
            for i = 1:nForceTrans
                ChannelsName{nAccel + i} = ChannelsName{nAccel + i}'; %Last AccelForce
            end
        end
        
        % Create simulation time array
        TimeSim = zeros(MeasurmentNumber,1); % Create array of zeros
        for i = 1:MeasurmentNumber
            TimeSim(i, 1) = 1 / ThroughpFreq * (i - 1); % Simulation time array
        end
        
        % Exclude selected channels
        if ChannelsDelNumb
            ChannelsDelNumb = sort(ChannelsDelNumb, 'descend'); % Sort excluding array
            nAccel = nAccel - length(ChannelsDelNumb); % Correct numbers of the accelerometers
            ColsRangeData(2) = nAccel; % Correct range of data
            for i = 1:length(ChannelsDelNumb) % Correct of the input data
                Coord.Base(ChannelsDelNumb(i), :) = []; % Nullification of the cartesian coordinates of the points
                ChannelsName(ChannelsDelNumb(i)) = []; % Nullification of the channel names
                SignalTimeFix(:, ChannelsDelNumb(i)) = []; % Nulification of the time signals
            end
        end
        AbsCoordActionNum = abs(CoordActionNum); % Absolute value of coordinates numbers
        
        % -- Set parameters to container --------------------------------
        Output{1} = FileName;
        Output{2} = CoordName;
        Output{3} = AbsCoordActionNum;
        Output{4} = Period;
        Output{5} = FreqProcess;
        Output{6} = ThroughpFreq;
        Output{7} = TimeSim;
        Output{8} = SignalTimeFix;
        Output{9} = ColsRangeData;
        Output{10} = nAccel;
        Output{11} = Coord;
        Output{12} = ChannelsName;        
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
        
        % Read contour cartesian coordinates
        Coord.External = GetCoordinates(strcat(DIRNAME_GEOMETRY, CoordName.External), PhysFactor, CoordActionNum); % Cartesian coordinate of external points
        if strcmp(ModeCalculate, 'AutoCompare') % Check AutoCompare mode
            FileName = GetComparingFileName(strcat(DIRNAME_GEOMETRY, FileNameCompare), DIRNAME_RESULTS); % Write file names of the comparing signals
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

