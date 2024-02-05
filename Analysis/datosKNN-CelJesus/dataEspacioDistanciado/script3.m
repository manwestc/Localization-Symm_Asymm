%% Prepara para hibrido Be7,8,9 Tx0x07, Be10 ,11 Tx0x04
clear all;
K = 5;
prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/0x07/test';
matrixCSV = [];
for it=2:3
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = [matrixCSV ; csvread(filename,1,0)];
    %matrixCSV = csvread(filename,1,0);
end

% Obten Be07
datBe7 = matrixCSV(matrixCSV(:,4)==7,:);

% Obten Be08
datBe8 = matrixCSV(matrixCSV(:,4)==8,:);

% Obten Be09
datBe9 = matrixCSV(matrixCSV(:,4)==9,:);

prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/0x04/test';
for it=2:5
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = [matrixCSV ; csvread(filename,1,0)];
    %matrixCSV = csvread(filename,1,0);
end

% Obten Be10
datBe10 = matrixCSV(matrixCSV(:,4)==10,:);

% Obten Be11
datBe11 = matrixCSV(matrixCSV(:,4)==11,:);


%% Choose training
[trainingRssi, trainingLabels] = selectMatrixLabel([datBe7;datBe8;datBe9;datBe10;datBe11], []);


%% Choose validation data

prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/0x07/test';
filename = strcat(prefix,'1.csv');
matrixTrainCSV = csvread(filename,1,0);

% Obten Be07
datBe7 = matrixCSV(matrixCSV(:,4)==7,:);

% Obten Be08
datBe8 = matrixCSV(matrixCSV(:,4)==8,:);

% Obten Be09
datBe9 = matrixCSV(matrixCSV(:,4)==9,:);

prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/dataEspacioDistanciado/0x04/test';
filename = strcat(prefix,'1.csv');
matrixTrainCSV = csvread(filename,1,0);

% Obten Be10
datBe10 = matrixCSV(matrixCSV(:,4)==10,:);

% Obten Be11
datBe11 = matrixCSV(matrixCSV(:,4)==11,:);

[validationRssi, validationLabel] = selectMatrixLabel([datBe7;datBe8;datBe9;datBe10;datBe11], []);


%% KNN Search
[completeErrorMeasure, completeFinalResultsDistance, confussionMatrix, averageDistance,...
    correctPosFreq, totalPosFreq, confussion] = ...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K);


%% Final results after running 'reps' times the simulation process
tabValues = tabulate(completeFinalResultsDistance);


%% Plotting error graphics
errorMatrixHeat = [completeErrorMeasure(13:15);completeErrorMeasure(10:12); ...
    completeErrorMeasure(7:9);completeErrorMeasure(4:6); completeErrorMeasure(1:3)];

%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12); completeErrorMeasure(13:15)];
%errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);completeErrorMeasure(10:12)];


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
%title('Frecuencia de error acumulando, utilizando distancia ponderada')
title ( 'Accumulated error, using weighted distance')
%disp(errorVals)

% mean error
fprintf('Error medio: %f - moda , %f - distancia ponderada\n',...
mean(completeFinalResultsDistance),mean(averageDistance) );

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