%% Import data from text file.

% Read the csv file - *training*
K = 5;

label_in = [];
rssi_in = [];
matrixCSV = [];
tmpLabels = [];
tmpRssi = [];

nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];
prefix = '/home/jeslev/Dropbox/Bluetooth/Medidas nuevas/Beacons/Movil/Tx_0x04/Tx04_';

for it=1:2
    filename = strcat(prefix,int2str(it),'.csv');
    
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


% Read the csv file - *validation*

%% Choose validation data
for it=3:3
    filename = strcat(prefix,int2str(it),'.csv');
    
    matrixCSV = csvread(filename,2,1);
    [tmpLabels, tmpRssi] = formatData(matrixCSV, selectedBeacons);
    validationLabel = [validationLabel ; tmpLabels];
    validationRssi = [validationRssi ; tmpRssi];
end


%% KNN Search
[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance] = ...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);


tabValues = tabulate(completeFinalResultsDistance);


%% Plotting error graphics
%Drawing matrix map for zone 4
errorMatrixHeat = zeros(16,10);
itcnt = 1;
for it1 = 1:5
    for it2 = 1:3
        posRow  = (it1-1)*3+2;
        posCol = (it2-1)*3+2;
        errorMatrixHeat(posRow,posCol) = completeErrorMeasure(itcnt);
        errorMatrixHeat(posRow+1,posCol) = completeErrorMeasure(itcnt);
        errorMatrixHeat(posRow,posCol+1) = completeErrorMeasure(itcnt);
        errorMatrixHeat(posRow+1,posCol+1) = completeErrorMeasure(itcnt);
        itcnt = itcnt+1;
    end
end
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12); completeErrorMeasure(13:15)];
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12)];

imagesc(errorMatrixHeat);
colormap(winter);
caxis([0,5]);
colorbar;
title('% error por m2')

disp(completeErrorMeasure);
disp(mean(completeErrorMeasure));
%disp(mean(completeErrorMeasure(1:12)));


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