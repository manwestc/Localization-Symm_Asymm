function [ ret ] = recursioncomb(indice,comb,res )
%Calcula la combinatoria de todas las potencias
if indice>5
    ret = comb;
    %combi = 1;
else
    ret = [];
    for pot = 1:6
        comb(indice) = pot;
        ret = [ret; recursioncomb(indice+1, comb,res)];
    end
    %combi = tmp;
end



end