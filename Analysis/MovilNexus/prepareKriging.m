%% Import data from text file.
% Read the csv file
limit = 3;
limit =15;
matrixCSV = [];
fileID = fopen('../CombinacionesResultados/medidas','w');
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/0x07/test'; % limite 1 3
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x06/test'; % limite 1 3
for it=1:limit
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = [matrixCSV ; csvread(filename,1,0)];
    %matrixCSV = csvread(filename,1,0);
end

%% NEW!!! Get mean rssi value for each zone
beacon = 11; % 7 8 9 10 11
% select beacon
%valuesBeacon = matrixCSV(matrixCSV(:,4)==beacon,:);
valuesBeacon = matrixCSV(:,[1, beacon-5]);

%mean by zone
res = [];
for it = 1:15
    %m = mean(valuesBeacon(valuesBeacon(:,2)==it,3));
    m = mean(valuesBeacon(valuesBeacon(:,1)==it,2));
    if isnan(m)
        res = [res; -120];
    else
       res = [ res ; m]; 
    end
end
res

fprintf(fileID,'%6.4f\n',res);
fclose(fileID);

min(res)
max(res)