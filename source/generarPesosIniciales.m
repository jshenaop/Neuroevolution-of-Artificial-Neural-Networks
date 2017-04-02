function [parametros]=generarPesosIniciales(numeroCapasOcultas,numeroNeuronas,rezagosParteNoLineal,rezagosParteLineal,dentroMuestraNoLinealN,dentroMuestraLinealN)
%OBJETIVO: Generar los pesos sinapticos iniciales de la parte lineal como no lineal
%asi como la ponderacion de las neuronas.
%COMPORTAMIENTO: son capturadas las matrices que contienen informacion
%sobre los rezagos lineales y no lineales, el numero de neuronas.
%RETORNA: Las matrices phi, alpha y betha con los pesos iniciales.

%Obtener la cantidad de conecciones de la parte no lineal
numeroEntradas=size(rezagosParteNoLineal,2)+1;
%Pesos iniciales de la parte lineal se calculan MCO
phi=((dentroMuestraLinealN(:,2:end)'*dentroMuestraLinealN(:,2:end))^(-1))*(dentroMuestraLinealN(:,2:end)'*dentroMuestraLinealN(:,1));
%Generar los pesos para cada neurona con una distribucion uniforme entre -2 y 2
betha=-2+(2+2).*rand(1,numeroNeuronas);
%Generar los pesos para cada coneccion con una distribucion uniforme entre -2 y 2
alpha=-2+(2+2).*rand(1,numeroEntradas*numeroNeuronas);
%Transponer phi para que quede de la forma 1xX
phi=phi';
%Unir phi, alpha y betha para que quede un vector de 1xX
parametros=[phi alpha betha];

end

