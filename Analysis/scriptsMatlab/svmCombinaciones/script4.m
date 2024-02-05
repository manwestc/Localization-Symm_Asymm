%% Distintas pruebas SVM
%% con todas las combinaciones de potencias
% Read the csv file
clear all;
limit = 1;
nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];

prefix = [];
for pot = 1:7
    prefix = [prefix; 
        strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x0',int2str(pot),'/train')];
end

prefix2 = [];
for pot = 1:7
    prefix2 = [prefix2; 
        strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x0',int2str(pot),'/valid')];
end

% Calcular combinaciones
%combinaciones = [ [1,1,1,1,1] ;
%                    [6,6,6,6,6]];

pot = 1:6;
%array = [1,2,3,4,5];
combinacion = zeros(1,5);
indice = 1;
combinaciones = [];
combinaciones = recursioncomb(indice,combinacion,combinaciones);

combinaciones = combinaciones(611:end,:);
%% SVM  SIMULATION PROCESS
reps = 1;

% codigo extraido de la guia SVMlib



% Recorrer combinaciones
cont = 0;
for c = combinaciones'
    cont = cont+1;
    trainingLabels= [];
    trainingRssi = [];
    matrixCSV = [];
    matrix1 = []; matrix2 = []; matrix3 = []; matrix4 = []; matrix5 = [];
    
    %pot = 'T';

    %% preparando archivos de entrenamiento
    for it=1:15
        
        filename = strcat(prefix(c(1),:),int2str(it),'.csv');
        matrix1 = csvread(filename,0,0);
        filename = strcat(prefix(c(2),:),int2str(it),'.csv');
        matrix2 = csvread(filename,0,0);
        filename = strcat(prefix(c(3),:),int2str(it),'.csv');
        matrix3 = csvread(filename,0,0);
        filename = strcat(prefix(c(4),:),int2str(it),'.csv');
        matrix4 = csvread(filename,0,0);
        filename = strcat(prefix(c(5),:),int2str(it),'.csv');
        matrix5 = csvread(filename,0,0);
        
        tam = min([size(matrix1,1),size(matrix2,1),size(matrix3,1),...
                    size(matrix4,1),size(matrix5,1)]);
        matrixCSV = [matrix1(1:tam,1)';matrix1(1:tam,2)'; matrix2(1:tam,3)';
        matrix3(1:tam,4)'; matrix4(1:tam,5)';matrix5(1:tam,6)']';
    
        trainingLabels = [trainingLabels; matrixCSV(:,1)];
        trainingRssi = [trainingRssi; matrixCSV(:,2:end)];
    end
    clear tmpLabels tmpRssi matrixCSV


    %% Obtener media de RSSI por sector
    %beacon = 5; % [7 8 9 10 11]
    %medidas = [];
    %for it=1:15
    %    indices = trainingLabels==it;
    %    medidas = [medidas; mean(trainingRssi(indices,beacon))];
    %end
    %medidas
    %return


    %% Inicia el algoritmo con la data entrenada para determinar la ruta

    validationLabel = [];
    validationRssi = [];


    %% Procesa archivos de validacion
    for it=1:15
        
        filename = strcat(prefix2(c(1),:),int2str(it),'.csv');
        matrix1 = csvread(filename,0,0);
        filename = strcat(prefix2(c(2),:),int2str(it),'.csv');
        matrix2 = csvread(filename,0,0);
        filename = strcat(prefix2(c(3),:),int2str(it),'.csv');
        matrix3 = csvread(filename,0,0);
        filename = strcat(prefix2(c(4),:),int2str(it),'.csv');
        matrix4 = csvread(filename,0,0);
        filename = strcat(prefix2(c(5),:),int2str(it),'.csv');
        matrix5 = csvread(filename,0,0);
        
        tam = min([size(matrix1,1),size(matrix2,1),size(matrix3,1),...
                    size(matrix4,1),size(matrix5,1)]);
        matrixCSV = [matrix1(1:tam,1)';matrix1(1:tam,2)'; matrix2(1:tam,3)';
        matrix3(1:tam,4)'; matrix4(1:tam,5)';matrix5(1:tam,6)']';
    
        validationLabel = [validationLabel; matrixCSV(:,1)];
        validationRssi = [validationRssi; matrixCSV(:,2:end)];
    end
    clear matrix1 matrix2 matrix3 matrix4 matrix5;
    
    %% Inicia algoritmo - SVM Search
    [completeErrorMeasure, completeFinalResultsDistance,...
        correctPosFreq, totalPosFreq] = ...
        svmFunc( trainingRssi, validationRssi,trainingLabels, validationLabel, reps);



    %% Final results after running 'reps' times the simulation process
    %tabValues = tabulate(completeFinalResultsDistance);


    %% Confussion Matrix
    %fprintf('Matriz de confusión\n');
    %disp(confussionMatrix);

    %% Error
    errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6); completeErrorMeasure(7:9);
        completeErrorMeasure(10:12); completeErrorMeasure(13:15)];
    %disp(mean(completeErrorMeasure));


    %% Accuracy
    %correctPositionFrequencies
    % totalPositionFrequencies
      matrixNum = [correctPosFreq(1:3);correctPosFreq(4:6); ...
        correctPosFreq(7:9);correctPosFreq(10:12); correctPosFreq(13:15)];
      matrixDen =[totalPosFreq(1:3);totalPosFreq(4:6); ...
        totalPosFreq(7:9);totalPosFreq(10:12); totalPosFreq(13:15)];

    % 
     heatMatrix = (matrixNum ./ matrixDen)*100.0;
     %figure

     %imagesc(heatMatrix);
     %colormap(autumn);
    %caxis([0,100])
    %colorbar
    %set(gca,'YDir','normal')
    % title('Distribución de acierto')


    %% Save DATA
    pre = '';
    for it = 1:5
        pre = strcat(pre,int2str(c(it)));
    end
    
    %csvwrite(strcat('./data/',pre,'error.csv'),completeErrorMeasure);
    %csvwrite(strcat('./data/',pre,'accu.csv'),heatMatrix);
    csvwrite(strcat('./data/',pre,'moda.csv'),completeFinalResultsDistance);
    %csvwrite(strcat('./data/',pre,'pond.csv'),averageDistance);
    
end
 
