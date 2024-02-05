function [ completeErrorMeasure, completeFinalResultsDistance, ...
        correctPositionFrequencies, totalPositionFrequencies ] = SVMprocess(  trainingRssi, validationRssi,trainingLabels, validationLabel, reps )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% addpath to the libsvm toolbox
addpath('/home/jeslev/libsvm-3.21/matlab');
for rep=1:1
    
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
    correctPositionFrequencies = zeros(1,15);
    totalPositionFrequencies = zeros(1,15);
    errorMeasure = zeros(1,15);
    completeErrorMeasure = zeros(1,15);
    completeFinalResultsDistance = [];
    
    
    % itera sobre cada resultado de la validacion
    for it=1:size(predict_label,1)
        
        
        singleResults = predict_label(it,:);%trainingLabels(predict_label(it,:),:);
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
    for it = 1:15
        errorMeasure(it) = errorMeasure(it)/(totalPositionFrequencies(it)*1.0);
    end
    
    
    completeErrorMeasure = completeErrorMeasure + errorMeasure; 
    
    completeFinalResultsDistance = [completeFinalResultsDistance finalResultsDistance];
    %correctPositionFrequencies
    %totalPositionFrequencies
end

end

