function [parametrosMejorTopologia,mejorTopologia,costoMejorTopologia,ultimaGeneracion,cuboDesempeno] = algoritmoGenetico(parametrosIniciales,topologiaInicial,topologia,numeroCapasOcultas,rezagosParteNoLineal,rezagosParteLineal,dentroMuestraNoLinealN,dentroMuestraLinealN,fueraMuestraNoLinealN,fueraMuestraLinealN,dentroMuestraNoLineal,dentroMuestraLineal,fueraMuestraNoLineal,fueraMuestraLineal,tipoFuncion,numeroNeuronas)
%OBJETIVO: El algoritmo genetico realiza evaluacion del desempe�o, cruce 
%mutacion hasta el numero de generaciones dado.
%COMPORTAMIENTO: Remitirse a un texto especialisado
%RETORNA: Retorna los parametros de la mejor topologia, la mejor Topologia, 
%el costo de esta una matriz mostrando la ultima generacion y un cubo mostrando
%la evolucion entre generaciones.

%Define los paremetros del Algoritmo Genetico
numeroBits=size(topologia,1)*size(topologia,2);
numeroCromosomas=10;
numeroGeneraciones=5;
numeroPadres=2;
tasaMutacion=0.01;
numeroMutaciones=tasaMutacion*numeroBits*(numeroCromosomas-1);

%Crea el numero de cromosomas aleatorios para la topologia
poblacion=round(rand(numeroCromosomas,numeroBits));

%Crea un numero de pesos iniciales para la primera generacion
for numCromosomas=1:numeroCromosomas
   
    parametrosPoblacion(numCromosomas,:)=generarPesosIniciales(numeroCapasOcultas,numeroNeuronas,rezagosParteNoLineal,rezagosParteLineal,dentroMuestraNoLinealN,dentroMuestraLinealN);
    llave=generarLlave(rezagosParteLineal,rezagosParteNoLineal,numeroNeuronas);
    
end

%Inserta topologias y parametros
poblacion(1,:)=ones(1,numeroBits);
poblacion(2,:)=topologiaInicial;
parametrosPoblacion(2,:)=parametrosIniciales;

%Crea matrices vacias y obtiene informacion para el Algoritmo Genetico
numeroRezagos=size(rezagosParteLineal,2);
costo=zeros(numeroCromosomas,1);

%Comienza el Algoritmo Genetico

