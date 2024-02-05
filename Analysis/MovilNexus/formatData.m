function [ label,rssi ] = formatData( datos )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

rssi = [];
label = [];
[x,y] = size(datos);
numberBeacons = 5;
numberSampleRSSI = 1;
vectorLen = numberBeacons*numberSampleRSSI;

for i = 1:x
    y2 = 0 ;
    for j = 3:vectorLen:y
        if(datos(i,j)==0)
            y2 = j;
            break;
        end
    end
    for j = 3:vectorLen:y2
        if datos(i,j)==0 || datos(i,j+vectorLen)==0
            break;
        else
            val = datos(i,1);
            label = [label; val ];
            ini = j;
            fin = vectorLen+j-1;
            tmpRow = datos(i,ini:fin);
            rssi = [rssi; tmpRow ];
        end
    end
end

end

