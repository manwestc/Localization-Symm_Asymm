clear all;
combinaciones = [];
indice = 1;
combinacion = zeros(1,5);
combinaciones = recursioncomb(indice,combinacion,combinaciones);

%figure
totalc = [];
for c = combinaciones'

    pre = '';
    for it = 1:5
        pre = strcat(pre,int2str(c(it)));
    end
    
    filename = strcat('/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/scriptsMatlab/svmCombinaciones/data/',pre,'moda.csv');
    matrix = csvread(filename,0,0);
    a =tabulate(matrix);
    %if(a(1,3) > 74.0)
        tmp = [a(1,3) , c' ];
        totalc = [totalc; tmp];
        %cdfplot(matrix)
        %hold on
    %end
end

ordenado = sortrows(totalc,1);
dlmwrite('resultados.txt',ordenado);