function [listo]=generarOutput(mejorANN,mejorENN,tipoNormalizacion)
%OBJETIVO: Generar las matrices de diseño normalizadas necesarias. 
%COMPORTAMIENTO: Son capturadas las matrices donde se almacenan los rezagos de la parte
%lineal como de la no lineal, los datos y el numero de la columna que se usara.
%RETORNA: Las matrices de diseño necesarias.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

%Obtengo los datos que necesita la funcion
numPeriodos=size(datos,1);


%Ajuste y Pronostico de la ANN
numeroNeuronas=cell2mat(mejorANN(1,3))
numHorizonte=cell2mat(mejorANN(1,5))
phi=cell2mat(mejorANN(1,8))
betha=cell2mat(mejorANN(1,9))
alpha=cell2mat(mejorANN(1,10))
topologia=cell2mat(mejorANN(1,11))
rezagosParteLineal=cell2mat(mejorANN(1,12));
rezagosParteNoLineal=cell2mat(mejorANN(1,13));
numDentroMuestra=numPeriodos-tamanoHorizontes-(numeroHorizontes-numHorizonte);
numFueraMuestra=numPeriodos-(numeroHorizontes-numHorizonte);

[dentroMuestraNoLineal, fueraMuestraNoLineal, dentroMuestraLineal,...
    fueraMuestraLineal]=generarInput(rezagosParteNoLineal,...
    rezagosParteLineal,numHorizonte);
[dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN,...
    fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLineal,...
    rezagosParteLineal,numHorizonte,tipoNormalizacion);
                
