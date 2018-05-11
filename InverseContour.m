function InverseContour(xExt,yExt)
%Inverse contour area (white fill)

BoundExt = [min(xExt), min(yExt), max(xExt), max(yExt)]; %Boundary condtions polyarea
%Left-right fill
for i=1:length(xExt)-1
    if yExt(i+1) > yExt(i) %Increase
        TempContX = [xExt(i:i+1);BoundExt(3);BoundExt(3)];
        TempContY = [yExt(i:i+1);yExt(i+1);yExt(i)];
        fill(TempContX,TempContY,'w','LineStyle','none');
    end
    if yExt(i+1) < yExt(i) %Decrease
        TempContX = [xExt(i:i+1);BoundExt(1);BoundExt(1)];
        TempContY = [yExt(i:i+1);yExt(i+1);yExt(i)];
        fill(TempContX,TempContY,'w','LineStyle','none');
    end
end

end

