function FileName = GetComparingFileName(FileNameCompare, DIRNAME_RESULTS)
% Get filenames matrix for comparing signals

nColCompare = 2; % Сolumn number of indicies of comparing signals
nColResidue = 4; % Сolumn number of indicies of residue signals
ShiftCompareTab = 2; % Row shift of compare tab
    
[~, ~, CompareTab] = xlsread(FileNameCompare); %Reading compare table

[dirContent, ~] = GetDirContent(DIRNAME_RESULTS, '-d'); % Get directory content and ID by type of file

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

% Get filenames by indexForCompare and dirContentSort
for i = 1:size(indexForCompare, 1)
    for j = 1:size(indexForCompare, 2)
        FileName{i, j} = dirContentSort{indexForCompare(i, j)}; % Slice local filename
    end    
end

end

