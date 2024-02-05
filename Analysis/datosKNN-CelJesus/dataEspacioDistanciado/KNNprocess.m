function [ errorMeasure, finalResultsDistance, confussionMatrix, averageDistance ...
    correctPosFreq, totalPosFreq, confussion, errorW] =...
    KNNprocess( trainingRssi, validationRssi,trainingLabels, validationLabel, K )
% ejecuta el algoritmo KNN y devuelve los resultados obtenidos

result  = knnsearch(trainingRssi,validationRssi,'k',K);

% calcular por posicion ponderada
[averagePosition, errorW] = weightPosition(trainingLabels,validationLabel,result);


%% Using mode
finalResultsDistance = [];
correctPosFreq = zeros(1,15);
totalPosFreq = zeros(1,15);
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
        correctPosFreq(correctLabel)=correctPosFreq(correctLabel)+1;
        totalPosFreq(correctLabel)=totalPosFreq(correctLabel)+1;
    else
        totalPosFreq(correctLabel)=totalPosFreq(correctLabel)+1;
    end
    
    singleDistance = calculateDistance(correctLabel, fstLabel);
    errorMeasure(correctLabel) = errorMeasure(correctLabel)+singleDistance; %error
    %fprintf('%d - %d - %f \n',correctLabel, fstLabel, singleDistance);
    finalResultsDistance = [finalResultsDistance singleDistance];
end

%% Prepare graphics array cells
for it = 1:15
    errorMeasure(it) = errorMeasure(it)/(totalPosFreq(it)*1.0);
end
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
%end

%% Confussion Matrix
 confussionMatrix = confusionmat(confussionKnown, confussionPredicted);
    confussion = confussionMatrix;
end

