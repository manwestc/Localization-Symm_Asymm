function [ ret, errorW ] = weightPosition( trainingLabel, validationLabel, results  )

x = [0.5, 0.5, 0.5, 1.5, 1.5, 1.5, 2.5, 2.5, 2.5, 3.5, 3.5, 3.5];
y = [0.5, 1.5, 2.5, 0.5, 1.5, 2.5, 0.5, 1.5, 2.5, 0.5, 1.5, 2.5];


ret = [];
errorW = zeros(1,12);
cntW = zeros(1,12);

%iterate validationValues
for it = 1:size(validationLabel,1)
    vl = validationLabel(it);
    pos_x = 0.0;
    pos_y = 0.0;
    totalWeight = size(results,2);
    %get the labels to calculate an average weigth position
    %pos_x = x(trainingLabel(results(it,:))')
    %pos_y = y(trainingLabel(results(it,:))')
    
    pW = totalWeight;
    for it2 = x(trainingLabel(results(it,:))')
        pos_x = pos_x + pW*it2;
        pW = pW-1;
    end
    
    pW = totalWeight;
    for it2 = y(trainingLabel(results(it,:))')
        pos_y = pos_y + pW*it2;
        pW = pW-1;
    end
    
    totalWeight = ((totalWeight+1)*totalWeight)/2;
    pos_x = pos_x/totalWeight;
    pos_y = pos_y/totalWeight;
    ret = [ret; [ x(vl), y(vl), pos_x, pos_y ] ];
    
    p1 = x(vl)-pos_x;
    p2 = y(vl)-pos_y;
    errorW(vl) =  errorW(vl) + sqrt(p1*p1 + p2*p2);
    cntW(vl) = cntW(vl) + 1;
end

for it = 1:12
    errorW(it) = errorW(it)/cntW(it);
end