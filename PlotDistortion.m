function [Fig, Pushbutton] = PlotDistortion(Coord, MaxDistortionFix, GridDensity, ...
    AbsCoordActionNum, ContourNumber, OutputFileName, FillContourSign, ChannelsName)
% Plot distortion field

Fig = figure; %Create a graphic window
Fig.Color = [1 1 1]; %Set color of figure
[XMesh, YMesh, ZMesh] = MeshAndInterpolate2D(Coord, MaxDistortionFix, GridDensity, AbsCoordActionNum); %Mesh grid and interpolate resulting function
contourf(XMesh, YMesh, ZMesh, ContourNumber); %Plot a contour lines
hold on; %Plot in one axes
plot(Coord.Base(:, AbsCoordActionNum(1)), Coord.Base(:, AbsCoordActionNum(2)), 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', 'white',...
'MarkerEdgeColor', 'black', 'Markersize', 12, 'LineWidth', 1.8);
%title('Distortion field','Fontsize', 17); %Title of graphic
xlabel('X, mm', 'Fontsize', 50, 'Position', [max(Coord.External(:, AbsCoordActionNum(1))), min(Coord.External(:, AbsCoordActionNum(2))), 0]);
ylabel('Y, mm','Rotation', 0, 'Fontsize', 50, 'Position', [min(Coord.External(:, AbsCoordActionNum(1))), max(Coord.External(:, AbsCoordActionNum(2))), 0]);
% xlabel('X', 'Position', [max(Coord.External(:, AbsCoordActionNum(1))), min(Coord.External(:, AbsCoordActionNum(2))), 0]);

%set(gca,'Fontsize', 30, 'XTick',[0 500 1000 1500],'YTick',[-300 0 300]); %Ticks for RRJFuzPanel

set(gca,'Fontsize', 30, 'XTick',[0 400 800 1200],'YTick',[-100 0 100]); %Ticks for RRJRib

zlabel('Max_distortion'); %Names of axes
cb = colorbar('Fontsize', 30); %Show gradient of colors 'Ticks',[0.4 0.6 0.8], 'TickLabels',{'0.4','0.6','0.8'}
annotation(gcf,'textbox',[0.91,0.07,0.056,0.065],'String','\xi', 'Fontsize', 50,...
'EdgeColor', 'none', 'BackgroundColor', 'none');

%Add markers of the defects
%annotation(gcf,'doublearrow',[0.488 0.488],[0.552 0.435],'LineWidth',9,'HeadSize',25); %RRJFuzPanel Nadrez
%annotation(gcf,'arrow',[0.478 0.478],[0.200 0.120],'LineWidth',9,'HeadSize',25); %RRJFuzPanel CrackStr1
%annotation(gcf,'arrow',[0.472 0.472],[0.835 0.925],'LineWidth',9,'HeadSize',25); %RRJFuzPanel CrackStr5
%annotation(gcf,'arrow',[0.296 0.296],[0.202 0.282],'LineWidth',9,'HeadSize',25); %RRJFuzPanel CrackStr2

annotation(gcf,'arrow',[0.465 0.465],[0.81 0.92],'LineWidth',9,'HeadSize',25); %RRJRib CrackT5
annotation(gcf,'arrow',[0.615 0.615],[0.25,0.14],'LineWidth',9,'HeadSize',25); %RRJRib CrackT8

Pushbutton = uicontrol('Style', 'pushbutton',... %Create popupmenu
    'String', 'Save figure',...
    'Position', [485 7 70 20],...
    'Callback', @SaveFigure, 'Parent', Fig, 'units', 'normalized');
Screen_size = get(0, 'ScreenSize'); %Get screen size
Fig.Position = [0 0 Screen_size(3) Screen_size(4)];
guidata(Fig, {OutputFileName Pushbutton}); %Transfering local variables to callback function
InverseContour(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), FillContourSign); %Inverse contour filling
plot(Coord.External(:, AbsCoordActionNum(1)), Coord.External(:, AbsCoordActionNum(2)), 'LineWidth', 2,'Color','r') %Plot external contour
%if ~isempty(ChannelsName)
%   CreateContourLabels(Coord.Base(:, AbsCoordActionNum(1)), Coord.Base(:, AbsCoordActionNum(2)), ChannelsName); %Create lables for points 
%end
ax = gca; ax.Box = 1; %Correct axes
            
end

