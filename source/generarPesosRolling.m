function [parametros,topologia]=generarPesosRolling(cuboDatosTemp,numEval)
%OBJETIVO: Extraer los parametros resultantes de la parte lineal como no lineal
%asi como de las neuronas.
%COMPORTAMIENTO: Dado el numero de evaluacion retorna los parametros y la
%topologia.
%RETORNA: Los vectores de parametros y la topologia.

parametros=cell2mat(cuboDatosTemp(numEval,6,1));

topologia=unirTopologia(cell2mat(cuboDatosTemp(numEval,11,1)));
  
end

