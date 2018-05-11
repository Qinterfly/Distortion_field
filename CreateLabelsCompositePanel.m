function CreateLabelsCompositePanel(x, y, Channels_name)

Xmax = max(x); Ymax = max(y); %Finding maximal element of array
Xmin = min(x); Ymin = min(y); %Finding minimal element of array
for i = 1:length(x)
Pos_char = strfind(Channels_name{i},':'); %Find position of ':'
IndSlice =Pos_char(2)+1:Pos_char(3)-1; %Indexes slice
%Showing labels on different positions 
    if x(i) == Xmax %At right edge of plot
        switch y(i) 
            case Ymax
                 text(x(i) - 30 ,y(i) - 40, Channels_name{i}(IndSlice),'FontSize', 15) 
            case Ymin
                text(x(i) - 20 ,y(i) + 18, Channels_name{i}(IndSlice),'FontSize', 15) 
            otherwise
                text(x(i) - 20 ,y(i) + 3, Channels_name{i}(IndSlice),'FontSize', 15)             
        end
    end
    if y(i) == Ymax %At top
        switch x(i) 
            case Xmax %Do nothing
            case Xmin
                text(x(i) + 5, y(i) - 40, Channels_name{i}(IndSlice),'FontSize', 15) 
            otherwise
                text(x(i) - 5, y(i) - 45, Channels_name{i}(IndSlice),'FontSize', 15)             
        end
    end    
    if x(i) == Xmin %At left edge of plot
        switch y(i) 
            case Ymax %Do nothing
            case Ymin
                text(x(i) + 12, y(i) + 20, Channels_name{i}(IndSlice),'FontSize', 15) 
            otherwise
                text(x(i) + 15, y(i) + 25, Channels_name{i}(IndSlice),'FontSize', 15)             
        end
    end   
    if y(i) == Ymin && (Xmin < x(i) && x(i) < Xmax) %At bottom
        text(x(i) - 10 ,y(i) + 45, Channels_name{i}(IndSlice),'FontSize', 15)
    end
    if (x(i) > Xmin && x(i) < Xmax) && (y(i) < Ymax && y(i) > Ymin) %Center points
        text(x(i) - 8 ,y(i) + 40, Channels_name{i}(IndSlice),'FontSize', 15) 
    end
end

end

