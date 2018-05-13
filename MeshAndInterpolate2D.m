function [X_Mesh, Y_Mesh, Z_Mesh] = MeshAndInterpolate2D(X_Coord, Y_Coord, Func, PointNumber)
%Mesh grid and interpolate resulting function

FuncInterp = scatteredInterpolant(X_Coord.Base,Y_Coord.Base, Func);
FuncInterp.Method = 'natural';
[X_Mesh, Y_Mesh] = meshgrid(linspace(min(X_Coord.External),max(X_Coord.External),PointNumber),linspace(min(Y_Coord.External),max(Y_Coord.External),PointNumber)); %Calculating grid
Z_Mesh = FuncInterp(X_Mesh, Y_Mesh); %Creating a interpolated function

end

