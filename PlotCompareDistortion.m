function [Fig, Pushbutton] = PlotCompareDistortion(Coord, XMesh, YMesh, Delta,...
                       OutputFileName, ScreenSize, ContourNumber, FillContourSign, AbsCoordActionNum)
% Plot graph of comparing distortion

Fig = figure;
Fig.Color = [1 1 1]; %Set color of figure
contourf(XMesh, YMesh, Delta, ContourNumber); %Plot a contour lines
hold on;
title(OutputFileName, 'Fontsize', 17); %Title of graphic
xlabel('x, mm', 'Fontsize', 16, 'BackgroundColor', 'w');
ylabel('y, mm', 'Fontsize', 16, 'BackgroundColor', 'w', 'Rotation', 90);
set(gca,'Fontsize', 15);
InverseContour(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), FillContourSign); %Inverse contour filling
plot(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), 'LineWidth', 2,'Color','r') %Plot external contour
cb = colorbar('Fontsize', 15); cb.Label.FontSize = 23; cb.Label.String = '\xi'; %Show gradient of colors
Pushbutton = uicontrol('Style', 'pushbutton',... %Create popupmenu
    'String', 'Save figure',...
    'Position', [485 7 70 20],...
    'Callback', @SaveFigure, 'Parent', Fig, 'units', 'normalized');
Fig.Position = [0 0 ScreenSize(3) ScreenSize(4)];
guidata(Fig,  {OutputFileName Pushbutton} ); %Transfering local variables to callback function
ax = gca; ax.Box = 1; %Correct axes

end

