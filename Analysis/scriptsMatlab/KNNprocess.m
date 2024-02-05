function [ errorMeasure, finalResultsDistance, confussionMatrix, averageDistance, ...
    correctPositionFrequencies,totalPositionFrequencies,confussion ] =...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K )
% ejecuta el algoritmo KNN y devuelve los resultados obtenidos

result  = knnsearch(trainingRssi,validationRssi,'k',K);

% calcular por posicion ponderada
averagePosition = weightPosition(validationLabel',trainingLabels',result,K);
size(averagePosition);

%% Using mode
finalResultsDistance = [];
correctPositionFrequencies = zeros(1,15);
totalPositionFrequencies = zeros(1,15);
errorMeasure = zeros(1,15);

confussionKnown = [];
confussionPredicted = [];

% itera sobre cada resultado de la validacion
for it=1:size(result,1)
    singleResults = trainingLabels(result(it,:),:); % obtiene k - cercanos
    fstLabel = mode(singleResults);
    correctLabel = validationLabel(it,:);
    confussionKnown = [confussionKnown correctLabel];
    confussionPredicted = [confussionPredicted fstLabel];
    
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

totalPositionFrequencies;
%% Prepare graphics array cells (accurate error)
%for it = 1:15
%    errorMeasure(it) = 1.0-(correctPositionFrequencies(it)/(totalPositionFrequencies(it)*1.0));
%end

%average distance position
averageDistance = [];
for it = averagePosition'
    p1 = it(1)-it(3);
    p2 = it(2)-it(4);
    averageDistance = [averageDistance , sqrt(p1*p1 + p2*p2)];
end

%% Confussion Matrix
 confussionMatrix = confusionmat(confussionKnown, confussionPredicted);
    confussion = confussionMatrix;
end
