function [X_Mesh, Y_Mesh, Z_Mesh] = MeshAndInterpolate2D(Coord, Func, PointNumber, CoordActionNum)
%Mesh grid and interpolate resulting function

% Calculate function on base grid
FuncInterp = scatteredInterpolant(Coord.Base(:, CoordActionNum(1)), Coord.Base(:, CoordActionNum(2)), Func);
FuncInterp.Method = 'natural';

% Create new grid by number of points
Xe = linspace(min(Coord.External(:, CoordActionNum(1))), max(Coord.External(:, CoordActionNum(1))), PointNumber);
Ye = linspace(min(Coord.External(:, CoordActionNum(2))), max(Coord.External(:, CoordActionNum(2))), PointNumber);
[X_Mesh, Y_Mesh] = meshgrid(Xe, Ye, PointNumber); %Calculating grid

% Calculate function on new grid
Z_Mesh = FuncInterp(X_Mesh, Y_Mesh); %Creating a interpolated function
if isempty(Z_Mesh) % Check plane exsistence
   error('Points should not lie on one line. Please, change numbers of coordinate axes in the variable CoordActionNum.');
end

end

