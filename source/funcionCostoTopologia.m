function [costo,topologia]=funcionCostoTopologia(parametros,poblacion,dentroMuestraNoLinealN,dentroMuestraLinealN,tipoFuncion,llave,numeroNeuronas,numeroRezagos)
%OBJETIVO: Devolver el valor de la funcion de costo para unos parametros dados
%unas matrices de diseño Normalizadas, una topologia y se calculara en cierto 
%tipo de funcion que se requiera.
%COMPORTAMIENTO: Segun el tipo de funcion,la topologia y los parametros separados de
%phi,alpha y betha se calcula el costo.
%RETORNA: El costo de la funcion.

%Decodifico los parametros
[parametros,poblacion]=decodificarParametros(poblacion,parametros,numeroRezagos);

%Recostruyo las matrices de parametros y la matriz de topologia
m=size(dentroMuestraNoLinealN,1);
[phi,betha,alpha]=separarMatrices(parametros,llave,numeroNeuronas);
topologia=separarTopologia(poblacion,llave,numeroNeuronas);

if tipoFuncion==1
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*(topologia(1:end-1,:).*alpha);
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*((topologia(end:end,:)'.*betha')));
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum((dentroMuestraNoLinealN(:,1)-A_3).^2))+reg+(0*mean(mean(topologia)));
end

if tipoFuncion==2
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*(topologia(1:end-1,:).*alpha);
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*((topologia(end:end,:)'.*betha')));
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(abs((dentroMuestraNoLinealN(:,1)-A_3)))+reg+(0*mean(mean(topologia))));
end

if tipoFuncion==3
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*(topologia(1:end-1,:).*alpha);
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*((topologia(end:end,:)'.*betha')));
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(1*(exp(-(dentroMuestraNoLinealN(:,1)-A_3))-(1*(-(dentroMuestraNoLinealN(:,1)-A_3)))-1))+reg+(0*mean(mean(topologia))));
end

if tipoFuncion==4
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*(topologia(1:end-1,:).*alpha);
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*((topologia(end:end,:)'.*betha')));
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(0.3*(abs(dentroMuestraNoLinealN(:,1)-A_3)-(0.7*(dentroMuestraNoLinealN(:,1)-A_3))))+reg+(0*mean(mean(topologia))));
end

end