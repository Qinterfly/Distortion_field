function OutputFileName = CreateOutputFileName(InputFileName, ChannelsDelNumb, Dir)

% Delete technical information from FileName
OutputFileName = strrep(InputFileName, Dir, ''); % Path
OutputFileName = strrep(OutputFileName, '.mat', ''); % Extension

%Add info about excluding channels
if ~isempty(ChannelsDelNumb)
    OutputFileName = strcat(OutputFileName, ' ExCh= ');
    for i = 1:length(ChannelsDelNumb)
        OutputFileName = strcat(OutputFileName, num2str(ChannelsDelNumb(i)));
        if i ~= length(ChannelsDelNumb) %Add delimiter
            OutputFileName = strcat(OutputFileName, ', ');
        end
    end
end

end