%Ajuste ANN
A_1_AANN=dentroMuestraNoLinealN(:,2:end);
Z_2_AANN=A_1_AANN*(topologia(1:end-1,:).*alpha);
A_2_AANN=sigmoid(Z_2_AANN);
A_3_AANN=(dentroMuestraLinealN(:,2:end)*phi')+(A_2_AANN*((topologia(end:end,:)'.*betha')));

%Pronostico ANN
A_1_FANN=fueraMuestraNoLinealN(:,2:end);
Z_2_FANN=A_1_FANN*(topologia(1:end-1,:).*alpha);
A_2_FANN=sigmoid(Z_2_FANN);
A_3_FANN=(fueraMuestraLinealN(:,2:end)*phi')+(A_2_FANN*((topologia(end:end,:)'.*betha')));

%Ajuste y Pronostico de la ENN
numeroNeuronas=cell2mat(mejorENN(1,3))
numHorizonte=cell2mat(mejorENN(1,5))
phi=cell2mat(mejorENN(1,8))
betha=cell2mat(mejorENN(1,9))
alpha=cell2mat(mejorENN(1,10))
topologia=cell2mat(mejorENN(1,11))
rezagosParteLineal=cell2mat(mejorENN(1,12));
rezagosParteNoLineal=cell2mat(mejorENN(1,13));
numDentroMuestra=numPeriodos-tamanoHorizontes-(numeroHorizontes-numHorizonte);
numFueraMuestra=numPeriodos-(numeroHorizontes-numHorizonte);

[dentroMuestraNoLineal, fueraMuestraNoLineal, dentroMuestraLineal,...
    fueraMuestraLineal]=generarInput(rezagosParteNoLineal,...
    rezagosParteLineal,numHorizonte);
[dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN,...
    fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLineal,...
    rezagosParteLineal,numHorizonte,tipoNormalizacion);

%Ajuste ENN
A_1_AENN=dentroMuestraNoLinealN(:,2:end);
Z_2_AENN=A_1_AENN*(topologia(1:end-1,:).*alpha);
A_2_AENN=sigmoid(Z_2_AENN);
A_3_AENN=(dentroMuestraLinealN(:,2:end)*phi')+(A_2_AENN*((topologia(end:end,:)'.*betha')));

%Pronostico ENN
A_1_FENN=fueraMuestraNoLinealN(:,2:end);
Z_2_FENN=A_1_FENN*(topologia(1:end-1,:).*alpha);
A_2_FENN=sigmoid(Z_2_FENN);
A_3_FENN=(fueraMuestraLinealN(:,2:end)*phi')+(A_2_FENN*((topologia(end:end,:)'.*betha')));


% Desnormalizo los pronosticos
pronosticoANN=[A_3_AANN;A_3_FANN];
pronosticoENN=[A_3_AENN;A_3_FENN];

%Obtener los valores que necesita la desnormalizacion
serie=datos(:,columnaSerie);
maximo=max(serie);
minimo=min(serie);
media=mean(serie);
desvest=std(serie);

%Desnormalizar todos los datos dependiendo del tipo de normalizacion que escoja
if tipoNormalizacion==1
    for i=1:size(pronosticoANN,1)
        annDesnormalizada(i,1)=((pronosticoANN(i,1)*(maximo-minimo))+minimo);
    end
end

if tipoNormalizacion==2
    for i=1:size(pronosticoANN,1)
        annDesnormalizada(i,1)=((pronosticoANN(i,1)*desvest)+media);
    end
end

if tipoNormalizacion==1
    for i=1:size(pronosticoENN,1)
        ennDesnormalizada(i,1)=((pronosticoENN(i,1)*(maximo-minimo))+minimo);
    end
end

if tipoNormalizacion==2
    for i=1:size(pronosticoENN,1)
        ennDesnormalizada(i,1)=((pronosticoENN(i,1)*desvest)+media);
    end
end

%Devolver la serie a nivel


for i=2:size(annDesnormalizada,1)
    annNivel(1,1)=datos(1,1);
    annNivel(i,1)=datos(i-1,1)*(1+annDesnormalizada(i,1));
end

for i=2:size(ennDesnormalizada,1)
    ennNivel(1,1)=datos(1,1);
    ennNivel(i,1)=datos(i-1,1)*(1+ennDesnormalizada(i,1));
end


%Agrupar las series
serieNivelDM=datos(1:numDentroMuestra,1);
serieNivelFM=datos(numDentroMuestra+1:numFueraMuestra,1);
serieCambiosDM=dentroMuestraNoLineal(:,1);
serieCambiosFM=fueraMuestraNoLineal(:,1);
serieNormalizadaDM=dentroMuestraNoLinealN(:,1);
serieNormalizadaFM=fueraMuestraNoLinealN(:,1);

pronosticoANNNivelDM=annNivel(1:numDentroMuestra,1);
pronosticoANNNivelFM=annNivel(numDentroMuestra+1:end,1)
pronosticoANNCambiosDM=annDesnormalizada(1:numDentroMuestra,:);
pronosticoANNCambiosFM=annDesnormalizada(numDentroMuestra+1:end,:);
pronosticoANNNormalizadaDM=A_3_AANN(:,1);
pronosticoANNNormalizadaFM=A_3_FANN(:,1);

pronosticoENNNivelDM=ennNivel(1:numDentroMuestra,1);
pronosticoENNNivelFM=ennNivel(numDentroMuestra+1:end,1);
pronosticoENNCambiosDM=ennDesnormalizada(1:numDentroMuestra,:);
pronosticoENNCambiosFM=ennDesnormalizada(numDentroMuestra+1:end,:);
pronosticoENNNormalizadaDM=A_3_AENN(:,1);
pronosticoENNNormalizadaFM=A_3_FENN(:,1);

for i=1:size(datos(:,1))
x(i,1)=i;    
end

for i=1:numFueraMuestra-numDentroMuestra
x1(i,1)=numDentroMuestra+i;    
end

size(serieNivelFM)
size(pronosticoANNNivelFM)
size(pronosticoENNNivelFM)

size(serieCambiosFM)
size(pronosticoANNCambiosFM)
size(pronosticoENNCambiosFM)

size(x1)

ANNNivel=sum(abs(serieNivelFM-pronosticoANNNivelFM))
ENNNivel=sum(abs(serieNivelFM-pronosticoENNNivelFM))


%Generar graficas
%Generar las graficas a nivel, cambios y normalizadas

figure(3)
subplot(3,2,1),
hold on
plot(serieNivelDM)
set(gca,'YLim',[0 2000])
plot(pronosticoANNNivelDM,'r')
plot(pronosticoENNNivelDM,'g')
title('Historico indice COL20 y ajuste dentro de muestra')
hleg1 = legend('Datos dentro de muestra','Ajuste RNA','Ajuste RNE');
hold off

subplot(3,2,2),
hold on
plot(serieNivelFM)
set(gca,'YLim',[0 2000])
plot(pronosticoANNNivelFM,'r')
plot(pronosticoENNNivelFM,'g')
title('Historico indice COL20 y desempeño fuera de muestra')
hleg2 = legend('Datos fuera de muestra','Pronostico RNA','Pronostico RNE');
hold off

subplot(3,2,3),
hold on
plot(serieCambiosDM)
plot(pronosticoANNCambiosDM,'r')
plot(pronosticoENNCambiosDM,'g')
title('Historico indice COL20 y ajuste dentro de muestra')
hleg1 = legend('Datos dentro de muestra','Ajuste RNA','Ajuste RNE');
hold off

subplot(3,2,4),
hold on
plot(serieCambiosFM)
plot(pronosticoANNCambiosFM,'r')
plot(pronosticoENNCambiosFM,'g')
title('Historico indice COL20 desempeño fuera de muestra')
hleg2 = legend('Datos fuera de muestra','Pronostico RNA','Pronostico RNE');
hold off

subplot(3,2,5),
hold on
plot(serieNormalizadaDM)
plot(pronosticoANNNormalizadaDM,'r')
plot(pronosticoENNNormalizadaDM,'g')
title('Historico indice COL20 y ajuste dentro de muestra')
hleg1 = legend('Datos dentro de muestra','Ajuste RNA','Ajuste RNE');
hold off

subplot(3,2,6),
hold on
plot(serieNormalizadaFM)
plot(pronosticoANNNormalizadaFM,'r')
plot(pronosticoENNNormalizadaFM,'g')
title('Historico indice COL20 y desempeño fuera de muestra')
hleg2 = legend('Datos fuera de muestra','Pronostico RNA','Pronostico RNE');
hold off


figure(4)
hold on
plot(serieNivelFM)
plot(pronosticoANNNivelFM,'r')
plot(pronosticoENNNivelFM,'g')
title('Historico indice COL20 y desempeño fuera de muestra')
hleg2 = legend('Indice COL20','Pronostico RNA','Pronostico RNE');
hold off

figure(5)
hold on
plot(x,datos(:,1),x1,pronosticoANNNivelFM,'r',x1,pronosticoENNNivelFM,'g')
title('Historico indice COL20 y desempeño fuera de muestra')
hleg2 = legend('Indice COL20','Pronostico RNA','Pronostico RNE');
hold off

listo=1;

end
