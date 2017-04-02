function [phi,betha,alpha] = separarMatrices(parametros,llave,numeroNeuronas)
%OBJETIVO: Separar las matrices phi, alpha y betha las cuales representan 
%los pesos de cada una de las conecciones.
%COMPORTAMIENTO: Convierte la fila parametros en 3 matrices.
%RETORNA: La matriz phi parte lineal, la matriz alpha pesos de las neuronas
% y betha que son los pesos sinapticos.

numeroEntradas=llave(1,3);
numeroNeuronas;
phi=parametros(:,1:llave(1,1));

matrizTemp=parametros(:,llave(1,1)+1:end);

matrizTemp=matrizTemp';
b=reshape(matrizTemp,numeroNeuronas,numeroEntradas+1);
matrizTemp=b';

alpha=matrizTemp(1:end-1,:);
betha=matrizTemp(end:end,:);

end

