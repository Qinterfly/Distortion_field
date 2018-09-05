function [FreqProcess, ThroughpFreq, Period, GeometryID] = ParseFileName(FileName)
% Get charectheristics from filename

% Frequency and period
HzNum = min(strfind(FileName, 'Hz'));
kHzNum = strfind(FileName, 'kHz');
HzString = FileName(1, 1:(HzNum - 1)); 
kHzString = FileName(1, min(strfind(FileName,' ')) + 1:(kHzNum - 1));
FreqProcess = str2double(strrep(HzString, ',', '.')); %Setting the operating frquency, Hz
ThroughpFreq = str2double(strrep(kHzString, ',', '.')) * 1000; %Sampling rate
Period = 1 / FreqProcess; %Setting the oscillation period, s

% Geometry
PositionGeometryID = strfind(FileName, 'G'); % Find letter 'G' position in filename
for i = 1:length(PositionGeometryID)
    if isempty(str2num(FileName(PositionGeometryID + 1))) % Filter geometry position
       PositionGeometryID(i) = []; % Delete wrong index
    end
end

if length(PositionGeometryID) ~= 1
   error('Geometry ID of file is not found in filename'); % Filter validation check
end
    
GeometryID = 'G'; % First letter of geometry string
for i = PositionGeometryID + 1:length(FileName)
    sym = FileName(i); % Get symbol
    if ~isempty(str2num(sym))
        GeometryID = strcat(GeometryID, sym); % Add num to string
    else
        break;
    end        
end

end

