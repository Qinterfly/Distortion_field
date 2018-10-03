function path = GetCorrectPath(path, option)
% Parse path name by option
% Option:
% 'Slash' == add slash to the end of path
% 'BackSlash' == add backslash to the end of path

switch option
    case 'Slash'
        if path(end) ~= '/' % Check ending symbol
            path = strcat(path, '/'); % Concate path with options' symbol
        end
    case 'BackSlash'
        if path(end) ~= '\' % Check ending symbol
            path = strcat(path, '\'); % Concate path with options' symbol
        end
end

