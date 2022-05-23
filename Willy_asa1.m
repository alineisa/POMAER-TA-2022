clear; close all; clc;

global dadosdat

load('Perfis_dat/MH81+par.mat') 
dadosdat = arm.dados;
pontos = arm.uni;
Re = [1e4:1.5e4:1.9e5 2.05e5:2.5e4:3.55e5];
e = -0.006:0.006:0.012;
c = -0.004:0.004:0.008;


for var1 = 1:length(e)
    for var2 = 1:length(c)
        pts = pontos;
        pts(5) = pts(5) + c(var2);
        pts(12) = pts(12) + e(var1);
        [coordenadas] = Bezier_para_dat(pts);
        save Perfis_dat/Bezier.dat coordenadas -ASCII;                     % Salva as coordenadas do perfil teste
        salvar_como = ['MH81_' num2str(var2) '_' num2str(var1)];
        Chico_fun_asa('Bezier.dat',salvar_como,Re);
        fprintf('%s salvo.\n',salvar_como);
        clear pts
    end
end
fprintf('Geracao de perfis finalizada!\n')