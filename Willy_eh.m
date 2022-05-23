clear; close all; clc;

global dadosdat

load('Perfis_dat/x2l_v3+par.mat') 
dadosdat = arm.dados;
pontos = arm.uni;
Re = 1e4:1.5e4:2.2e5;
e = -0.005:0.005:0.010;
c = -0.010:0.005:0.010;


for var1 = 1:length(e)
    for var2 = 1:length(c)
        pts = pontos;
        pts(5) = pts(5) + c(var2);
        pts(12) = pts(12) + e(var1);
        [coordenadas] = Bezier_para_dat(pts);
        save Perfis_dat/Bezier.dat coordenadas -ASCII;                     % Salva as coordenadas do perfil teste
        salvar_como = ['x2l_v3_' num2str(var2) '_' num2str(var1)];
        Chico_fun_eh('Bezier.dat',salvar_como,Re);
        fprintf('%s salvo.\n',salvar_como);
        clear pts
    end
end
fprintf('Geracao de perfis finalizada!\n')