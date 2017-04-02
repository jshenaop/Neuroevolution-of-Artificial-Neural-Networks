function [parametrosPoblacionCod,poblacionCod]=codificarParametros(poblacion,parametrosPoblacion,numeroRezagos)
%OBJETIVO: COdificar un vector de parametros devolviendo el vector reducido
%donde todos las unidades de la topologia que sean ceros sean eliminadas.
%COMPORTAMIENTO: Recibe los parametros y recibe la topologia segun la 
%topologia elimina los parametros no necesarios.
%RETORNA: Parametros codificados y la pobacion que se uso para la codificacion.

for i=1:numeroRezagos+1
    
    indicador(i)=i;
    
end


for i=1:size(poblacion,2)
    
    if poblacion(1,i)==1
        indicador(i+numeroRezagos+1)=i+numeroRezagos+1;
        indicador=indicador(indicador ~= 0);
    end
    
end

parametrosPoblacionCod=parametrosPoblacion(1,indicador);
poblacionCod=poblacion;

end