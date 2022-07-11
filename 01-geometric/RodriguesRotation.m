function [ v_rot ] = RodriguesRotation( v, k, theta )
% Rodrigues' Rotation formula (https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula)
% Gives the rotated vector v_rot of the vector v around the vector k by an angle of theta
%
% v_rot: Rotated vector
% v:     Vector to be rotated
% k:     Ratation axis
% theta: Angle of rotation [degrees]

v_rot = v*cosd(theta) + cross(k,v)*sind(theta) + k*dot(k,v)*(1-cosd(theta));

end

