function Coord = GrahamScanAlgorithm(Coord)
%Find convex hull

PointNumb = size(Coord,1);
IndCoord(:,1) = 1:PointNumb; %Vector point indices
[~,TempMaxInd] = max(Coord(:,1)); %Find point with minimal X coordinate
IndCoord([TempMaxInd,1]) = IndCoord([1,TempMaxInd]); %Swap indicies with first element
    %Sort by polar angle
for i = 3:PointNumb
   j = i;
   while j >= 3 && CrossProductAngle(Coord(IndCoord(1),:),Coord(IndCoord(j-1),:),Coord(IndCoord(j),:)) < 0 %Left rotation
      IndCoord([j, j-1]) = IndCoord([j-1, j]); 
      j = j - 1; 
   end  
end
    %Correct polygon (del right rotation)
Stack = IndCoord(1:2);
for i = 3:PointNumb
    while CrossProductAngle(Coord(Stack(end-1),:),Coord(Stack(end),:),Coord(IndCoord(i),:)) < 0
       Stack(end) = []; 
    end
    Stack = [Stack; IndCoord(i)];
end

Coord = Coord(Stack,:); %Result coordinat
end

