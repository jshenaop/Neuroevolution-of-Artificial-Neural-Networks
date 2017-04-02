% Proyecto de Grado
% Red Neuronal Evolutiva
% Juan Sebastian Henao Parra
% Version 4.6

%% PREPARA EL ESPACIO DE TRABAJO PARA CALCULOS

%Carpeta
%cd('C:\Users\Sebastian\SkyDrive\Proyecto de Grado\source\source 4.0 (13-03-24)')

%Inicializacion
clear all; close all; clc

%% CREA PARAMETROS QUE SE UTILIZARAN

global datos columnaSerie columnaDesempeno tamanoHorizontes numeroHorizontes

%Definicion de tamaño de los horizontes y el numero horizontes 
tamanoHorizontes=100;
numeroHorizontes=30;

%Definicion del periodo a entrenar
periodoEntrenamiento=0.50;

%Definicion de la columna cargada que se usara y el numero de rezagos
columnaSerie=3;
rezagosParteLineal=[1 4 12 24 29];
rezagosParteNoLineal=[1 4 12 24 29];

%Definicion de la topologia
numeroCapasOcultas=1;
numeroNeuronas=4;

%Definicion numero de busquedas de la red neuronal artificial
numeroBusquedas=30;

%Definicion numero de neuroevoluciones
numeroNeuroEvoluciones=1;

%Tipo de funcion de costo
% 1 Para Cuadratica
% 2 Para Absoluta
% 3 Para LINEX
% 4 Para Absoluto Asimetrico
tipoFuncion=1;

%Tipo de normalizacion
% 1 Para MIN y MAX
% 2 Para Media y Desviacion Estandar
tipoNormalizacion=2;

%Algoritmmo de optimizacion
% 1 Para SIMPLEX
% 2 Para BFGS
% 3 Para Steppest Decent
algoOptim=2;

%Definicion de archivos para los resultados
seccionANN=0:numeroBusquedas:numeroBusquedas*(numeroNeuronas-1);
seccionRezagosANN=0:numeroBusquedas*numeroNeuronas:numeroBusquedas*numeroNeuronas*(size(rezagosParteNoLineal,2)-1);
numeroANNS=numeroBusquedas*numeroNeuronas*size(rezagosParteNoLineal,2);
seccionENN=0:numeroNeuroEvoluciones:numeroNeuroEvoluciones*(numeroNeuronas-1);
seccionRezagosENN=0:numeroNeuroEvoluciones*numeroNeuronas:numeroNeuroEvoluciones*numeroNeuronas*(size(rezagosParteNoLineal,2)-1);
numeroENNS=numeroNeuroEvoluciones*numeroNeuronas*size(rezagosParteNoLineal,2);

%% CREA LOS MONITORES

