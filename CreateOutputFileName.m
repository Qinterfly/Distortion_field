function OutputFileName = CreateOutputFileName(InputFileName, ChannelsDelNumb, EpsCoeff)

%Correct EpsCoeff format
EpsNum2StringTemp = num2str(EpsCoeff);
if EpsNum2StringTemp == fix(EpsNum2StringTemp) %Check decimal format
    EpsNum2string = EpsNum2StringTemp;
else
    EpsNum2string = strrep(num2str(EpsCoeff),'.',','); %Transleting numberic to string format
end
EpsNum2string = strcat(' Eps=', EpsNum2string); %Add variable id
OutputFileName = strcat(InputFileName, EpsNum2string); %Create output filename

%Add info about excluding channels
if ~isempty(ChannelsDelNumb)
    OutputFileName = strcat(OutputFileName, ' ExCh:#');
    for i = 1:length(ChannelsDelNumb)
        OutputFileName = strcat(OutputFileName, num2str(ChannelsDelNumb(i)));
        if i ~= length(ChannelsDelNumb) %Add delimiter
            OutputFileName = strcat(OutputFileName, ', ');
        end
    end
end

end


