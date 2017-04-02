function [mejorRed,matrizDatos] = obtenerMejorRed(numeroRezagos,cuboDatos)
%OBJETIVO: Obtener la mejor por cada rezago incluido y guardarla en una matriz para luego 
%obtener la mejor, esto se asemeja a una reduccion de dimenciones. 
%COMPORTAMIENTO: Las mejores por cada pagina son capturadas y puestas en
%matrizDatos donde nuevamente se organizara y se obtendra la mejor.
%RETORNA: Una matriz con la mejor red por cada rezago adicional devuelve
%la mejor red.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

for numRezago=1:numeroRezagos
    matrizTemp=cuboDatos(:,:,numRezago);
    desempenoRezago=sortrows(matrizTemp,columnaDesempeno);
    matrizDatos(numRezago,:)=desempenoRezago(1,:);
end

matrizDatos = sortrows(matrizDatos,columnaDesempeno);
mejorRed=matrizDatos(1,:);

end

