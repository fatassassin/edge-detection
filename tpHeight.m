function orthDist = tpHeight(p1,p2,p3)
%tpHeight calculates the orthogonal distance from one point p3 to the line
%determined by the other two points p1 and p2.
%   The input parameters are the coordinates vectors of the three points.

edge3=norm(p1-p2);
edge1=norm(p2-p3);
edge2=norm(p1-p3);
orthDist=sqrt(((edge2+edge3)^2-edge1^2)*(edge1^2-(edge2-edge3)^2))/(2*edge3);