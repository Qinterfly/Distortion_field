function InverseContour(xExt, yExt, Sign)
%Inverse contour area (white fill)

% Change sign of rotation
if sum(yExt < 0) > sum(yExt > 0)
    Sign = -Sign;
end
BoundExt = [min(xExt), min(yExt), max(xExt), max(yExt)]; %Boundary condtions polyarea
%Left-right fill
switch Sign
    case 1
        for i=1:length(xExt) - 1
            if yExt(i+1) > yExt(i) %Increase
                TempContX = [xExt(i:i + 1); BoundExt(3); BoundExt(3)];
                TempContY = [yExt(i:i + 1); yExt(i + 1); yExt(i)];
                fill(TempContX, TempContY, 'w', 'LineStyle', 'none');
            end
            if yExt(i+1) < yExt(i) %Decrease
                TempContX = [xExt(i:i + 1); BoundExt(1); BoundExt(1)];
                TempContY = [yExt(i:i + 1); yExt(i + 1); yExt(i)];
                fill(TempContX, TempContY, 'w', 'LineStyle', 'none');
            end
        end
        
    case -1
        for i=1:length(xExt) - 1
            if yExt(i+1) < yExt(i) %Increase
                TempContX = [xExt(i:i + 1); BoundExt(3); BoundExt(3)];
                TempContY = [yExt(i:i + 1); yExt(i + 1); yExt(i)];
                fill(TempContX, TempContY, 'w', 'LineStyle', 'none');
            end
            if yExt(i+1) > yExt(i) %Decrease
                TempContX = [xExt(i:i + 1); BoundExt(1); BoundExt(1)];
                TempContY = [yExt(i:i + 1); yExt(i + 1); yExt(i)];
                fill(TempContX,TempContY, 'w', 'LineStyle', 'none');
            end
        end
end

