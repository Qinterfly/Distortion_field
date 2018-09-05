function SelectChannel(hObject, eventdata, handles)

Data = guidata(gcbo); %Read transfering data from main figure
SignalChInt = Data{1}; SignalFourierPhaseShift = Data{2}; %Local variables from main figure
index_selected = get(hObject, 'Value'); %Number of selected channel
Channel = index_selected;
plot(SignalFourierPhaseShift(:, Channel), SignalChInt(:, Channel)); %Plotting of the graphic of twists for selected channel
grid on; %Mesh display
title(['Lissage figure for channel #' num2str(Channel)]); %Title of graphic
xlabel({'The first harmonic of the acceleration','of the analyzed sensor, m/s^2'}); %Names of axes
ylabel('Input time signal for selected channel, m/s^2'); %Names of axes

end