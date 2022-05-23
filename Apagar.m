clear; close all; clc;

for i = 1:7
    salvar_mat = ['P' num2str(i)];
    perfil = ImportObj(salvar_mat);
    coordenadas = perfil.xy;
    save([salvar_mat '.dat'],'coordenadas','-ASCII');    
end