for ib=1:numeroGeneraciones
    
    for i=1:numeroCromosomas
        
        %Evalua la poblacion creada
        %Codifica
        [parametrosPoblacionCod,poblacionCod]=codificarParametros(poblacion(i,:),parametrosPoblacion(i,:),numeroRezagos);
        %Evalua
        costo=funcionCostoTopologia(parametrosPoblacionCod,poblacionCod,dentroMuestraNoLinealN,dentroMuestraLinealN,tipoFuncion,llave,numeroNeuronas,numeroRezagos);
        desempeno(i,1)=costo;
        %Decodifica
        [parametrosPoblacionDec,poblacionDec]=decodificarParametros(poblacionCod,parametrosPoblacionCod,numeroRezagos);
        parametrosPoblacion(i,:)=parametrosPoblacionDec;
        cuboDesempeno=1;
        
    end
    
    %Organiza los mejores cromosomas por su desempe�o
    [desempeno,ind]=sortrows(desempeno,1);
    poblacion=poblacion(ind(1:numeroPadres),:);
    parametrosPoblacion=parametrosPoblacion(ind(1:numeroPadres),:);
    [ib desempeno(1)];
    
    %Pone las ristras que seran crusadas
    cruce=ceil((numeroBits-1)*rand(numeroCromosomas-numeroPadres,1));
    cruceLineal=ceil((numeroRezagos-1)*rand(numeroCromosomas-numeroPadres,1));
    
    %Obtiene la decendencia de los padres
    for ic=numeroPadres+1:2:numeroCromosomas
       
        %Obtiene la topologia de los hijos
        poblacion(ic,1:cruce)=poblacion(1,1:cruce);
        poblacion(ic,cruce+1:numeroBits)=poblacion(2,cruce+1:numeroBits);
        poblacion(ic+1,1:cruce)=poblacion(2,1:cruce);
        poblacion(ic+1,cruce+1:numeroBits)=poblacion(1,cruce+1:numeroBits);
        %Obtiene los parametros de los hijos en la parte no lineal
        parametrosPoblacion(ic,numeroRezagos+1:numeroRezagos+cruce)=parametrosPoblacion(1,numeroRezagos+1:numeroRezagos+cruce);
        parametrosPoblacion(ic,numeroRezagos+cruce+1:end)=parametrosPoblacion(2,numeroRezagos+cruce+1:end);
        parametrosPoblacion(ic+1,numeroRezagos+1:numeroRezagos+cruce)=parametrosPoblacion(2,numeroRezagos+1:numeroRezagos+cruce);
        parametrosPoblacion(ic+1,numeroRezagos+cruce+1:end)=parametrosPoblacion(1,numeroRezagos+cruce+1:end);
        %Obtiene los parametros de los hijos en la parte lineal
        parametrosPoblacion(ic,1:cruceLineal)=parametrosPoblacion(1,1:cruceLineal);
        parametrosPoblacion(ic,cruceLineal+1:numeroRezagos)=parametrosPoblacion(2,cruceLineal+1:numeroRezagos);
        parametrosPoblacion(ic+1,1:cruceLineal)=parametrosPoblacion(2,1:cruceLineal);
        parametrosPoblacion(ic+1,cruceLineal+1:numeroRezagos)=parametrosPoblacion(1,cruceLineal+1:numeroRezagos); 
        
    end
    
    %Muta solo a los hijos y si no es la ultima generacion
    if ib~=numeroGeneraciones
        for ic=1:numeroMutaciones
            %Muta la topologia
            ix=ceil((numeroPadres)+(numeroCromosomas-(numeroPadres))*rand);
            iy=ceil(numeroBits*rand);
            poblacion(ix,iy)=1-poblacion(ix,iy);
            %Muta los pesos en la parte no lineal
            ix=ceil((numeroPadres)+(numeroCromosomas-(numeroPadres))*rand);
            iy=ceil((numeroRezagos)+(numeroCromosomas-(numeroRezagos))*rand);
            parametrosPoblacion(ix,iy)=(-2+(2+2).*rand);
        end
    end
end


%Obtengo la ultima generacion obtengo su desempe�o
for ii=1:numeroCromosomas

    [rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM] = obtenerDesempeno(parametrosPoblacion(ii,:),dentroMuestraLinealN,dentroMuestraNoLinealN,fueraMuestraLinealN,fueraMuestraNoLinealN,poblacion(ii,:),llave,numeroNeuronas);
    [parametrosPoblacionCod,poblacionCod]=codificarParametros(poblacion(ii,:),parametrosPoblacion(ii,:),numeroRezagos);
    costo=funcionCostoTopologia(parametrosPoblacionCod,poblacion(ii,:),dentroMuestraNoLinealN,dentroMuestraLinealN,tipoFuncion,llave,numeroNeuronas,numeroRezagos);
    almacenDatos(ii,:)=[ii,rmseFM,costo,{poblacion(ii,:)},parametrosPoblacion(ii,:)];
    ultimaGeneracion=almacenDatos;
    
end

%Organizo la ultima generacion por su desempe�o y devuelvo los valores
ultimaGeneracion=sortrows(ultimaGeneracion, 2);
resultadoOpt=ultimaGeneracion(1,:);
parametrosMejorTopologia=cell2mat(resultadoOpt(1,5));
mejorTopologia=cell2mat(resultadoOpt(1,4));
mejorTopologia=separarTopologia(mejorTopologia,llave,numeroNeuronas);
costoMejorTopologia=cell2mat(resultadoOpt(1,3));

end

