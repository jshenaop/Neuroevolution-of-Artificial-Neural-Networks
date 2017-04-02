function costo=funcionCosto(parametros,dentroMuestraNoLinealN,dentroMuestraLinealN,tipoFuncion,llave,numeroNeuronas)
%OBJETIVO: Devolver el valor de la funcion de costo para unos parametros dados
%unas matrices de diseño Normalizadas y se calculara en cierto tipo de funcion
%que se requiera.
%COMPORTAMIENTO: Segun el tipo de funcion y los parametros separados de
%phi,alpha y betha se calcula el costo.
%RETORNA: El costo de la funcion.

%Recostruyo los parametros
m=size(dentroMuestraNoLinealN,1);
[phi,betha,alpha]=separarMatrices(parametros,llave,numeroNeuronas);

if tipoFuncion==1
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*alpha;
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*betha');
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum((dentroMuestraNoLinealN(:,1)-A_3).^2))+reg;
end

if tipoFuncion==2
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*alpha;
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*betha');
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(abs((dentroMuestraNoLinealN(:,1)-A_3))))+reg;
end

if tipoFuncion==3
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*alpha;
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*betha');
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(1*(exp(-(dentroMuestraNoLinealN(:,1)-A_3))-(1*(-(dentroMuestraNoLinealN(:,1)-A_3)))-1)))+reg;
end

if tipoFuncion==4
    A_1=dentroMuestraNoLinealN(:,2:end);
    Z_2=A_1*alpha;
    A_2=sigmoid(Z_2);
    A_3=(dentroMuestraLinealN(:,2:end)*phi')+(A_2*betha');
    reg = sum(0.01*sum(phi(:,2:end).^2)+sum(0.0001*betha(:,2:end).^2)+sum(0.0001*alpha(:,2:end).^2));
    costo=((1/m)*sum(0.3*(abs(dentroMuestraNoLinealN(:,1)-A_3)-(0.7*(dentroMuestraNoLinealN(:,1)-A_3)))))+reg;
end

end