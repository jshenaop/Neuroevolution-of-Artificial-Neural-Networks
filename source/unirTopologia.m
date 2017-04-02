function [topologia] = unirTopologia(topologia)
%OBJETIVO: Unir la matriz de la topologia recomponiendola.
%COMPORTAMIENTO: El comando reshape la une en una sola fila.
%RETORNA: Una fila con la topologia inicial.

topologiaTemp=topologia';

topologia=[reshape(topologiaTemp,1,[])];

end

