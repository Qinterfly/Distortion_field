function Coord = GetCoordinates(CoordName, PhysFactor, CoordActionNum)
% Get coordinates from input .xlsx file

if isfile(CoordName)
    [~, ~, CoordInput] = xlsread(CoordName); %Reading cartesian coordinates of points
else
    error(['Geometry file: ', CoordName, ' is not found.']);
end

% Find number of X coordinate column
for j = 1:size(CoordInput, 2)
    if contains(CoordInput{1, j}, 'X')
       NumColumnCoord = j; 
       break;
    end 
end

% Cartesian coordinates of accel
Coord = cell2mat(CoordInput(2:end, NumColumnCoord:NumColumnCoord + 2)) * PhysFactor;
% Change sign of coordinates
for i = 1:length(CoordActionNum)
    if CoordActionNum(i) < 0
        Coord(:, abs(CoordActionNum(i))) = -Coord(:, abs(CoordActionNum(i)));
    end
end

end

