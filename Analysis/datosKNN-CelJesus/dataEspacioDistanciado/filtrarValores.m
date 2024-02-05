function [ tr, vr, tl, vl ] = filtrarValores( dataBeacon )
%filtrarValores Recibe la data de los beacons y filtra por las 15 areas
%   Asignando un porcentaje de datos para validacion y entrenamiento de
%   cada una.

porc = 0.66; % 66 %
tr = [];
vr = [];
tl = [];
vl = [];

for it2=1:15
    trssi = dataBeacon(dataBeacon(:,2)==it2,3)';
    tlabel = dataBeacon(dataBeacon(:,2)==it2,4)';
    tot = porc*size(tlabel,2);
    tr = [tr trssi(1:tot)];
    tl = [tl tlabel(1:tot)];
    vr = [vr trssi(tot+1:end)];
    vl = [vl tlabel(tot+1:end)];
end

end

