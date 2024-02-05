%% Importa datos para el entrenamiento , de capturas previamente hechas
% Read the csv file
clear all;
K = 5;
limit = 1;
trainingLabels= [];
trainingRssi = [];
matrixCSV = [];
nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];
pot = 'Tx_0x04';

%% preparando archivos de entrenamiento
prefix = strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/',pot,'/train');
for it=1:15
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,0,0);
    trainingLabels = [trainingLabels; matrixCSV(:,1)];
    trainingRssi = [trainingRssi; matrixCSV(:,2:end)];
end
clear tmpLabels tmpRssi matrixCSV


%% Obtener media de RSSI por sector
beacon = 5; % [7 8 9 10 11]
medidas = [];
for it=1:15
    indices = trainingLabels==it;
    medidas = [medidas; [mean(trainingRssi(indices,beacon)), std(trainingRssi(indices,beacon))]];
end
medidas(:,1)
return

%% Choose range values if need to discretize
%discretePartitions = calculateDiscreteRange(matrixCSV(:,3)', nroPartitions);

%% Choose training
%[trainingRssi, trainingLabels] =  selectMatrixLabel(matrixCSV, discretePartitions);


%% Inicia el algoritmo con la data entrenada para determinar la ruta

validationLabel = [];
validationRssi = [];


%% Procesa archivos de validacion
prefix = strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/',pot,'/valid')
%prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/valid';
for it=1:15
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,0,0);
    validationLabel = [validationLabel ; matrixCSV(:,1)];
    validationRssi = [validationRssi; matrixCSV(:,2:end)];
end

%% Inicia algoritmo - KNN Search
[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance,...
    correctPosFreq, totalPosFreq, confussion] = ...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);

%% SVM Search
%[completeErrorMeasure, completeFinalResultsDistance,...
%        correctPosFreq, totalPosFreq] = ...
%        svmFunc( trainingRssi, validationRssi,trainingLabels, validationLabel, 1);


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
tabValues(:,3)
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
for it2 = 0.5:0.6:5
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