function [SpatialNorm] = GetSpatialContext(Label, step)

[Pos, Lab, MinPos, MinDisLab] = GetPosLab(Label, step);
% 
[Area, Boundary, ShallBoundary,ShallArea] = GetAccomCoef(Pos, Lab, MinDisLab);
% 
MaxArea = 8 * (step+1)*2 * (step+1)*2 /2;

AreaNorm = Area/MaxArea;
BoundaryNorm = Boundary;
ShallNorm = ShallBoundary./Boundary;
ShallAreaNorm = ShallArea./Area;
MinPosNorm = MinPos/((step+1)*2);
[Row, Col] = size(Label);
SpatialNorm = zeros(Row, Col, 6);
SpatialNorm(:,:, 1) = MinPosNorm;
SpatialNorm(:,:, 2) = MinDisLab;
SpatialNorm(:,:, 5) = AreaNorm;
SpatialNorm(:,:, 6) = ShallAreaNorm;
SpatialNorm(:,:, 4) = ShallNorm;
SpatialNorm(:,:, 3) = BoundaryNorm;
end