multiWaitbar( 'Calculando Horizontes ANN', 1/4, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
multiWaitbar( 'Calculando ANN', 2/4, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
multiWaitbar( 'Calculando Horizontes ENN', 3/4, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
multiWaitbar( 'Calculando ENN', 4/4, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );
multiWaitbar( 'Calculando Horizontes ANN', (0/(numeroHorizontes)));
multiWaitbar( 'Calculando ANN', (0/(numeroANNS)));
multiWaitbar( 'Calculando Horizontes ENN', (0/(numeroHorizontes)));
multiWaitbar( 'Calculando ENN', (0/(numeroENNS)));
h(1) = uicontrol ('String','Pause','Callback','uiwait','units','Normalized','Position',[0,0, 0.5, 1]);
h(2) = uicontrol ('String','Resume','Callback','uiresume','units','Normalized','Position',[0.5,0, 0.5, 1]);

%% CARGA ARCHIVOS CON DATOS
datos=xlsread('Datos','COL20');% Carga el archivo y la hoja mencionada

%% RED NEURONAL ARTIFICIAL

for numHorizonte=1:numeroHorizontes
    
    for numRezagosParteNoLineal=1:size(rezagosParteNoLineal,2)
        rezagosParteNoLinealTemp=rezagosParteNoLineal(:,1:numRezagosParteNoLineal);
        
        for numNeurona=1:numeroNeuronas
            
            for numBusqueda=1:numeroBusquedas
                
                % CREA TEMPORALMENTE LAS DIFERENTES MATRICES
                [dentroMuestraNoLineal, fueraMuestraNoLineal,...
                    dentroMuestraLineal, fueraMuestraLineal]=generarInput...
                    (rezagosParteNoLinealTemp,rezagosParteLineal,numHorizonte);
                [dentroMuestraNoLinealN, fueraMuestraNoLinealN,...
                    dentroMuestraLinealN, fueraMuestraLinealN]=generarInputNormalizado...
                    (rezagosParteNoLinealTemp,rezagosParteLineal,numHorizonte,tipoNormalizacion);
                
                % GENERA PESOS INICIALES, PHI, BETHA y ALPHA O TRAE LOS DE
                % HORIZONTES ANTERIORES
                if numHorizonte==1
                    [parametros]=generarPesosIniciales(numeroCapasOcultas,...
                        numNeurona,rezagosParteNoLinealTemp,rezagosParteLineal,...
                        dentroMuestraNoLinealN,dentroMuestraLinealN);
                else
                    cuboDatosTemp=cubosDatos(:,:,numRezagosParteNoLineal,numHorizonte-1);
                    [parametros,topologia]=generarPesosRolling...
                        (cuboDatosTemp,numBusqueda+seccionANN(1,numNeurona));
                end
                
                fullConected=ones(size(rezagosParteNoLinealTemp,2)+numeroCapasOcultas+1,numNeurona);
                llave=generarLlave(rezagosParteLineal,rezagosParteNoLinealTemp,numNeurona);
                
                % ENCUENTRA LOS PARAMETROS QUE MINIMIZAN LA FUNCION DE ERROR
                %options = optimset('Display','iter','TolFun',1e-8,'PlotFcns',@optimplotfval,'HessUpdate','bfgs','LargeScale','off');
                options=optimset('HessUpdate','bfgs','LargeScale','off','MaxFunEvals',1000000,'MaxIter',10000);
                [x,fval]=fminunc(@(parametros) funcionCosto(parametros,...
                    dentroMuestraNoLinealN,dentroMuestraLinealN,tipoFuncion,...
                    llave,numNeurona),parametros,options);
                
                % GUARDA LA INFORMACION EN UN CUBO
                [phi,betha,alpha]=separarMatrices(x,llave,numNeurona);
                [rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM] = ...
                    obtenerDesempeno(x,dentroMuestraLinealN,dentroMuestraNoLinealN,...
                    fueraMuestraLinealN,fueraMuestraNoLinealN,fullConected,...
                    llave,numNeurona);
                cubosDatos(numBusqueda+seccionANN(1,numNeurona),:,numRezagosParteNoLineal,...
                    numHorizonte)=[numBusqueda+seccionANN(1,numNeurona),numBusqueda,numNeurona,...
                    numRezagosParteNoLineal,numHorizonte,x,{fval},{phi},{betha},{alpha},{fullConected},...
                    {rezagosParteLineal},{rezagosParteNoLinealTemp},rmseDM,...
                    rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM];
                
                % GENERA UNA VENTANA PARA MONITOREAR EL AVANCE DEL PROGRAMA
                abort = multiWaitbar( 'Calculando ANN', (numBusqueda+seccionANN(1,numNeurona)+seccionRezagosANN(1,numRezagosParteNoLineal))/(numeroANNS));
                if abort
                    break
                else
                    pause( 1 )
                end
                
            end
        end
        
    end
    
    abort = multiWaitbar( 'Calculando Horizontes ANN', (numHorizonte/(numeroHorizontes)));
    if abort
        break
    else
        pause( 1 )
    end
    
end

%% RED NEURONAL EVOLUTIVA

for numHorizonte=1:numeroHorizontes
    
    for numRezagosParteNoLineal=1:size(rezagosParteNoLineal,2)
        rezagosParteNoLinealTemp=rezagosParteNoLineal(:,1:numRezagosParteNoLineal);
        
        for numNeurona=1:numeroNeuronas
            
            for numNeuroEvolucion=1:numeroNeuroEvoluciones
                
                % CREA TEMPORALMENTE LAS DIFERENTES MATRICES
                [dentroMuestraNoLineal, fueraMuestraNoLineal, dentroMuestraLineal,...
                    fueraMuestraLineal]=generarInput(rezagosParteNoLinealTemp,...
                    rezagosParteLineal,numHorizonte);
                [dentroMuestraNoLinealN, fueraMuestraNoLinealN, dentroMuestraLinealN,...
                    fueraMuestraLinealN]=generarInputNormalizado(rezagosParteNoLinealTemp,...
                    rezagosParteLineal,numHorizonte,tipoNormalizacion);
                
                % GENERA PESOS INICIALES, PHI, BETHA y ALPHA O TRAE LOS DE
                % HORIZONTES ANTERIORES
                if numHorizonte==1
                    [parametrosIniciales]=generarPesosIniciales(numeroCapasOcultas,...
                        numNeurona,rezagosParteNoLinealTemp,rezagosParteLineal,...
                        dentroMuestraNoLinealN,dentroMuestraLinealN);
                    [topologiaInicial]=unirTopologia(ones(size(rezagosParteNoLinealTemp,2)+...
                    numeroCapasOcultas+1,numNeurona));
                else
                    cuboDatosTemp=cubosDatosNeuroEvolucion(:,:,numRezagosParteNoLineal,numHorizonte-1);
                    [parametrosIniciales,topologiaInicial]=generarPesosRolling...
                        (cuboDatosTemp,numNeuroEvolucion+seccionENN(1,numNeurona))
                end
                
                fullConected=ones(size(rezagosParteNoLinealTemp,2)+...
                    numeroCapasOcultas+1,numNeurona);
                llave=generarLlave(rezagosParteLineal,rezagosParteNoLinealTemp,...
                    numNeurona);
                
                % NEUROEVOLUCION
                [parametrosMejorTopologia,mejorTopologia,costoMejorTopologia,...
                    ultimaGeneracion,cuboDesempeno]=algoritmoEvolutivo(parametrosIniciales,...
                    topologiaInicial,fullConected,numeroCapasOcultas,rezagosParteNoLinealTemp,...
                    rezagosParteLineal,dentroMuestraNoLinealN,dentroMuestraLinealN,...
                    fueraMuestraNoLinealN,fueraMuestraLinealN,dentroMuestraNoLineal,...
                    dentroMuestraLineal,fueraMuestraNoLineal,fueraMuestraLineal,tipoFuncion,numNeurona);
                
                %GUARDAR LA INFORMACION EN UN CUBO
                [phi,betha,alpha]=separarMatrices(parametrosMejorTopologia,...
                    llave,numNeurona);
                [rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM] =...
                    obtenerDesempeno(parametrosMejorTopologia,dentroMuestraLinealN,...
                    dentroMuestraNoLinealN,fueraMuestraLinealN,fueraMuestraNoLinealN,...
                    mejorTopologia,llave,numNeurona);
                cubosDatosNeuroEvolucion(numNeuroEvolucion+seccionENN(1,numNeurona),:,numRezagosParteNoLineal,...
                    numHorizonte)=[numNeuroEvolucion+seccionENN(1,numNeurona),numNeuroEvolucion,numNeurona,...
                    numRezagosParteNoLineal,numHorizonte,parametrosMejorTopologia,...
                    {costoMejorTopologia},{phi},{betha},{alpha},{mejorTopologia},...
                    {rezagosParteLineal},{rezagosParteNoLinealTemp},...
                    rmseDM,rmspeDM,maeDM,mapeDM,rmseFM,rmspeFM,maeFM,mapeFM];
                
                % GENERA UNA VENTANA PARA MONITOREAR EL AVANCE DEL PROGRAMA
                abort = multiWaitbar( 'Calculando ENN', (numNeuroEvolucion+seccionENN(1,numNeurona)+seccionRezagosENN(1,numRezagosParteNoLineal))/(numeroENNS));
                if abort
                    % Here we would normally ask the user if they're sure
                    break
                else
                    pause( 1 )
                end
                
            end
            
        end
        
    end
    
    abort = multiWaitbar( 'Calculando Horizontes ENN', (numHorizonte/(numeroHorizontes)));
    if abort
        break
    else
        pause( 1 )
    end
    
end

multiWaitbar( 'CloseAll' );

%% OBTIENE LAS MEJORES REDES Y LA MEJOR RED
%Las columnas de desempeño pueden ser 18 RMSE- 19 RMSPE- 20 MAE- 21 MAPE
numHorizonteEval=30;
columnaDesempeno=20;

for numHorizonteEval=1:30
[mejorANN,matrizDatos] = obtenerMejorRed(size(rezagosParteNoLineal,2),cubosDatos(:,:,:,numHorizonteEval));
mejorANNHorizonte(numHorizonteEval,:) = mejorANN
[mejorENN,matrizDatosNeuroEvolucion] = obtenerMejorRed(size(rezagosParteNoLineal,2),cubosDatosNeuroEvolucion(:,:,:,numHorizonteEval));
mejorENNHorizonte(numHorizonteEval,:) = mejorENN
end

% [mejorANN,matrizDatos] = obtenerMejorRed(size(rezagosParteNoLineal,2),cubosDatos(:,:,:,numHorizonteEval));
% [mejorENN,matrizDatosNeuroEvolucion] = obtenerMejorRed(size(rezagosParteNoLineal,2),cubosDatosNeuroEvolucion(:,:,:,numHorizonteEval));

%% GUARDA LOS DATOS EN UN ARCHIVO
formatOut = 'mm-dd-yy';
datestr(now,formatOut);
filenameNN = sprintf('Datos guardados con %d neuronas el', numeroNeuronas);
filenameDD = sprintf(datestr(now,formatOut));
filename = strcat(filenameNN,'_', filenameDD);
save(filename);

%% GENERA GRAFICAS
% generarGraficas(mejorANN,mejorENN,rezagosParteNoLineal,rezagosParteLineal,numHorizonte)
%generarOutput(mejorANN,mejorENN,tipoNormalizacion)
generarOutputTotal(mejorANN,mejorENN,tipoNormalizacion)

%% GENERA PESOS DE TODO EL PERIODO DE PRUEBA
[medidasEvalANN, medidasEvalENN] = obtenerDesempenoTotal(mejorANNHorizonte,mejorENNHorizonte,tipoNormalizacion)
