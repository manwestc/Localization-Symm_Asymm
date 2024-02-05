fprintf('Iniciando lectura de archivos\n');
%leer 1er archivo
[a,b,c,d,e,f] = textread('ordenado.txt','%f %d %d %d %d %d');
data1 = [a b c d e f];
fprintf('Archivo 1 ...cargado\n');

%leer 2do archivo
[a,b,c,d,e,f] = textread('svmCombinaciones/resultados.txt','%f,%d,%d,%d,%d,%d');
data2 = [a b c d e f];
fprintf('Archivo 2 ...cargado\n');

w_grupo = 2500; % ancho de grupo
W = size(data1,1);
cont = 0;

fprintf('Iniciando conteo\n');
it = 1;
while it <= W
    
    if( it + w_grupo > W)
        bar = W;
    else
        bar = it + w_grupo;
    end
    
    tmp1 = [];
    tmp2 = [];
    
    for it2 = it:bar
        txt1 = 0;
        txt2 = 0;
        for it3 = 2:6
            txt1 = txt1 + (data1(it2,it3))*(10^(6-it3));
            txt2 = txt2 + (data2(it2,it3))*(10^(6-it3));
        end
        
        tmp1 = [tmp1 txt1];
        tmp2 = [tmp2 txt2];
    end
    
    inter = intersect(tmp1,tmp2);
    sz_inter = size(inter,2);
    cont = cont + sz_inter;
    it = it + w_grupo;
    %fprintf('# Encontrados en subgrupo : %d\n',sz_inter);
    
end

fprintf('Nro de coincidencias encontradas: %d\n',cont);