%% Import training data from text file.
% Read the csv file
%clear all;
K = 5;
limit = 5;
label_in = [];
rssi_in = [];
matrixCSV = [];
nroPartitions = 23;
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/datosKNN-CelJesus/dataEspacioDistanciado/0x07/test';
for it=2:3
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = [matrixCSV ; csvread(filename,1,0)];
    %matrixCSV = csvread(filename,1,0);
end



%% Choose range values if need to discretize
discretePartitions = calculateDiscreteRange(matrixCSV(:,3)', nroPartitions);

%% Choose training
[trainingRssi, trainingLabels] = selectMatrixLabel(matrixCSV, matrixCSV);


%% Obtener media de RSSI por sector
beacon = 5; % [7 8 9 10 11] Cambiar tambien en formatMatrix.m
%medidas = [];
%for it=1:15
%    indices = trainingLabels==it;
%    medidas = [medidas; [mean(trainingRssi(indices,beacon)), std(trainingRssi(indices,beacon))]];
%end
%medidas(:,1)
%return
%% Choose validation data
filename = strcat(prefix,'1.csv');
matrixTrainCSV = csvread(filename,1,0);
[validationRssi, validationLabel] = selectMatrixLabel(matrixTrainCSV, discretePartitions);

%% KNN Search
%[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance,...
%    correctPosFreq, totalPosFreq, confussion, errorW] = ...
%    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);



%% SVM Search
[completeErrorMeasure, completeFinalResultsDistance,...
        correctPosFreq, totalPosFreq] = ...
        SVMprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, 2);
    

%(correctPosFreq ./ totalPosFreq)*100
%100*sum(correctPosFreq) / sum(totalPosFreq)
completeErrorMeasure
mean(completeErrorMeasure)
%errorW
%mean(errorW)
return

%% Final results after running 'reps' times the simulation process
tabValues = tabulate(completeFinalResultsDistance);


%% Plotting error graphics
errorMatrixHeat = [completeErrorMeasure(13:15);completeErrorMeasure(10:12); ...
    completeErrorMeasure(7:9);completeErrorMeasure(4:6); completeErrorMeasure(1:3)];
%errorMatrixHeat = [completeErrorMeasure(13);completeErrorMeasure(14);completeErrorMeasure(15);
%    completeErrorMeasure(10);completeErrorMeasure(11);completeErrorMeasure(12);completeErrorMeasure(7);completeErrorMeasure(8);completeErrorMeasure(9);
%    completeErrorMeasure(4);completeErrorMeasure(5);completeErrorMeasure(6); completeErrorMeasure(1);completeErrorMeasure(2);completeErrorMeasure(3)]
%errorMatrixHeat2 = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12); completeErrorMeasure(13:15)]
%return
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12)];
mean2(errorMatrixHeat)
mean2(averageDistance)
%return 

clims = [0 3.5];
imagesc(errorMatrixHeat);
colormap(autumn);
caxis([0,3.5])
colorbar;
set(gca,'YDir','normal')
title('Error per m2')

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
%disp(confussionMatrix);

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
%title('Frecuencia de error acumulando, utilizando distancia ponderada')
title ( 'Accumulated error, using weighted distance')
%disp(errorVals)

% mean error
fprintf('Error medio: %f - moda , %f - distancia ponderada\n',...
mean(completeFinalResultsDistance),mean(averageDistance) )
return

%% Accuracy
%correctPositionFrequencies
% totalPositionFrequencies
  matrixNum = [correctPosFreq(13:15);correctPosFreq(10:12); ...
    correctPosFreq(7:9);correctPosFreq(4:6); correctPosFreq(1:3)];
  matrixDen =[totalPosFreq(13:15);totalPosFreq(10:12); ...
    totalPosFreq(7:9);totalPosFreq(4:6); totalPosFreq(1:3)];

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

valores = [valores(13:15); valores(10:12); valores(7:9); valores(4:6); valores(1:3)];
mapaCalor(valores)