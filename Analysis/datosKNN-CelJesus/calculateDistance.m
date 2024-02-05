function [distance ] = calculateDistance( position1, position2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4];
y = [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3];

delta_x = x(position1) - x(position2);
delta_y = y(position1) - y(position2);

distance = sqrt( delta_x*delta_x + delta_y*delta_y);
end

