function [Area, Boundary, ShallBoundary, ShallArea] = GetAccomCoef(Pos, Lab, MinDisLab)
[Row, Col, B] = size(Pos);

Area = zeros(Row, Col);
Boundary = zeros(Row, Col);
ShallBoundary = zeros(Row, Col);
ShallArea = zeros(Row, Col);
for i=1:Row
    for j=1:Col
        PosCur = FindPosi([0,0], 1, Pos(i,j, 1));
        PosCur = abs(PosCur);
        CoefCur = IsSameLabel(Lab(i, j, 1), MinDisLab(i, j));
        for k=2:B
            PosNext = FindPosi([0,0], k, Pos(i,j, k));
            PosNext = abs(PosNext);
            Area(i, j) = Area(i, j) + 0.5 * abs(getarea(PosNext, PosCur));
            Boundary(i, j) = Boundary(i, j) + norm(PosNext-PosCur, 2);
            CoefNext = IsSameLabel(Lab(i, j, k), MinDisLab(i, j));
            ShallBoundary(i, j) = ShallBoundary(i, j) +...
                0.5 * (CoefCur+CoefNext) * norm(PosNext-PosCur, 2);             
            ShallArea(i, j) = ShallArea(i, j) + 0.5 *...
                (CoefCur+CoefNext) * 0.5 * abs(getarea(PosNext, PosCur));
            PosCur = PosNext;
            CoefCur = CoefNext;
        end
        
        PosNext = FindPosi([0,0], 1, Pos(i,j, 1));
        PosNext = abs(PosNext);
        Area(i, j) = Area(i, j) + 0.5 * abs(getarea(PosNext, PosCur));
        Boundary(i, j) = Boundary(i, j) + norm(PosNext-PosCur, 2);
        CoefNext = IsSameLabel(Lab(i, j, 1), MinDisLab(i, j));
        ShallBoundary(i, j) = ShallBoundary(i, j) +...
            0.5 * (CoefCur+CoefNext) * norm(PosNext-PosCur, 2); 
        ShallArea(i, j) = ShallArea(i, j) + 0.5 *...
                (CoefCur+CoefNext) * 0.5 * abs(getarea(PosNext, PosCur));
    end
end

end