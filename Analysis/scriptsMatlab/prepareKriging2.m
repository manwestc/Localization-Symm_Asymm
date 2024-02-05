%% Import data from text file.
% Read the csv file
%% NEW!!! Get mean rssi value for each zone

beacon = 5; % 7 8 9 10 11

fileID = fopen('../kriging/raspberri/0x01','w');
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x06/test';
res = [];
for it=1:15
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,0,0);
    m = mean(matrixCSV(:,beacon+1));
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