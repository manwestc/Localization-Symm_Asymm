function [distance ] = calculateDistance( position1, position2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = [0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5];
y = [0.5, 0.5, 0.5, 2, 2, 2, 3.5, 3.5, 3.5, 5, 5, 5, 6.5, 6.5, 6.5];

delta_x = x(position1) - x(position2);
delta_y = y(position1) - y(position2);

distance = sqrt( delta_x*delta_x + delta_y*delta_y);
end

