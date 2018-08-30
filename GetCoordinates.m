function Coord = GetCoordinates(CoordName, PhysFactor)
% Get coordinates from input .xlsx file

[~, ~, CoordInput] = xlsread(CoordName); %Reading cartesian coordinates of points

% Find number of X coordinate column
for j = 1:size(CoordInput, 2)
    if contains(CoordInput{1, j}, 'X')
       NumColumnCoord = j; 
       break;
    end 
end

% Cartesian coordinates of accel
Coord = cell2mat(CoordInput(2:end, NumColumnCoord:NumColumnCoord + 2)) * PhysFactor;

end

