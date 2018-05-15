function Save_figure(hObject, eventdata)
%Add to path Export_fig before saving
try
    if ~isempty(eventdata) %Program callback check
        figHandle = gcbf; %Set handles of current figure
    else
        figHandle = hObject; % +Example call: Save_figure(gcf, [])+
    end
    Data = guidata(hObject); %Read transfering data from main figure
    Screen_size = get(0, 'ScreenSize'); %Get screen size
    FileName = Data{1}; %Local variables from main figure
    Pushbutton_handle = Data{2}; %Ui handle from main figure
    OrigSize = get(figHandle, 'Position'); %Grab original position of window
    if OrigSize ~= [0 0 Screen_size(3) Screen_size(4)] %Check fullscreen mode
        set(figHandle, 'Position', [0 0 Screen_size(3) Screen_size(4)]); %Set to screen size
    end
    figHandle.PaperPositionMode = 'auto'; %Set the size of saving figure
    Pushbutton_handle.Visible = 'off'; %Hide ui pushbutton
    export_fig(FileName,'-dpng') %Save figure
    %print(fig,FileName,'-dpng','-r0','-noui'); %Save figure
    set(gcbf,'Position', OrigSize); %Set back to original dimensions
    Pushbutton_handle.Visible = 'on'; %Show ui pushbutton
    disp('Saving file completed'); %Show message
catch
    msgbox('The file can not be saved', 'Error', 'error'); %Show warning
end