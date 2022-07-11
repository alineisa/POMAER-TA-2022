function [ A ] = AreaTriangle3D( v0, v1, v2 )

% Reference: http://geomalgorithms.com/a01-_area.html (Modern Triangles)
V = v1-v0;
W = v2-v1;

A = .5*norm(cross(V,W));



end

