function SaveFigure(hObject, eventdata, dirOld, dirNew)
%Add to path Export_fig before saving

try
    if ~isempty(eventdata) %Program callback check
        figHandle = gcbf; %Set handles of current figure
    else
        figHandle = hObject; % +Example call: Save_figure(gcf, [])+
    end
    Data = guidata(hObject); %Read transfering data from main figure
    ScreenSize = get(0, 'ScreenSize'); %Get screen size
    FileName = Data{1}; %Local variables from main figure
    FileName = strrep(FileName, dirOld, ''); % Delete old path from filename
    FileName = strcat(dirNew, FileName); % Add new path to filename
    if ~isdir(dirNew) % Check existence of output directory
        mkdir(dirNew); 
    end
    PushbuttonHandle = Data{2}; %Ui handle from main figure
    OrigSize = get(figHandle, 'Position'); %Grab original position of window
    if OrigSize ~= [0 0 ScreenSize(3) ScreenSize(4)] %Check fullscreen mode
        set(figHandle, 'Position', [0 0 ScreenSize(3) ScreenSize(4)]); %Set to screen size
    end
    figHandle.PaperPositionMode = 'auto'; %Set the size of saving figure
    PushbuttonHandle.Visible = 'off'; %Hide ui pushbutton
    export_fig(FileName,'-dpng') %Save figure
    % print(fig,FileName,'-dpng','-r0','-noui'); %Save figure
    set(gcbf,'Position', OrigSize); %Set back to original dimensions
    PushbuttonHandle.Visible = 'on'; %Show ui pushbutton
    disp(['Saving file completed: "', FileName, '"']); %Show message
catch ME
    msgbox(['The file can not be saved:', ME], 'Error', 'error'); %Show warning
end

end