function [SpatialNorm] = GetSpatialContext(Label, step)

[Pos, Lab, MinPos, MinDisLab] = GetPosLab(Label, step);
% 
[Area, Boundary, ShallBoundary,ShallArea] = GetAccomCoef(Pos, Lab, MinDisLab);
% 
MaxArea = 8 * (step+1)*2 * (step+1)*2 /2;

AreaNorm = Area/MaxArea;
%AreaNorm = Area;
BoundaryNorm = Boundary;
ShallNorm = ShallBoundary./Boundary;
ShallAreaNorm = ShallArea./Area;
MinPosNorm = MinPos/((step+1)*2);

[Row, Col] = size(Label);
SpatialNorm = zeros(Row, Col, 6);
%coordinate
SpatialNorm(:,:, 1) = MinPosNorm;
%min distance label
SpatialNorm(:,:, 2) = MinDisLab;
%area
SpatialNorm(:,:, 5) = AreaNorm;
SpatialNorm(:,:, 6) = ShallAreaNorm;
%boundary
SpatialNorm(:,:, 4) = ShallNorm;
SpatialNorm(:,:, 3) = BoundaryNorm;
end