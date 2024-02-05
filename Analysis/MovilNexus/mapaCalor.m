function [ ] = mapaCalor( valores )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
figure

 imagesc(valores);
 colormap(autumn);
caxis([0,100])
colorbar
set(gca,'YDir','normal')
 title('Distribución de acierto - agrupados')




end

