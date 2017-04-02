function [poblacion]=generarPoblacionBase(numeroCromosomas,numeroBits) 
%OBJETIVO: Generar la matris de topologia en base a mutaciones de una
% red neuronal full connected. 
%COMPORTAMIENTO: Son capturadas los valores del numero de cromosomas
% y numero de bits.
%RETORNA: La matris de poblacion.

numeroPadres=1;
tasaMutacion=1;
numeroMutaciones=tasaMutacion*numeroBits*(numeroCromosomas-1)

poblacion=ones(numeroCromosomas,numeroBits)

for ic=1:numeroMutaciones
ix=ceil((numeroPadres)+(numeroCromosomas-(numeroPadres))*rand);
iy=ceil(numeroBits*rand);
poblacion(ix,iy)=1-poblacion(ix,iy)
end