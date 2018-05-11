function AngleValue = CrossProductAngle(APoint, BPoint, CPoint)
%Calculate direction of rotation

AngleValue = (BPoint(1)-APoint(1))*(CPoint(2)-BPoint(2))-(BPoint(2)-APoint(2))*(CPoint(1)-BPoint(1));

end

