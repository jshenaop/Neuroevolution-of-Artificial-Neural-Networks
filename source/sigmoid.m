function g = sigmoid(z)
%OBJETIVO: Funcion Logistica.
%COMPORTAMIENTO: Evalua.
%RETORNA: Valor de z evaluado en la funcion logistica.

g = 1.0 ./ (1.0 + exp(-z));

end
