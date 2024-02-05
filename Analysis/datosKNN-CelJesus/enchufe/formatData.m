function [label,rssi] = formatData(M, beaconsCombination)
%function [label,rssi] = formatData(M)
%Format and clean the values of the csv received
%Returns the labels and rssi list of each fingerprint

%% Formatting 3 data rows
rssi = [];
label = [];
[x,y] = size(M);
numberBeacons = 5;
numberSampleRSSI = 1;
vectorLen = numberBeacons*numberSampleRSSI;

usedBeacons = zeros(1,numberBeacons);
for i = 1:size(beaconsCombination,2)
    usedBeacons(beaconsCombination(i)) = usedBeacons(beaconsCombination(i)) +1;
end

for i = 1:x
    for j = 3:vectorLen:(y-vectorLen)
        if M(i,j)==0 || M(i,j+vectorLen)==0
            break;
        else
            val = M(i,1);
            label = [label; val ];
            tmpRow = [];
            for k = j:vectorLen+j
                it_beacon = mod(k, numberBeacons);
                if it_beacon>0 && usedBeacons(it_beacon)~=0
                    tmpRow = [tmpRow M(i,k)];
                end
            end
            rssi = [rssi; tmpRow ];
        end
    end
end

clearvars x y i j val vectorLen numberBeacons numberSampleRSSI tmpRow;
