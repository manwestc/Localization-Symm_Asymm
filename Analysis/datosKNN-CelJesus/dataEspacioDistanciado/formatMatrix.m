function [ beacons ] = formatMatrix( matrix, discretePartitions )
% Returns a vector with the average values of beacons detected
% and filled with default values for undetected beacons
    beacons = [];
    %disp(matrix);
    %grouping by time
    values = unique(matrix(:,2));
    
    for it = 1:size(values,1)
        %taking out the 'one second' matrix
        tmpMatrix = matrix(matrix(:,2)==values(it),:);
        tmpBeacon = [];
        
        %dicretize values (from -75 to -120) with 5 numbers
        
        for beaconNum = 7:11 %REGRESAR ESTA LINEA PARA EJECUCION NORMAL
        %for beaconNum =[7,8,10,11] %ESTA LINEA PARA EXCLUIR BEACON
            tmpMatrixBeacon = tmpMatrix(tmpMatrix(:,4)==beaconNum,:);
            if size(tmpMatrixBeacon,1)==0
                tmpBeacon = [tmpBeacon -120 ]; 
                %tmpBeacon = [tmpBeacon discretizeRSSI(-120, discretePartitions)];
            else
                tmpBeacon = [tmpBeacon mean(tmpMatrixBeacon(:,3))];
                %tmpBeacon = [tmpBeacon filterRSSI(tmpMatrixBeacon(:,3))];
                %tmpBeacon = [tmpBeacon discretizeRSSI(mean(tmpMatrixBeacon(:,3)),discretePartitions)];
            end
        end
        
        beacons = [beacons; tmpBeacon];
    end
end

