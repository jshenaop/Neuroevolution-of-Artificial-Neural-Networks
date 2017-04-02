function llave=generarLlave(rezagosParteLineal,rezagosParteNoLineal,numeroNeuronas)
%OBJETIVO: Generar una llave que permita desagregar los pesos mas adelante. 
%COMPORTAMIENTO: Adquiere el numero de rezagos y neuronas.
%RETORNA: Retorna un vector con la informacion suficiente para separar las matrices.

numeroEntradas=size(rezagosParteNoLineal,2)+1;
parametrosLineales=size(rezagosParteLineal,2)+1;
parametrosConecciones=parametrosLineales+numeroNeuronas;
parametrosNeuronas=numeroNeuronas;
llave=[parametrosLineales parametrosConecciones numeroEntradas];

end