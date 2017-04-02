function [dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN, fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLineal,rezagosParteLineal,numHorizonte,tipoNormalizacion)
%OBJETIVO: Generar las matrices de diseño normalizadas necesarias. 
%COMPORTAMIENTO: Son capturadas las matrices donde se almacenan los rezagos de la parte
%lineal como de la no lineal, los datos y el numero de la columna que se usara.
%RETORNA: Las matrices de diseño necesarias.

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

%Obtener los valores que necesita la funcion
serie=datos(:,columnaSerie);
maximo=max(serie);
minimo=min(serie);
media=mean(serie);
desvest=std(serie);

%Normalizar todos los datos dependiendo del tipo de normalizacion que escoja
if tipoNormalizacion==1
    for i=1:size(serie,1)
        serieNormalizada(i,1)=(serie(i,1)-minimo)/(maximo-minimo);
    end
end

if tipoNormalizacion==2
    for i=1:size(serie,1)
        serieNormalizada(i,1)=(serie(i,1)-media)/(desvest);
    end
end

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
        nuevosDatosParteNoLineal(m+rezagosParteNoLineal(1,i),i)=serieNormalizada(m);
    end
end

%Remplazar los valores dentro de la matriz vacia de la parte lineal
for i=1:numRezagosParteLineal
    for m=1:numPeriodos-rezagosParteLineal(1,i)
        nuevosDatosParteLineal(m+rezagosParteLineal(1,i),i)=serieNormalizada(m);
    end
end

nuevosDatosParteNoLineal=[serieNormalizada(1:numFueraMuestra,:) nuevosDatosParteNoLineal(1:numFueraMuestra,:)];
nuevosDatosParteLineal=[serieNormalizada(1:numFueraMuestra,:) nuevosDatosParteLineal(1:numFueraMuestra,:)];

% Crear 4 matrices de ceros para llenarlas con lo nuevos datos
dentroMuestraNoLinealN=nuevosDatosParteNoLineal(1:numDentroMuestra,:);
fueraMuestraNoLinealN=nuevosDatosParteNoLineal(numDentroMuestra+1:numFueraMuestra,:);
dentroMuestraLinealN=nuevosDatosParteLineal(1:numDentroMuestra,:);
fueraMuestraLinealN=nuevosDatosParteLineal(numDentroMuestra+1:numFueraMuestra,:);

%Organizar las matrices y les agrego el intercepto
dentroMuestraNoLinealN= [dentroMuestraNoLinealN(:,1) ones(size(dentroMuestraNoLinealN,1),1) dentroMuestraNoLinealN(:,2:end)];
dentroMuestraLinealN= [dentroMuestraLinealN(:,1) ones(size(dentroMuestraLinealN,1),1) dentroMuestraLinealN(:,2:end)];
fueraMuestraNoLinealN= [fueraMuestraNoLinealN(:,1) ones(size(fueraMuestraNoLinealN,1),1) fueraMuestraNoLinealN(:,2:end)];
fueraMuestraLinealN= [fueraMuestraLinealN(:,1) ones(size(fueraMuestraLinealN,1),1) fueraMuestraLinealN(:,2:end)];

end
