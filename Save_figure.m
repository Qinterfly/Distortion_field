function Save_figure(hObject, eventdata, handles)
%Add to path Export_fig before saving 
try
Data = guidata(gcbo); %Read transfering data from main figure
Screen_size = get(0, 'ScreenSize'); %Get screen size
FileName = Data{1}; %Local variables from main figure
Param = Data{2}; %Mode identifer from main figure
Pushbutton_handle = Data{3}; %Ui handle from main figure
OrigSize = get(gcbf, 'Position'); %Grab original position of window
if OrigSize ~= [0 0 Screen_size(3) Screen_size(4)] %Check fullscreen mode
set(gcbf, 'Position', [0 0 Screen_size(3) Screen_size(4)]); %Set to screen size
end;
fig = gcbf; %Set handles of current figure
fig.PaperPositionMode = 'auto'; %Set the size of saving figure
Pushbutton_handle.Visible = 'off'; %Hide ui pushbutton
export_fig(strcat(FileName,Param),'-dpng') %Save figure
%print(fig,strcat(FileName,Param),'-dpng','-r0','-noui'); %Save figure 
set(gcbf,'Position', OrigSize); %Set back to original dimensions
Pushbutton_handle.Visible = 'on'; %Show ui pushbutton
disp('Saving file completed'); %Show message
catch
msgbox('The file can not be saved', 'Error', 'error'); %Show warning
end