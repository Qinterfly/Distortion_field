function OutArg = OutputOperate(Location, FileName, Result, Option)
%Read-Wrtie distortion

ResFileName = strcat(Location, '/', FileName); %Concat loc+name
switch Option
    case 'r' %Read mode
        if isfile(ResFileName) %Check file
            OutArg = dlmread(ResFileName);
        else
            error('Non-existent file');
        end
    case 'w' %Write mode
        %Create loc folder
        if ~isfolder(Location)
            mkdir(Location);
        end
        dlmwrite(ResFileName, Result, 'precision', '%.8e');
        OutArg = 0; %Suc. arg.
end

end

