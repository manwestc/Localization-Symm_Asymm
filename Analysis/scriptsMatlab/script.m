%% Importa datos para el entrenamiento , de capturas previamente hechas


% Read the csv file
K = 7;
limit = 1;
trainingLabels= [];
trainingRssi = [];
matrixCSV = [];
nroPartitions = 23;
selectedBeacons = [1 2 3  4 5];
ruta1 = [1 2 5 6 9 8 11 10 13 14 15];
ruta2 = [15 12 11 8 5 4 1 2 3];
porModa = 0 ; % 0 para usar pesos ponderados

%% usa test1 y 2 para el entrenamiento
prefix = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/nuevosManuelBeacons/Raspberri/Tx_0x01/test';
for it=1:15
    filename = strcat(prefix,int2str(it),'.csv');
    matrixCSV = csvread(filename,0,0);
    trainingLabels = [trainingLabels; matrixCSV(:,1)];
    trainingRssi = [trainingRssi; matrixCSV(:,2:end)];
end

clear tmpLabels tmpRssi matrixCSV

%% Choose range values if need to discretize
%discretePartitions = calculateDiscreteRange(matrixCSV(:,3)', nroPartitions);

%% Choose training
%[trainingRssi, trainingLabels] =  selectMatrixLabel(matrixCSV, discretePartitions);

%% Inicia el algoritmo con la data entrenada para determinar la ruta

validationLabel = [];
validationRssi = [];


%% Procesa archivo de ruta  
filename = '/home/jeslev/Dropbox/Bluetooth/ResultadosJesus/DatosSimulacionRutas1-2/Tx0x01/Ruta1/t1/final2.csv';
matrixRuta = csvread(filename,21,0);

validationLabel = matrixRuta(:,2);
validationRssi = matrixRuta(:,3:7);
movimientos = matrixRuta(:,1);

movRuta = [];
cnt = 0;
start = 0;
%determina dx, para movilizar los puntos
for it=1:size(movimientos,1)
    if movimientos(it)==1
        cnt = cnt+1;
        start=1;
    elseif start==1
        movRuta = [movRuta; cnt];
        start =0;
        cnt = 0;
    else
        cnt = 0;
    end
end


validationLabel = ruta1(validationLabel);
%distancias reales de los puntos medios
x = [0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5, 0.5, 2, 3.5];
y = [0.5, 0.5, 0.5, 2, 2, 2, 3.5, 3.5, 3.5, 5, 5, 5, 6.5, 6.5, 6.5];

rutaX0 = x(validationLabel);
rutaY0 = y(validationLabel);

% prepara puntos para la simulacion
cnt = 1;
dx = 0.0;
dy = 0.0;
for it=1:size(movimientos,1)
    if movimientos(it)==1 && movimientos(it-1)==0
        deltaX = rutaX0(it)-rutaX0(it+movRuta(cnt)+1);
        deltaY = rutaY0(it)-rutaY0(it+movRuta(cnt)+1);
        dx = (-(deltaX)*1.0)/(movRuta(cnt)*1.0); %1.5 m = 150 cm 
        dy = (-(deltaY)*1.0)/(movRuta(cnt)*1.0);
        
        cnt = cnt+1;
    elseif movimientos(it)==1
        rutaX0(it) = rutaX0(it-1) + dx;
        rutaY0(it) = rutaY0(it-1) + dy;
    end
end


%por fila obtiene los K mas cercanos
result  = knnsearch(trainingRssi,validationRssi,'k',K);
confussionKnown = [];
confussionPredicted = [];
cnt = 0;
rutaXP = [];
rutaYP = [];


rutaX0 = rutaX0';
rutaY0 = rutaY0';

%% Proceso por moda
if porModa == 1
    for it=1:size(result,1)
        singleResults = trainingLabels(result(it,:),:); % obtiene k - cercanos

        predictedLabel = mode(singleResults);
        confussionKnown = [confussionKnown validationLabel(it)];
        confussionPredicted = [confussionPredicted predictedLabel];
        if validationLabel(it)==predictedLabel
            cnt = cnt+1;
        end
    end


    errorTotal = 0.0;

    for it=1:size(confussionKnown,2)
        errorTotal = errorTotal + calculateDistance(confussionKnown(1,it), confussionPredicted(1,it));
    end

    errorTotal/(size(confussionKnown,2)*1.0)
    100.0*cnt/(size(confussionKnown,2)*1.0)

    %% Calcular posiciones de los puntos predichos
    rutaXP = x(confussionPredicted);
    rutaYP = y(confussionPredicted);

else
    xy = weightPosition(validationLabel,trainingLabels,result ,K);
    rutaXP = xy(:,1);
    rutaYP = xy(:,2);
    
    errorX = (rutaX0-rutaXP);
    errorY = (rutaY0-rutaYP);
    errorX = errorX.*errorX;
    errorY = errorY.*errorY;
    errorTotal = sqrt(errorX+errorY);
    mean(errorTotal)
end

%% Animacion

%# control animation speed
DELAY = 0.01;
numPoints = size(rutaX0,1);

%# data
% ruta Original rutaX0, rutaY0

%# plot graph
set(gca,'YDir','reverse')
figure('DoubleBuffer','on')                  %# no flickering
plot(rutaX0,rutaY0, 'LineWidth',2), grid on
axis([0 4 0 7])
xlabel('x'), ylabel('y'), title('Ruta 1')

%# create moving point + coords text
hLine = line('XData',rutaX0(1), 'YData',rutaY0(1), 'Color','r', ...
    'Marker','o', 'MarkerSize',6, 'LineWidth',2);
hTxt = text(rutaX0(1), rutaY0(1), sprintf('(%.3f,%.3f)',x(1),y(1)), ...
    'Color',[0.2 0.2 0.2], 'FontSize',8, ...
    'HorizontalAlignment','left', 'VerticalAlignment','top');

hLine2 = line('XData',rutaXP(1), 'YData',rutaYP(1), 'Color','g', ...
    'Marker','o', 'MarkerSize',6, 'LineWidth',2);
hTxt2 = text(rutaXP(1), rutaYP(1), sprintf('(%.3f,%.3f)',rutaXP(1),rutaYP(1)), ...
    'Color',[0.2 0.2 0.2], 'FontSize',8, ...
    'HorizontalAlignment','left', 'VerticalAlignment','top');

%# infinite loop
i = 1;                                       %# index
while i<=numPoints      
    %# update point & text
    set(hLine, 'XData',rutaX0(i), 'YData',rutaY0(i))   
    set(hTxt, 'Position',[rutaX0(i) rutaY0(i)], ...
        'String',sprintf('(%.3f,%.3f)',[rutaX0(i) rutaY0(i)]))        
    
    %# update predicted point & text
    set(hLine2, 'XData',rutaXP(i), 'YData',rutaYP(i))   
    set(hTxt2, 'Position',[rutaXP(i) rutaYP(i)], ...
        'String',sprintf('(%.3f,%.3f)',[rutaXP(i) rutaYP(i)]))        
    
    drawnow                                  %# force refresh
    
    
    pause(DELAY)                           %# slow down animation

    
    i = i+1;                %# circular increment
    if ~ishandle(hLine), break; end          %# in case you close the figure
end
return