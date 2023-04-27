function [SubX, SubY] = ImageDivide(X, Y, BatchSize, Offset)
if (~exist('Offset','var'))
   Offset = [0, 0];
end
[Row, Col, XBands] = size(X);
RowStep = BatchSize(1);
ColStep = BatchSize(2);

NumRow = fix((Row - Offset(1)) / RowStep);
NumCol = fix((Col - Offset(2)) / ColStep);


RowSize = RowStep * ones(1, NumRow);
ColSize = ColStep * ones(1, NumCol);

RowEdge = Row - (NumRow * RowStep + Offset(1));
ColEdge = Col - (NumCol * ColStep + Offset(2));


RowSize = Integrate(RowEdge, RowStep, RowSize);
ColSize = Integrate(ColEdge, ColStep, ColSize);

if Offset(1) == 0 && Offset(2) ~= 0
    ColSize = [Offset(2), ColSize];
elseif Offset(2) == 0 && Offset(1) ~= 0
    RowSize = [Offset(1), RowSize];
elseif Offset(2) ~= 0 && Offset(1) ~= 0
    ColSize = [Offset(2), ColSize];
    RowSize = [Offset(1), RowSize];
end
 
SubX = mat2cell(X, RowSize, ColSize, [XBands]);
SubY = mat2cell(Y, RowSize, ColSize);
end


function [Size] = Integrate(Edge, Step, Size)
if Edge < Step
    Size(end) = Step + Edge;
else
    Size = [Size, Edge];
end
end