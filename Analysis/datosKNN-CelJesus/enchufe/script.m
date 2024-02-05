%% Import training data from text file.
% Read the csv file
K = 7;
limit = 1;
label_in = [];
rssi_in = [];
matrixCSV = [];
nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/enchufe/data/toma1/test';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/enchufe/data/toma3RaspberryProcesado/test';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/raspberry/test';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/celManuel0x04/test';
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/test'
for it=1:1
    filename = strcat(prefix,int2str(it),'.csv');
    %matrixCSV = [matrixCSV ; csvread(filename,3,1)];
    %matrixCSV = formatData(csvread(filename,2,1), [1 2 3 4 5]);
    %size(matrixCSV)
    matrixCSV = csvread(filename,2,1);
    [tmpLabels, tmpRssi] = formatData(matrixCSV, selectedBeacons);
    label_in = [label_in ; tmpLabels];
    rssi_in = [rssi_in ; tmpRssi];
end

clear tmpLabels tmpRssi matrixCSV

%% Choose range values if need to discretize
%discretePartitions = calculateDiscreteRange(matrixCSV(:,3)', nroPartitions);

%% Choose training
%[trainingRssi, trainingLabels] =  selectMatrixLabel(matrixCSV, discretePartitions);
trainingRssi = rssi_in;
trainingLabels = label_in;

validationLabel = [];
validationRssi = [];
%% Choose validation data
for it=2:2
    filename = strcat(prefix,int2str(it),'.csv');
    
    matrixCSV = csvread(filename,2,1);
    [tmpLabels, tmpRssi] = formatData(matrixCSV, selectedBeacons);
    validationLabel = [validationLabel ; tmpLabels];
    validationRssi = [validationRssi ; tmpRssi];
end


%% KNN Search
[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance] = ...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);


%% Final results after running 'reps' times the simulation process
tabValues = tabulate(completeFinalResultsDistance);


%% Plotting error graphics
errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12); completeErrorMeasure(13:15)];
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12)];


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