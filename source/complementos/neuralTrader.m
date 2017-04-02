function [retornosPronostico,retornosPronosticoMR] = neuralTrader(fueraMuestraNoLineal,A_3_F,A_3_MR)

retornosPronostico=[fueraMuestraNoLineal(:,1) A_3_F zeros(size(A_3_F,1),4)];
for i=2:size(A_3_F)
    %Si la red predice que la accion sube y no la tengo
    if retornosPronostico(i,2)-retornosPronostico(i-1,2)>0 && retornosPronostico(i-1,4)==0;
        retornosPronostico(i,3)=1;
        retornosPronostico(i-1,5)=1;
        retornosPronostico(i,4)=1;
        retornosPronostico(i,6)= retornosPronostico(i-1,6)+retornosPronostico(i,1);
        %Si la red predice que la accion sube y la tengo
    else
        if retornosPronostico(i,2)-retornosPronostico(i-1,2)>0 && retornosPronostico(i-1,4)==1;
            retornosPronostico(i,3)=1;
            retornosPronostico(i-1,5)=2;
            retornosPronostico(i,4)=1;
            retornosPronostico(i,6)= retornosPronostico(i-1,6);
            %Si la red predice que la accion baja y no la tengo
        else
            if retornosPronostico(i,2)-retornosPronostico(i-1,2)<0 && retornosPronostico(i-1,4)==0;
                retornosPronostico(i,3)=0;
                retornosPronostico(i-1,5)=2;
                retornosPronostico(i,4)=0;
                retornosPronostico(i,6)= retornosPronostico(i-1,6);
                %Si la red predice que la accion baja y la tengo
            else retornosPronostico(i,2)-retornosPronostico(i-1,2)<0 && retornosPronostico(i-1,4)==1;
                retornosPronostico(i,3)=0;
                retornosPronostico(i-1,5)=3;
                retornosPronostico(i,4)=0;
                retornosPronostico(i,6)= retornosPronostico(i-1,6)+(retornosPronostico(i,1));
            end
        end
    end
end

retornosPronosticoMR=[fueraMuestraNoLineal(:,1) A_3_MR zeros(size(A_3_MR,1),4)];
for i=2:size(A_3_MR)
    %Si la red predice que la accion sube y no la tengo
    if retornosPronosticoMR(i,2)-retornosPronosticoMR(i-1,2)>0 && retornosPronosticoMR(i-1,4)==0;
        retornosPronosticoMR(i,3)=1;
        retornosPronosticoMR(i-1,5)=1;
        retornosPronosticoMR(i,4)=1;
        retornosPronosticoMR(i,6)= retornosPronosticoMR(i-1,6)+(retornosPronosticoMR(i,1));
        %Si la red predice que la accion sube y la tengo
    else
        if retornosPronosticoMR(i,2)-retornosPronosticoMR(i-1,2)>0 && retornosPronosticoMR(i-1,4)==1;
            retornosPronosticoMR(i,3)=1;
            retornosPronosticoMR(i-1,5)=2;
            retornosPronosticoMR(i,4)=1;
            retornosPronosticoMR(i,6)= retornosPronosticoMR(i-1,6);
            %Si la red predice que la accion baja y no la tengo
        else
            if retornosPronosticoMR(i,2)-retornosPronosticoMR(i-1,2)<0 && retornosPronosticoMR(i-1,4)==0;
                retornosPronosticoMR(i,3)=0;
                retornosPronosticoMR(i-1,5)=2;
                retornosPronosticoMR(i,4)=0;
                retornosPronosticoMR(i,6)= retornosPronosticoMR(i-1,6);
                %Si la red predice que la accion baja y la tengo
            else retornosPronosticoMR(i,2)-retornosPronosticoMR(i-1,2)<0 && retornosPronosticoMR(i-1,4)==1;
                retornosPronosticoMR(i,3)=0;
                retornosPronosticoMR(i-1,5)=3;
                retornosPronosticoMR(i,4)=0;
                retornosPronosticoMR(i,6)= retornosPronosticoMR(i-1,6)+(retornosPronosticoMR(i,1));
            end
        end
    end
end

end

