%% Hace uso de combinaciones (hibridos) de potencias

%% Importa datos para el entrenamiento , de capturas previamente hechas
% Read the csv file
K = 5;
limit = 1;
trainingLabels= [];
trainingRssi = [];
matrixCSV = [];
matrixCSV2 = [];
matrixCSV3 = [];
nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];

%% preparando archivos de entrenamiento
% Beacons 1,2,3,4 de potencia 0x04 y/o beacon 1 de potencia 6

%beacon 1 potencia 6
%beacon 2,3,4 potencia 4
% Beacons 5 de potencia 1


% 3ra combinacion beacon 1 y 3 pot 6, beacon 2 y 4 pot 4, beacon 5 pot 1
% 4ta combinacion pot 5,5,3,5,5
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x04/train';
prefix2 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/train';
prefix3 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x02/train';
prefix4 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/train';
prefix5 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/train';
for it=1:15
    %filename = strcat(prefix,int2str(it),'.csv');
    %matrixCSV = csvread(filename,0,0);
    %filename = strcat(prefix2,int2str(it),'.csv');
    %matrixCSV2 = csvread(filename,0,0);
    %filename = strcat(prefix3,int2str(it),'.csv');
    %matrixCSV3 = csvread(filename,0,0);
    %tam = min(size(matrixCSV,1),min(size(matrixCSV2,1),size(matrixCSV3,1)) );
    %matrixCSV = [matrixCSV(1:tam,1)';matrixCSV2(1:tam,2)'; matrixCSV2(1:tam,3)';
    %    matrixCSV2(1:tam,4)'; matrixCSV2(1:tam,5)';matrixCSV3(1:tam,6)']'
    
    matrix1 = []; matrix2 = []; matrix3 = []; matrix4 = []; matrix5 = [];
    filename = strcat(prefix,int2str(it),'.csv');
    matrix1 = csvread(filename,0,0);
    filename = strcat(prefix2,int2str(it),'.csv');
    matrix2 = csvread(filename,0,0);
    filename = strcat(prefix3,int2str(it),'.csv');
    matrix3 = csvread(filename,0,0);
    filename = strcat(prefix4,int2str(it),'.csv');
    matrix4 = csvread(filename,0,0);
    filename = strcat(prefix5,int2str(it),'.csv');
    matrix5 = csvread(filename,0,0);
    
    %filename = strcat(prefix4,int2str(it),'.csv');
    %matrixCSV = csvread(filename,0,0);
    %filename = strcat(prefix5,int2str(it),'.csv');
    %matrixCSV2 = csvread(filename,0,0);
    
    
    tam = min([size(matrix1,1),size(matrix2,1),size(matrix3,1),...
                    size(matrix4,1),size(matrix5,1)]);
    matrixCSV = [matrix1(1:tam,1)';matrix1(1:tam,2)'; matrix2(1:tam,3)';
        matrix3(1:tam,4)';
        matrix4(1:tam,5)';matrix5(1:tam,6)']';
    
    trainingLabels = [trainingLabels; matrixCSV(:,1)];
    trainingRssi = [trainingRssi; matrixCSV(:,2:end)];
    %tam = min(size(matrixCSV,1),size(matrixCSV2,1) );
    %matrixCSV = [matrixCSV(1:tam,1)';matrixCSV(1:tam,2)'; matrixCSV(1:tam,3)';
    %    matrixCSV2(1:tam,4)'; matrixCSV(1:tam,5)';matrixCSV(1:tam,6)']'
    %trainingLabels = [trainingLabels; matrixCSV(:,1)];
    %trainingRssi = [trainingRssi; matrixCSV(:,2:end)];
end
clear tmpLabels tmpRssi matrixCSV


%return
%% Choose range values if need to discretize
%discretePartitions = calculateDiscreteRange(matrixCSV(:,3)', nroPartitions);

%% Choose training
%[trainingRssi, trainingLabels] =  selectMatrixLabel(matrixCSV, discretePartitions);


%% Inicia el algoritmo con la data entrenada para determinar la ruta

validationLabel = [];
validationRssi = [];


%% Procesa archivos de validacion
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x04/valid'
prefix2 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/valid'
prefix3 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x02/valid'
prefix4 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/valid';
prefix5 = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/valid';
for it=1:15
    %filename = strcat(prefix,int2str(it),'.csv');
    %matrixCSV = csvread(filename,0,0);
    %filename = strcat(prefix2,int2str(it),'.csv');
    %matrixCSV2 = csvread(filename,0,0);
    %filename = strcat(prefix3,int2str(it),'.csv');
    %matrixCSV3 = csvread(filename,0,0);
    %tam = min(size(matrixCSV,1),min(size(matrixCSV2,1),size(matrixCSV3,1)) );
    %matrixCSV = [matrixCSV(1:tam,1)';matrixCSV2(1:tam,2)'; matrixCSV2(1:tam,3)';
    %    matrixCSV2(1:tam,4)'; matrixCSV2(1:tam,5)';matrixCSV3(1:tam,6)']'
    
    matrix1 = []; matrix2 = []; matrix3 = []; matrix4 = []; matrix5 = [];
    filename = strcat(prefix,int2str(it),'.csv');
    matrix1 = csvread(filename,0,0);
    filename = strcat(prefix2,int2str(it),'.csv');
    matrix2 = csvread(filename,0,0);
    filename = strcat(prefix3,int2str(it),'.csv');
    matrix3 = csvread(filename,0,0);
    filename = strcat(prefix4,int2str(it),'.csv');
    matrix4 = csvread(filename,0,0);
    filename = strcat(prefix5,int2str(it),'.csv');
    matrix5 = csvread(filename,0,0);
    
    %filename = strcat(prefix4,int2str(it),'.csv');
    %matrixCSV = csvread(filename,0,0);
    %filename = strcat(prefix5,int2str(it),'.csv');
    %matrixCSV2 = csvread(filename,0,0);
    %tam = min(size(matrixCSV,1),size(matrixCSV2,1) );
    %matrixCSV = [matrixCSV(1:tam,1)';matrixCSV(1:tam,2)'; matrixCSV(1:tam,3)';
    %    matrixCSV2(1:tam,4)'; matrixCSV(1:tam,5)';matrixCSV(1:tam,6)']'
    
    %validationLabel = [validationLabel ; matrixCSV(:,1)];
    %validationRssi = [validationRssi; matrixCSV(:,2:end)];
    tam = min([size(matrix1,1),size(matrix2,1),size(matrix3,1),...
                    size(matrix4,1),size(matrix5,1)]);
    matrixCSV = [matrix1(1:tam,1)';matrix1(1:tam,2)'; matrix2(1:tam,3)';
    matrix3(1:tam,4)'; 
    matrix4(1:tam,5)';matrix5(1:tam,6)']';

    validationLabel = [validationLabel; matrixCSV(:,1)];
    validationRssi = [validationRssi; matrixCSV(:,2:end)];
end


%% Inicia algoritmo - KNN Search
%[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance,...
%    correctPosFreq, totalPosFreq, confussion] = ...
%    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);

%% SVM Search
[completeErrorMeasure, completeFinalResultsDistance,...
        correctPosFreq, totalPosFreq] = ...
        svmFunc( trainingRssi, validationRssi,trainingLabels, validationLabel, 1);


%% Final results after running 'reps' times the simulation process
tabValues = tabulate(completeFinalResultsDistance);


%% Plotting error graphics
errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12); completeErrorMeasure(13:15)];
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12)];
%errorMatrixHeat = [completeErrorMeasure(13);completeErrorMeasure(14);completeErrorMeasure(15);
%    completeErrorMeasure(10);completeErrorMeasure(11);completeErrorMeasure(12);completeErrorMeasure(7);completeErrorMeasure(8);completeErrorMeasure(9);
%    completeErrorMeasure(4);completeErrorMeasure(5);completeErrorMeasure(6); completeErrorMeasure(1);completeErrorMeasure(2);completeErrorMeasure(3)];
%errorMatrixHeat

