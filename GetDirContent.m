function [DirContent, isDir] = GetDirContent(path, filterType)
% Get dir content and file identificators

% -d == directory flag, 
% -f == file flag.

RawDir = dir(path); %Read content of directory
DirContent = [{}, RawDir.name]; %Add file names
isDir = [{}, RawDir.isdir]; %Add directory indicators

% Del technical information
DirContent(1:2) = []; 
isDir(1:2) = [];

% Filter output information
switch filterType
    case '-f'
        for i = length(isDir):-1:1 % From end to beginтing
            if isDir{i}
                DirContent(i) = []; % Delete file names
                isDir(i) = []; % Delete file ID
            end
        end
    case '-d'
        for i = length(isDir):-1:1 % From end to beginтing
            if ~isDir{i}
                DirContent(i) = []; % Delete file names
                isDir(i) = []; % Delete file ID
            end
        end               
end

% Check results
if isempty(DirContent)
    disp(['Objects with elective type not found in directory: ', path]);
    isDir = -1;
    DirContent = -1;
end

end