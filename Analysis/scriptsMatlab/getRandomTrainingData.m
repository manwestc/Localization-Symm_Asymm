function [ trainingRssi, trainingLabels, validationRssi, validationLabel] ... 
        = getRandomTrainingData( label_in, rssi_in )
% elije aleatoriamente la data de entrenamiento y validacion
% 30% validation, 70% training

validationSizeSample = round( 0.3*size(label_in,1) ); % 30% from total Data

validationIndexSample = randperm(size(label_in,1));
validationIndexSample = validationIndexSample( (size(label_in,1)+1-validationSizeSample):end)';

validationLabel = label_in(validationIndexSample,:);
validationRssi = rssi_in(validationIndexSample, :);

%% Choose training data
trainingIndexSample = setdiff(1:size(label_in,1), validationIndexSample);
trainingLabels = label_in(trainingIndexSample, :);
trainingRssi = rssi_in(trainingIndexSample, :);
%size(trainingLabels)
%size(validationLabel)

end