clims = [0 3.5];
imagesc(errorMatrixHeat);
colormap(autumn);
caxis([0,3])
colorbar;
title('% error por m2')

disp(completeErrorMeasure);
disp(mean(completeErrorMeasure));


%% Plotting data
figure
stem(tabValues(:,1), tabValues(:,3), 'filled')
xlim([-0.5,3.5])
title('Analisis de predicción RSSI usando k-NN (moda)')
xlabel('error (m²) ')
ylabel('frecuencia (%)')

figure
cdfplot(completeFinalResultsDistance)
title('Frecuencia de error acumulando, utilizando moda')

%% Confussion Matrix
fprintf('Matriz de confusión\n');
disp(confussionMatrix);

%% Average Position Plots
% calculating distance
 
 
tabValues = tabulate(averageDistance);

%stem(tabValues(:,1), tabValues(:,3), 'filled')
%xlim([-0.5,3.5])
%title('Error usando distancia ponderada')
%xlabel('error (m²) ')
%ylabel('frecuencia (%)')
 
errorVals = [];
for it2 = 0.5:0.5:5
    errorVals = [errorVals, sum(tabValues(:,1)<it2 )];
end
figure
cdfplot(averageDistance)
title('Frecuencia de error acumulando, utilizando distancia ponderada')
%disp(errorVals)

