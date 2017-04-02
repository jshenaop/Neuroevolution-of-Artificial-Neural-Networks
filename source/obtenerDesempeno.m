function [rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM] = obtenerDesempeno(parametros,dentroMuestraLinealN,dentroMuestraNoLinealN,fueraMuestraLinealN,fueraMuestraNoLinealN,topologia,llave,numeroNeuronas)
%OBJETIVO: Obtener el desempeño dentro y fuera de muestra de unos parametros y una
% topologia dada.
%COMPORTAMIENTO: Son capturadas las matrices que contienen los datos, los parametros y
%las neuronas.
%RETORNA: Los valores rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM.

%Obtiene el desempeño calculando las medidas
[phi,betha,alpha]=separarMatrices(parametros,llave,numeroNeuronas);

if size(topologia,1)==1
topologia=separarTopologia(topologia,llave,numeroNeuronas);
end

%Ajuste 
A_1_AD=dentroMuestraNoLinealN(:,2:end);
Z_2_AD=A_1_AD*(topologia(1:end-1,:).*alpha);
A_2_AD=sigmoid(Z_2_AD);
A_3_AD=(dentroMuestraLinealN(:,2:end)*phi')+(A_2_AD*((topologia(end:end,:)'.*betha')));

%Pronostico
A_1_FO=fueraMuestraNoLinealN(:,2:end);
Z_2_FO=A_1_FO*(topologia(1:end-1,:).*alpha);
A_2_FO=sigmoid(Z_2_FO);
A_3_FO=(fueraMuestraLinealN(:,2:end)*phi')+(A_2_FO*((topologia(end:end,:)'.*betha')));

%%%%%%%%%%%%%%%%%%%%%%%% ESPACIO PARA DESEMPEÑO %%%%%%%%%%%%%%%%%%%%%%%%%%%

nDM=size(dentroMuestraLinealN,1);
nFM=size(fueraMuestraLinealN,1);

rmseDM=sqrt((1/nDM)*sum((dentroMuestraNoLinealN(:,1)-A_3_AD).^2));
rmspeDM=sqrt((1/nDM)*sum(((dentroMuestraNoLinealN(:,1)-A_3_AD)./dentroMuestraNoLinealN(:,1)).^2));
maeDM=(1/nDM)*sum(abs(dentroMuestraNoLinealN(:,1)-A_3_AD));
mapeDM=(1/nDM)*sum(abs((dentroMuestraNoLinealN(:,1)-A_3_AD)./dentroMuestraNoLinealN(:,1)));

rmseFM=sqrt((1/nFM)*sum((fueraMuestraNoLinealN(:,1)-A_3_FO).^2));
rmspeFM=sqrt((1/nFM)*sum(((fueraMuestraNoLinealN(:,1)-A_3_FO)./fueraMuestraNoLinealN(:,1)).^2));
maeFM=(1/nFM)*sum(abs(fueraMuestraNoLinealN(:,1)-A_3_FO));
mapeFM=(1/nFM)*sum(abs((fueraMuestraNoLinealN(:,1)-A_3_FO)./fueraMuestraNoLinealN(:,1)));

end

