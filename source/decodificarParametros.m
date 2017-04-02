function [parametrosPoblacionDec,poblacionDec]=decodificarParametros(poblacion,parametrosPoblacionCod,numeroRezagos)
%OBJETIVO: Decodificar la poblacion devolviendo un vector de parametros aumentado donde las unidades
%de la topologia que sean ceros sean recompuestas nuevamente como ceros.
%COMPORTAMIENTO: Recibe los parametros codificadas y recibe la topologia segun la 
%topologia agrega ceros a los parametros no conectados.
%RETORNA: Parametros decodificados y la poblacion decodificada.

parametrosPoblacionDec=zeros(1,(numeroRezagos+1)+size(poblacion,2));
poblacionNueva=[ones(1,(numeroRezagos+1)) poblacion];

for i=1:size(poblacionNueva,2)
    if poblacionNueva(1,i)==1
        indicador(1,i)=i;
    end
end

indicador=indicador(indicador ~= 0);

for ii=1:size(parametrosPoblacionCod,2)
    
    if indicador(1,ii) ~= 0
        parametrosPoblacionDec(1,indicador(1,ii))=parametrosPoblacionCod(1,ii);
    end
    
end

poblacionDec=poblacion;

end