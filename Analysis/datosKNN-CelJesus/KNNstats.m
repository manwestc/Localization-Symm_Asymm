function [ tabValues ] = KNNstats(selectedBeacons,K)
% Manipulate data to get the graphics and stats of K-NN

%% Import training data from text file.
% Read the csv file
%K = 5;
limit=5;
label_in = [];
rssi_in = [];
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/data5F6/t';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/data6S3F6/t';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/data7S3EST/t';
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/datosKNN-CelJesus/data4/t';
for it=1:limit
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,3,1);
    [tmpLabels, tmpRssi] = formatData(matrixCSV, selectedBeacons);
    label_in = [label_in ; tmpLabels];
    rssi_in = [rssi_in ; tmpRssi];
end

%% Clear temporary variables
clearvars filename M tmpLabels tmpRssi matrixCSV it limit;


%% K-NN  SIMULATION PROCESS
reps = 50;
completeFinalResultsDistance = [];
completeErrorMeasure = zeros(1,12);
completeAverageDistance = [];
completeCorrectFreq = zeros(1,12);
completeTotalFreq = zeros(1,12);
completeErrorWEMeasure = zeros(1,12);
trainSize = 0;
trainValidate = 0;
for rep = 1:reps
    %% Choose training - validation data
    [trainingRssi, trainingLabels, validationRssi, validationLabel] = ...
        getRandomTrainingData(label_in,rssi_in);
    
    trainSize = size(trainingRssi,1);
    trainValidate = size(validationRssi,1);
    %% KNN Search
    [errorMeasure, finalResultsDistance, averageDistance, correctPosFreq, totalPosFreq, errorWE] = ...
        KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);
    
    completeErrorMeasure = completeErrorMeasure + errorMeasure; 
    completeErrorWEMeasure = completeErrorWEMeasure + errorWE; 
    
    completeFinalResultsDistance = [completeFinalResultsDistance finalResultsDistance];
    %size(completeFinalResultsDistance)
    
    completeAverageDistance = [completeAverageDistance averageDistance];

    completeCorrectFreq = completeCorrectFreq + correctPosFreq;
    completeTotalFreq = completeTotalFreq + totalPosFreq;
    
 
    
end
%(completeCorrectFreq ./ completeTotalFreq)*100
%100*sum(completeCorrectFreq) / sum(completeTotalFreq)
%return
%% Final results after running 'reps' times the simulation process

tabValues = tabulate(completeFinalResultsDistance);
completeErrorMeasure = mean(completeErrorMeasure / (reps*(1.0)))
completeErrorWEMeasure = mean(completeErrorWEMeasure / (reps*(1.0)))
return
%% Plotting error graphics
%errorMatrixHeat2 = [completeErrorMeasure(10:12);completeErrorMeasure(7:9);...
%    completeErrorMeasure(4:6);completeErrorMeasure(1:3)];
%errorMatrixHeat2 = [completeErrorMeasure(10);completeErrorMeasure(11);completeErrorMeasure(12);completeErrorMeasure(7);
%    completeErrorMeasure(8);completeErrorMeasure(9);completeErrorMeasure(4);completeErrorMeasure(5);
%    completeErrorMeasure(6);completeErrorMeasure(1);completeErrorMeasure(2);completeErrorMeasure(3)]
%return
errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6);...
    completeErrorMeasure(7:9);completeErrorMeasure(10:12)];

imagesc(errorMatrixHeat);
colormap(autumn);
caxis([0,3])
colorbar
set(gca,'YDir','normal')
%title('% error por m2')
title('Error per m2')

%% Plotting data
figure
stem(tabValues(:,1), tabValues(:,3), 'filled')
xlim([-0.5,3.5])
title('Analisis de predicción RSSI usando k-NN (moda)')
xlabel('error (m²) ')
ylabel('frecuencia (%)')

figure
cdfplot(tabValues(:,1))
title('Frecuencia de error acumulando, utilizando moda')
%% Accuracy
%correctPositionFrequencies
% totalPositionFrequencies
  matrixNum = [completeCorrectFreq(1:3);completeCorrectFreq(4:6);...
      completeCorrectFreq(7:9);completeCorrectFreq(10:12)];
  matrixDen = [completeTotalFreq(1:3);completeTotalFreq(4:6);...
      completeTotalFreq(7:9);completeTotalFreq(10:12)];

% 
 heatMatrix = (matrixNum ./ matrixDen)*100.0
 figure

 imagesc(heatMatrix);
 colormap(autumn);
caxis([0,100])
colorbar
set(gca,'YDir','normal')
 title('Distribución de acierto')
 
 
%% Confussion Matrix
% confussionMatrix = confusionmat(confussionKnown, confussionPredicted);
% fprintf('Matriz de confusión\n');
% disp(confussionMatrix);
% 
%% Average Position Plots
% calculating distance
 
 
tabValues = tabulate(completeAverageDistance)

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
cdfplot(tabValues(:,1))
%title('Frecuencia de error acumulando, utilizando distancia ponderada')
title ( 'Accumulated error, using weighted distance')
%disp(errorVals)

% mean error
fprintf('%d-NN , %d ejecuciones\n',K,reps);
fprintf('# data entrenamiento: %d , # data validacion: %d \n',trainSize,trainValidate);
fprintf('Error medio: %f - moda , %f - distancia ponderada\n',...
mean(completeFinalResultsDistance),mean(completeAverageDistance) );


clearvars confussionKnown confussionPredicted singleResults fstLabel correctLabel finalResultsDistance ...
     matrixNum matrixDen confussionMatrix heatMatrix heatObject;

end




