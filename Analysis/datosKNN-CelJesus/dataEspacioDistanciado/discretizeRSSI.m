function [ dval ] = discretizeRSSI( val, discretePartitions )
%Discretize rssi values

[nPartitions, intervals] = size(discretePartitions);
val = val * -1;
dval = -1;

for it = 1:nPartitions
    if val>=discretePartitions(it,1) && val<discretePartitions(it,2)
        dval = it;
    end
    %disp(discretePartitions(it,1));
end

%if dval == -1
%    dval = nPartitions + 1;
%end

end

