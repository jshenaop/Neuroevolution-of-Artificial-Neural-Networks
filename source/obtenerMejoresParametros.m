function [parametros] = obtenerMejoresParametros(cuboDatos,numeroHorizonte,numeroRezagos,numeroNeuronas)
%OBJETIVO: Obtener y unir los parametros de la mejor red de dicho horizonte. 
%COMPORTAMIENTO: Del cubo de datos se extraen .
%RETORNA: Una matriz con la mejor red por cada rezago adicional devuelve
%la mejor red.

global columnaDesempeno

cuboFiltrado=cuboDatos(:,:,numeroRezagos,numeroHorizonte);
cuboFiltrado = cuboFiltrado(cell2mat(cuboFiltrado(:, 3)) == numeroNeuronas,:);
mejorRed=sortrows(cuboFiltrado,columnaDesempeno);
mejorRed=mejorRed(1,:);
phi=cell2mat(mejorRed(1,6));
betha=cell2mat(mejorRed(1,7));
alpha=cell2mat(mejorRed(1,8));

[parametros] = unirMatrices(phi,betha,alpha);

end

