function [Fig, Pushbutton] = PlotDistortion(Coord, MaxDistortionFix, GridDensity, ...
    AbsCoordActionNum, ContourNumber, OutputFileName, FillContourSign, ChannelsName)
% Plot distortion field

Fig = figure; %Create a graphic window
Fig.Color = [1 1 1]; %Set color of figure
[XMesh, YMesh, ZMesh] = MeshAndInterpolate2D(Coord, MaxDistortionFix, GridDensity, AbsCoordActionNum); %Mesh grid and interpolate resulting function
contourf(XMesh, YMesh, ZMesh, ContourNumber); %Plot a contour lines
hold on; %Plot in one axes
plot(Coord.Base(:, AbsCoordActionNum(1)), Coord.Base(:, AbsCoordActionNum(2)), 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', 'black',...
    'MarkerEdgeColor', 'none', 'Markersize', 10);
title('Distortion field','Fontsize', 17); %Title of graphic
xlabel('x, mm', 'Fontsize', 16, 'BackgroundColor', 'w');
ylabel('y, mm', 'Fontsize', 16, 'BackgroundColor', 'w', 'Rotation', 90);
zlabel('Max_distortion'); %Names of axes
set(gca,'Fontsize', 15);
cb = colorbar('Fontsize', 15); cb.Label.FontSize = 23; cb.Label.String = '\xi'; %Show gradient of colors
Pushbutton = uicontrol('Style', 'pushbutton',... %Create popupmenu
    'String', 'Save figure',...
    'Position', [485 7 70 20],...
    'Callback', @SaveFigure, 'Parent', Fig, 'units', 'normalized');
Screen_size = get(0, 'ScreenSize'); %Get screen size
Fig.Position = [0 0 Screen_size(3) Screen_size(4)];
guidata(Fig, {OutputFileName.Base Pushbutton}); %Transfering local variables to callback function
InverseContour(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), FillContourSign); %Inverse contour filling
plot(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), 'LineWidth', 2,'Color','r') %Plot external contour
if ~isempty(ChannelsName)
   CreateLabelsForPanel(Coord.Base(:, AbsCoordActionNum(1)), Coord.Base(:, AbsCoordActionNum(2)), ChannelsName); %Create lables for points 
end
ax = gca; ax.Box = 1; %Correct axes
            
end

