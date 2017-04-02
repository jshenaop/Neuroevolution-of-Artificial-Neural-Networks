function [medidasEvalANN, medidasEvalENN] = obtenerDesempenoTotal(mejorANNHorizonte,mejorENNHorizonte,tipoNormalizacion)
%OBJETIVO: Generar las matrices de diseño normalizadas necesarias. 
%COMPORTAMIENTO: Son capturadas las matrices donde se almacenan los rezagos de la parte
%lineal como de la no lineal, los datos y el numero de la columna que se usara.
%RETORNA: Las matrices de diseño necesarias.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

%Obtengo los datos que necesita la funcion
numPeriodos=size(datos,1);

for i=1:numeroHorizontes
    
    mejorANN=mejorANNHorizonte(i,:)
    
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
        rezagosParteLineal,30);
    [dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN,...
        fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLineal,...
        rezagosParteLineal,30,tipoNormalizacion);
    
    serieCompletaLineal=[dentroMuestraLinealN;fueraMuestraLinealN];
    serieCompletaNoLineal=[dentroMuestraNoLinealN;fueraMuestraNoLinealN];
    
    size(serieCompletaLineal)
    size(serieCompletaNoLineal)
    
    dentroMuestraLinealN=serieCompletaLineal(1:848,:);
    fueraMuestraLinealN=serieCompletaLineal(849:end,:);
    dentroMuestraNoLinealN=serieCompletaNoLineal(1:848,:);
    fueraMuestraNoLinealN=serieCompletaNoLineal(849:end,:);
    
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
    nFM=size(fueraMuestraLinealN,1);
      
    rmseFMANN=sqrt((1/nFM)*sum((fueraMuestraNoLinealN(:,1)-A_3_FANN).^2));
    maeFMANN=(1/nFM)*sum(abs(fueraMuestraNoLinealN(:,1)-A_3_FANN));
        
    medidasEvalANN(i,:)=[{rmseFMANN},{maeFMANN}]
    
end

for i=1:numeroHorizontes
    
    mejorENN=mejorENNHorizonte(i,:)
    
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
        rezagosParteLineal,30);
    [dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN,...
        fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLineal,...
        rezagosParteLineal,30,tipoNormalizacion);
    
    serieCompletaLineal=[dentroMuestraLinealN;fueraMuestraLinealN];
    serieCompletaNoLineal=[dentroMuestraNoLinealN;fueraMuestraNoLinealN];
    
    size(serieCompletaLineal)
    size(serieCompletaNoLineal)
    
    dentroMuestraLinealN=serieCompletaLineal(1:848,:);
    fueraMuestraLinealN=serieCompletaLineal(849:end,:);
    dentroMuestraNoLinealN=serieCompletaNoLineal(1:848,:);
    fueraMuestraNoLinealN=serieCompletaNoLineal(849:end,:);
    
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
    nFM=size(fueraMuestraLinealN,1);
      
    rmseFMENN=sqrt((1/nFM)*sum((fueraMuestraNoLinealN(:,1)-A_3_FENN).^2));
    maeFMENN=(1/nFM)*sum(abs(fueraMuestraNoLinealN(:,1)-A_3_FENN));
        
    medidasEvalENN(i,:)=[{rmseFMENN},{maeFMENN}]
    
end

end

