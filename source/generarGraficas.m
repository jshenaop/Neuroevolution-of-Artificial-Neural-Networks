function listo = generarGraficas(mejorANN,mejorENN,rezagosParteNoLineal,rezagosParteLineal,numHorizonte)
%OBJETIVO: Generar las graficas de las mejores redes. 
%COMPORTAMIENTO: Las redes ingresan en una columna, se extrae los datos de cada una
%y se grafica.
%RETORNA: Devuelve las graficas y los valores para verificar las redes.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

numeroNeuronas=cell2mat(mejorANN(1,3))
numHorizonte=cell2mat(mejorANN(1,5))
phi=cell2mat(mejorANN(1,8))
betha=cell2mat(mejorANN(1,9))
alpha=cell2mat(mejorANN(1,10))
topologia=cell2mat(mejorANN(1,11))
rezagosParteLineal=cell2mat(mejorANN(1,12));
rezagosParteNoLineal=cell2mat(mejorANN(1,13));
tipoNormalizacion=1;

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

%%%%%%%%%%%%%%%%%%%%%%%% ESPACIO PARA DESEMPEÑO %%%%%%%%%%%%%%%%%%%%%%%%%%%

nDM=size(dentroMuestraLinealN,1);
nFM=size(fueraMuestraLinealN,1);

rmseDM=sqrt((1/nDM)*sum((dentroMuestraNoLinealN(:,1)-A_3_AANN).^2));
rmspeDM=sqrt((1/nDM)*sum(((dentroMuestraNoLinealN(:,1)-A_3_AANN)./dentroMuestraNoLinealN(:,1)).^2));
maeDM=(1/nDM)*sum(abs(dentroMuestraNoLinealN(:,1)-A_3_AANN));
mapeDM=(1/nDM)*sum(abs((dentroMuestraNoLinealN(:,1)-A_3_AANN)./dentroMuestraNoLinealN(:,1)));

rmseFM=sqrt((1/nFM)*sum((fueraMuestraNoLinealN(:,1)-A_3_FANN).^2));
rmspeFM=sqrt((1/nFM)*sum(((fueraMuestraNoLinealN(:,1)-A_3_FANN)./fueraMuestraNoLinealN(:,1)).^2));
maeFM=(1/nFM)*sum(abs(fueraMuestraNoLinealN(:,1)-A_3_FANN));
mapeFM=(1/nFM)*sum(abs((fueraMuestraNoLinealN(:,1)-A_3_FANN)./fueraMuestraNoLinealN(:,1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numeroNeuronas=cell2mat(mejorENN(1,3))
numHorizonte=cell2mat(mejorENN(1,5))
phi=cell2mat(mejorENN(1,8))
betha=cell2mat(mejorENN(1,9))
alpha=cell2mat(mejorENN(1,10))
topologia=cell2mat(mejorENN(1,11))
rezagosParteLineal=cell2mat(mejorENN(1,12));
rezagosParteNoLineal=cell2mat(mejorENN(1,13));

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

%%%%%%%%%%%%%%%%%%%%%%%% ESPACIO PARA DESEMPEÑO %%%%%%%%%%%%%%%%%%%%%%%%%%%

nDM=size(dentroMuestraLinealN,1);
nFM=size(fueraMuestraLinealN,1);

rmseDM=sqrt((1/nDM)*sum((dentroMuestraNoLinealN(:,1)-A_3_AENN).^2));
rmspeDM=sqrt((1/nDM)*sum(((dentroMuestraNoLinealN(:,1)-A_3_AENN)./dentroMuestraNoLinealN(:,1)).^2));
maeDM=(1/nDM)*sum(abs(dentroMuestraNoLinealN(:,1)-A_3_AENN));
mapeDM=(1/nDM)*sum(abs((dentroMuestraNoLinealN(:,1)-A_3_AENN)./dentroMuestraNoLinealN(:,1)));

rmseFM=sqrt((1/nFM)*sum((fueraMuestraNoLinealN(:,1)-A_3_FENN).^2));
rmspeFM=sqrt((1/nFM)*sum(((fueraMuestraNoLinealN(:,1)-A_3_FENN)./fueraMuestraNoLinealN(:,1)).^2));
maeFM=(1/nFM)*sum(abs(fueraMuestraNoLinealN(:,1)-A_3_FENN));
mapeFM=(1/nFM)*sum(abs((fueraMuestraNoLinealN(:,1)-A_3_FENN)./fueraMuestraNoLinealN(:,1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
subplot(1,2,1),
hold on
plot(dentroMuestraNoLinealN(:,1))
plot(A_3_AANN(:,1),'r')
plot(A_3_AENN(:,1),'g')
title('In Sample o Entrenamiento')
hleg1 = legend('DM','AANN','AENN');
hold off
subplot(1,2,2),
hold on
plot(fueraMuestraNoLinealN(:,1))
plot(A_3_FANN(:,1),'r')
plot(A_3_FENN(:,1),'g')
title('Out Sample o Pronostico')
hleg2 = legend('FM','FANN','FENN');
hold off

listo=1;

end