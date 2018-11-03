function Fig = PlotLissage(SignalChInt, SignalFourierPhaseShift, ChannelsName, Channel)
% Plot lissage figure

Fig = figure; % Create a graphic window
guidata(Fig, {SignalChInt SignalFourierPhaseShift}); % Transfering local variables to callback function
Popup = uicontrol('Style', 'popup',... % Create popupmenu
    'String', ChannelsName,...
    'Callback', @SelectChannel, 'Parent', Fig, 'units', 'normalized');
Popup.Position = [0.78, 0.92, 0.2, 0.06];
%Display of Lissage figure for the first channel
plot(SignalFourierPhaseShift(:, Channel), SignalChInt(:, Channel)); %Plotting of the graphic of twists for selected channel
grid on; % Mesh display
title(['Lissage figure for channel #' num2str(Channel)]); % Title of graphic
xlabel({'The first harmonic of the acceleration','of the analyzed sensor, m/s^2'}); % Names of axes
ylabel('Input time signal for selected channel, m/s^2'); % Names of axes
clear i j k Screen_size MaxDistortion; % Delete the intermediate variables

end

