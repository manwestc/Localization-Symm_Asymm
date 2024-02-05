function [ output_args ] = SVMstats( selectedBeacons )
% Manipulate data to get the graphics and stats of SVM

%% Import training data from text file.
% Read the csv file
K = 5;
limit=5;
label_in = [];
rssi_in = [];
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/datosKNN-CelJesus/data4/t';
%prefix = '/home/jeslev/Dropbox/smartcity/avancesJesus/datosKNN/data6S3F6/t';
for it=1:limit
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,3,1);
    [tmpLabels, tmpRssi] = formatData(matrixCSV, selectedBeacons);
    label_in = [label_in ; tmpLabels];
    rssi_in = [rssi_in ; tmpRssi];
end

%% Clear temporary variables
clearvars filename M tmpLabels tmpRssi matrixCSV it limit;


%% SVM  SIMULATION PROCESS
reps = 10;

% codigo extraido de la guia SVMlib

% addpath to the libsvm toolbox
addpath('/home/jeslev/libsvm-3.21/matlab');

%% Using SVM


% addpath to the data
%dirData = '.';
%addpath(dirData);


% read the data set
%[heart_scale_label, heart_scale_inst] = libsvmread(fullfile(dirData,'heart_scale'));
%[N D] = size(heart_scale_inst);

% Determine the train and test index
%trainIndex = zeros(N,1); trainIndex(1:200) = 1;
%testIndex = zeros(N,1); testIndex(201:N) = 1;
%trainData = heart_scale_inst(trainIndex==1,:);
%trainLabel = heart_scale_label(trainIndex==1,:);
%testData = heart_scale_inst(testIndex==1,:);
%testLabel = heart_scale_label(testIndex==1,:);

completeFinalResultsDistance = [];
completeErrorMeasure = zeros(1,12);
completeAverageDistance = [];
trainSize = 0;
trainValidate = 0;
FinalcorrectPositionFrequencies = zeros(1,12);
FinaltotalPositionFrequencies = zeros(1,12);

for rep=1:reps
    %% Choose training - validation data
    [trainingRssi, trainingLabels, validationRssi, validationLabel] = ...
        getRandomTrainingData(label_in,rssi_in);
    
    trainSize = size(trainingRssi,1);
    trainValidate = size(validationRssi,1);
    
    % Train the SVM
    %model = svmtrain(trainingLabels, trainingRssi, '-s 0 -t 0 -q');
    % EXPONENCIAL model = svmtrain(trainingLabels, trainingRssi, '-s 0 -t 2');
    model = svmtrain(trainingLabels, trainingRssi, '-s 0 -t 1 -d 2 -q');
    %model = svmtrain(trainingLabels, trainingRssi, '-s 0 -t 1 -d 3 -q');
    % run the SVM model on the test data
    [predict_label, accuracy, prob_values] = svmpredict(validationLabel, validationRssi, model);

    %totalData = [predict_label'; validationLabel'];
    %disp(confusionmat(validationLabel, predict_label));
    
    finalResultsDistance = [];
    correctPositionFrequencies = zeros(1,12);
    totalPositionFrequencies = zeros(1,12);
    errorMeasure = zeros(1,12);

    
    
    % itera sobre cada resultado de la validacion
    for it=1:size(predict_label,1)
        
        
        singleResults = predict_label(it,:);%trainingLabels(predict_label(it,:),:); % obtiene k - cercanos
        fstLabel = mode(singleResults);
        correctLabel = validationLabel(it,:);

        % acumula contador de valores correctos
        if correctLabel==fstLabel
            correctPositionFrequencies(correctLabel)=correctPositionFrequencies(correctLabel)+1;
            totalPositionFrequencies(correctLabel)=totalPositionFrequencies(correctLabel)+1;
        else
            totalPositionFrequencies(correctLabel)=totalPositionFrequencies(correctLabel)+1;
        end

        singleDistance = calculateDistance(correctLabel, fstLabel);
        errorMeasure(correctLabel) = errorMeasure(correctLabel)+singleDistance; %error
        %fprintf('%d - %d - %f \n',correctLabel, fstLabel, singleDistance);
        finalResultsDistance = [finalResultsDistance singleDistance];
    end

    %% Prepare graphics array cells
    for it = 1:12
        errorMeasure(it) = errorMeasure(it)/(totalPositionFrequencies(it)*1.0);
    end
    
    
    completeErrorMeasure = completeErrorMeasure + errorMeasure; 
    
    completeFinalResultsDistance = [completeFinalResultsDistance finalResultsDistance];
    correctPositionFrequencies;
    totalPositionFrequencies;
    FinalcorrectPositionFrequencies = FinalcorrectPositionFrequencies + correctPositionFrequencies;
    FinaltotalPositionFrequencies = FinaltotalPositionFrequencies + totalPositionFrequencies;
end


%(FinalcorrectPositionFrequencies ./ FinaltotalPositionFrequencies)*100.0
%100.0*sum(FinalcorrectPositionFrequencies) / sum(FinaltotalPositionFrequencies)
%return

%% Final results after running 'reps' times the simulation process

tabValues = tabulate(completeFinalResultsDistance);
completeErrorMeasure = completeErrorMeasure / (reps*(1.0))
mean(completeErrorMeasure)
return
%% Plotting error graphics
errorMatrixHeat = [completeErrorMeasure(1:3);completeErrorMeasure(4:6);...
    completeErrorMeasure(7:9);completeErrorMeasure(10:12)];

errorMatrixHeat2 = [completeErrorMeasure(10:12);completeErrorMeasure(7:9);...
    completeErrorMeasure(4:6);completeErrorMeasure(1:3)];

%errorMatrixHeat2 = [completeErrorMeasure(10);completeErrorMeasure(11);completeErrorMeasure(12);completeErrorMeasure(7);
%    completeErrorMeasure(8);completeErrorMeasure(9);completeErrorMeasure(4);completeErrorMeasure(5);
%    completeErrorMeasure(6);completeErrorMeasure(1);completeErrorMeasure(2);completeErrorMeasure(3)]

%return
imagesc(errorMatrixHeat);
colormap(autumn);
caxis([0,3])
set(gca,'YDir','normal')
colorbar
%title('% error per m2')
title('Error per m2')
%return
%% Plotting data
figure
stem(tabValues(:,1), tabValues(:,3), 'filled')
xlim([-0.5,3.5])
title('Analisis de predicción RSSI usando k-NN (moda)')
xlabel('error (m²) ')
ylabel('frecuencia (%)')


% mean error
fprintf('%SVM , %d ejecuciones\n',reps);
fprintf('# data entrenamiento: %d , # data validacion: %d \n',trainSize,trainValidate);
fprintf('Error medio: %f - moda\n',mean(completeFinalResultsDistance) );


end