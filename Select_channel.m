function Select_channel(hObject, eventdata, handles)
Data = guidata(gcbo); %Read transfering data from main figure
Signal_ch_int = Data{1}; Signal_fourier_PhaseShift = Data{2}; %Local variables from main figure
index_selected = get(hObject,'Value'); %Number of selected channel
Channel = index_selected; 
plot(Signal_fourier_PhaseShift(:,Channel), Signal_ch_int(:,Channel)); %Plotting of the graphic of twists for selected channel 
grid on; %Mesh display
title(['Lissage figure for channel #' num2str(Channel)]); %Title of graphic
xlabel({'The first harmonic of the acceleration','of the analyzed sensor, m/s^2'}); %Names of axes 
ylabel('Input time signal for selected channel, m/s^2'); %Names of axes    
end