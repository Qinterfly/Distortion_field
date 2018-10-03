function CreateContourLabels(x, y, Channels_name)
% Create labels for points on the contour figure

ShiftX = 0.02 * mean(x); % Shift in percent for X 

for i = 1:length(x)
    if ~isempty(Channels_name{i}) %Check channel name
        Channels_name{i} = strrep(Channels_name{i}, '_', '.'); % Change _ -> . in channel name
        Pos_char = strfind(Channels_name{i},':'); %Find position of ':'
        IndSlice = Pos_char(2) + 1:Pos_char(3) - 1; %Indexes slice
        text(x(i) + ShiftX, y(i), Channels_name{i}(IndSlice), 'FontSize', 15); % Showing labels
    end
end

end

