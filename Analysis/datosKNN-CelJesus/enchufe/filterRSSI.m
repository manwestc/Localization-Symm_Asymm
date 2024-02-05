function [ avgRssi ] = filterRSSI( rssi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sortedRssi = sort(rssi);
width = floor(size(sortedRssi,1)*0.3);
startIndex = 1+width;
endIndex = size(sortedRssi,1)-width;
avgRssi = mean(sortedRssi(startIndex:endIndex));
end

