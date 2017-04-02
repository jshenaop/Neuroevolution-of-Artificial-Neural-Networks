function [parametros] = unirMatrices(phi,betha,alpha)
%OBJETIVO: Unir las matrices phi, alpha y betha para ser introducidas
%en la funcion de costo.
%COMPORTAMIENTO: El comando reshape las une en una sola fila.
%RETORNA: Una fila con los parametros.

alpha=alpha';

parametros=[reshape(phi,1,[]) reshape(alpha,1,[]) reshape(betha,1,[]) ];

end

