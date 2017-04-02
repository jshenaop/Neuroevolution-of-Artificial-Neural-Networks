function [dentroMuestraNoLineal, fueraMuestraNoLineal, dentroMuestraLineal, fueraMuestraLineal]=generarInput(rezagosParteNoLineal,rezagosParteLineal,numHorizonte)
%OBJETIVO: Generar las matrices de diseño necesarias. 
%COMPORTAMIENTO: Son capturadas las matrices donde se almacenan los rezagos de la parte
%lineal como de la no lineal, los datos y el numero de la columna que se usara.
%RETORNA: Las matrices de diseño necesarias.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

%Obtener los valores que necesita la funcion
serie=datos(:,columnaSerie);
numRezagosParteNoLineal=size(rezagosParteNoLineal,2);
numRezagosParteLineal=size(rezagosParteLineal,2);
numPeriodos=size(datos,1);
numDentroMuestra=numPeriodos-tamanoHorizontes-(numeroHorizontes-numHorizonte);
numFueraMuestra=numPeriodos-(numeroHorizontes-numHorizonte);
nuevosDatosParteNoLineal=zeros(numPeriodos,numRezagosParteNoLineal);
nuevosDatosParteLineal=zeros(numPeriodos,numRezagosParteLineal);

%Remplazar los valores dentro de la matriz vacia de la parte no lineal
for i=1:numRezagosParteNoLineal
    for m=1:numPeriodos-rezagosParteNoLineal(1,i)
        nuevosDatosParteNoLineal(m+rezagosParteNoLineal(1,i),i)=serie(m);
    end
end

%Remplazar los valores dentro de la matriz vacia de la parte lineal
for i=1:numRezagosParteLineal
    for m=1:numPeriodos-rezagosParteLineal(1,i)
        nuevosDatosParteLineal(m+rezagosParteLineal(1,i),i)=serie(m);
    end
end

nuevosDatosParteNoLineal=[serie(1:numFueraMuestra,:) nuevosDatosParteNoLineal(1:numFueraMuestra,:)];
nuevosDatosParteLineal=[serie(1:numFueraMuestra,:) nuevosDatosParteLineal(1:numFueraMuestra,:)];

% Crear 4 matrices de ceros para llenarlas con lo nuevos datos
dentroMuestraNoLineal=nuevosDatosParteNoLineal(1:numDentroMuestra,:);
fueraMuestraNoLineal=nuevosDatosParteNoLineal(numDentroMuestra+1:numFueraMuestra,:);
dentroMuestraLineal=nuevosDatosParteLineal(1:numDentroMuestra,:);
fueraMuestraLineal=nuevosDatosParteLineal(numDentroMuestra+1:numFueraMuestra,:);

%Organizar las matrices y les agrego el intercepto
dentroMuestraNoLineal= [dentroMuestraNoLineal(:,1) ones(size(dentroMuestraNoLineal,1),1) dentroMuestraNoLineal(:,2:end)];
dentroMuestraLineal= [dentroMuestraLineal(:,1) ones(size(dentroMuestraLineal,1),1) dentroMuestraLineal(:,2:end)];
fueraMuestraNoLineal= [fueraMuestraNoLineal(:,1) ones(size(fueraMuestraNoLineal,1),1) fueraMuestraNoLineal(:,2:end)];
fueraMuestraLineal= [fueraMuestraLineal(:,1) ones(size(fueraMuestraLineal,1),1) fueraMuestraLineal(:,2:end)];

end
