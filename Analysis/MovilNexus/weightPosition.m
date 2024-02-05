function [ ret ] = weightPosition(validationLabel, trainingLabel, results ,k )

x = [0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5];
y = [0.5, 0.5, 0.5, 2, 2, 2, 3.5, 3.5, 3.5, 5, 5, 5, 6.5, 6.5, 6.5];


ret = [];

%iterate validationValues
for it = 1:size(validationLabel,2)
    vl = validationLabel(it);
    pos_x = 0.0;
    pos_y = 0.0;
    totalWeight = k;
    %get the labels to calculate an average weigth position
    %pos_x = x(trainingLabel(results(it,:))')
    %pos_y = y(trainingLabel(results(it,:))')
    
    for it2 = x(trainingLabel(results(it,:))')
        pos_x = pos_x + it2;
    end
    
    for it2 = y(trainingLabel(results(it,:))')
        pos_y = pos_y + it2;
    end
    
    pos_x = pos_x/totalWeight;
    pos_y = pos_y/totalWeight;
    %ret = [ret; [pos_x, pos_y ] ];
    ret = [ret; [ x(vl), y(vl), pos_x, pos_y ] ];
end

