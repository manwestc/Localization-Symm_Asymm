function [ ranges ] = calculateDiscreteRange( rssiArray, nPartitions )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ranges = [];
rssiArray2 = sort(unique(rssiArray)*-1);
lastInd = size(rssiArray2,2);

sz = rssiArray2(lastInd) - rssiArray2(1) + 1;
width = sz/nPartitions;
left = rssiArray2(1);
right = left+width;

for it = 1:nPartitions
    ranges = [ ranges ; [left right] ];
    left = right;
    right = left+width;
end

ranges(nPartitions, 2) = rssiArray2(lastInd);
end