% mean error
fprintf('Error medio: %f - moda , %f - distancia ponderada\n',...
mean(completeFinalResultsDistance),mean(averageDistance) );

disp(errorMatrixHeat);
return
%% Accuracy
%correctPositionFrequencies
% totalPositionFrequencies
  matrixNum = [correctPosFreq(1:3);correctPosFreq(4:6); ...
    correctPosFreq(7:9);correctPosFreq(10:12); correctPosFreq(13:15)];
  matrixDen =[totalPosFreq(1:3);totalPosFreq(4:6); ...
    totalPosFreq(7:9);totalPosFreq(10:12); totalPosFreq(13:15)];

% 
 heatMatrix = (matrixNum ./ matrixDen)*100.0
 figure

 imagesc(heatMatrix);
 colormap(autumn);
caxis([0,100])
colorbar
set(gca,'YDir','normal')
 title('Distribución de acierto')

 

%% Granularidad (sector 1,4 ; 3,6; 10,13; 12,15
valores = zeros(1,15);
sec = confussion(1,1)+confussion(1,4)+confussion(4,1)+confussion(4,4);
totsec = sum(confussion(1,:))+sum(confussion(4,:));
valores(1)  = (sec*100.0)/(1.0*totsec);
valores(4)  = valores(1);

sec = confussion(3,3)+confussion(3,6)+confussion(6,3)+confussion(6,6);
totsec = sum(confussion(3,:))+sum(confussion(6,:));
valores(3)  = (sec*100.0)/(1.0*totsec);
valores(6)  = valores(3);

sec = confussion(10,10)+confussion(10,13)+confussion(13,10)+confussion(13,13);
totsec = sum(confussion(10,:))+sum(confussion(13,:));
valores(10)  = (sec*100.0)/(1.0*totsec);
valores(13)  = valores(10);

sec = confussion(12,12)+confussion(12,15)+confussion(15,12)+confussion(15,15);
totsec = sum(confussion(12,:))+sum(confussion(15,:));
valores(12)  = (sec*100.0)/(1.0*totsec);
valores(15)  = valores(12);

for x = [2,5,7,8,9,11,14]
    sec = confussion(x,x);
    totsec = sum(confussion(x,:));
    valores(x) = (sec*100.0)/(totsec);
end

valores = [valores(1:3); valores(4:6); valores(7:9); valores(10:12); valores(13:15)];
mapaCalor(valores)
valores