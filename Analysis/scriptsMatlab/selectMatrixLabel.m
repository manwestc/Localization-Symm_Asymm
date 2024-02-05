function [ positions, labels ] = selectMatrixLabel( matrixCSV, discretePartitions )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%swap columns so first sorting by position and then by time
matrixCSV(:,[1,2]) = matrixCSV(:,[2,1]); 

matrixCSVsorted = sortrows(matrixCSV);

%select positions from 1 to 15
positions1 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==1,:), discretePartitions);
label1 = 1 * ones(size(positions1,1),1);
positions2 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==2,:), discretePartitions);
label2 = 2 * ones(size(positions2,1),1);
positions3 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==3,:), discretePartitions);
label3 = 3 * ones(size(positions3,1),1);
positions4 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==4,:), discretePartitions);
label4 = 4 * ones(size(positions4,1),1);
positions5 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==5,:), discretePartitions);
label5 = 5 * ones(size(positions5,1),1);
positions6 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==6,:), discretePartitions);
label6 = 6 * ones(size(positions6,1),1);
positions7 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==7,:), discretePartitions);
label7 = 7 * ones(size(positions7,1),1);
positions8 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==8,:), discretePartitions);
label8 = 8 * ones(size(positions8,1),1);
positions9 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==9,:), discretePartitions);
label9 = 9 * ones(size(positions9,1),1);
positions10 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==10,:), discretePartitions);
label10 = 10 * ones(size(positions10,1),1);
positions11 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==11,:), discretePartitions);
label11 = 11 * ones(size(positions11,1),1);
positions12 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==12,:), discretePartitions);
label12 = 12 * ones(size(positions12,1),1);
positions13 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==13,:), discretePartitions);
label13 = 13 * ones(size(positions13,1),1);
positions14 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==14,:), discretePartitions);
label14 = 14 * ones(size(positions14,1),1);
positions15 = formatMatrix(matrixCSVsorted(matrixCSVsorted(:,1)==15,:), discretePartitions);
label15 = 15 * ones(size(positions15,1),1);

positions = [ positions1 ; positions2 ; positions3 ; positions4 ; positions5 ; positions6 ; positions7; positions8 ; positions9 ; positions10 ;positions11 ; positions12; positions13 ; positions14 ; positions15];
%positions = [ positions1 ; positions2 ; positions3 ; positions4 ; positions5 ; positions6 ; positions7; positions8 ; positions9 ; positions10 ;positions11 ; positions12];

labels = [label1;label2;label3;label4;label5;label6;label7;label8;label9;label10;label11;label12;label13;label14;label15];
%labels = [label1;label2;label3;label4;label5;label6;label7;label8;label9;label10;label11;label12];
end

