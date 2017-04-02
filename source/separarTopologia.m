function [topologia] = separarTopologia(poblacion,llave,numeroNeuronas)
%OBJETIVO: Separar la topologia requerida retornando una matriz.
%COMPORTAMIENTO: Convierte la fila poblacion en una matriz.
%RETORNA: La matriz con la topologia.

numeroEntradas=llave(1,3)+1;

poblacion=poblacion';
b=reshape(poblacion,numeroNeuronas,numeroEntradas);
topologia=b';

end

