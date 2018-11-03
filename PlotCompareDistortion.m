function [Fig, Pushbutton] = PlotCompareDistortion(Coord, XMesh, YMesh, Delta,...
                       OutputFileName, ScreenSize, ContourNumber, FillContourSign, AbsCoordActionNum)
% Plot graph of comparing distortion

Fig = figure;
Fig.Color = [1 1 1]; % Set color of figure
contourf(XMesh, YMesh, Delta, ContourNumber); % Plot a contour lines
hold on;

% -- Settings of the visualization ----------------------------------------

% title(OutputFileName, 'Fontsize', 17); % Title of the graphic

set(gca,'Fontsize', 30, 'XTick', [0, 500, 1000, 1500], 'YTick', [-300, 0, 300]); % Ticks for RRJFuzPanel

% Axis signatures
xlabel('X, mm', 'Fontsize', 40,'FontName','Times New Roman', 'Position',...
    [max(Coord.External(:, AbsCoordActionNum(1))) - 90, min(Coord.External(:, AbsCoordActionNum(2))) - 3, 0]);
ylabel('Z, mm','Rotation', 0, 'FontSize', 40,'FontName','Times New Roman', 'Position',...
    [min(Coord.External(:, AbsCoordActionNum(1))) - 110, max(Coord.External(:, AbsCoordActionNum(2))) - 50, 0]);

% Colorbar options
cb = colorbar('Fontsize', 30); % Show gradient of colors
annotation(gcf,'textbox', [0.91, 0.05, 0.056, 0.065],'String','\xi', 'Fontsize', 40,...
'EdgeColor', 'none', 'BackgroundColor', 'none', 'FontName','Times New Roman'); % Colobar title

% Pointers to the defect positions
annotation(gcf, 'doublearrow', [0.488, 0.488],[0.552, 0.435], 'LineWidth', 9, 'HeadSize', 25); %RRJFuzPanel Nadrez
annotation(gcf, 'arrow', [0.478, 0.478], [0.190, 0.110], 'LineWidth', 9, 'HeadSize', 25); % RRJFuzPanel CrackStr1
% annotation(gcf,'arrow', [0.472 0.472], [0.835 0.925], 'LineWidth', 9, 'HeadSize', 25); % RRJFuzPanel CrackStr5
annotation(gcf, 'arrow', [0.296, 0.296], [0.202, 0.282], 'LineWidth', 9, 'HeadSize', 25); % RRJFuzPanel CrackStr2

% -------------------------------------------------------------------------

InverseContour(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), FillContourSign); % Inverse contour filling
plot(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), 'LineWidth', 2, 'Color','r') % Plot external contour
Pushbutton = uicontrol('Style', 'pushbutton',... % Create popupmenu
    'String', 'Save figure',...
    'Position', [485, 7, 70, 20],...
    'Callback', @SaveFigure, 'Parent', Fig, 'units', 'normalized');
Fig.Position = [0 0 ScreenSize(3) ScreenSize(4)];
guidata(Fig,  {OutputFileName Pushbutton}); % Transfering local variables to callback function
ax = gca; ax.Box = 1; % Correct axes

end

