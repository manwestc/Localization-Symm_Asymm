clear all;
combinaciones = [];
indice = 1;
combinacion = zeros(1,5);
combinaciones = recursioncomb(indice,combinacion,combinaciones);

figure

totalc = [];
for c = combinaciones'

    pre = '';
    for it = 1:5
        pre = strcat(pre,int2str(c(it)));
    end
    
    filename = strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/scriptsMatlab/data/',pre,'moda.csv');
    matrix = csvread(filename,0,0);
    a =tabulate(matrix);
    if(a(1,3) > 77.0 || a(1,3) < 44.53)
        tmp = [a(1,3) , c' ];
        totalc = [totalc; tmp];
        cdfplot(matrix)
        hold on
    end
end

xlabel('Error(m)') % x-axis label
ylabel('Cumulative Probability') % y-axis label
title('')
legend('[1,2,4,5,3]','[1,5,4,5,3]','[1,5,4,5,5]','[4,1,2,1,1]','[4,1,2,1,4]','[4,1,2,6,1]')
ordenado = sortrows(totalc,1);