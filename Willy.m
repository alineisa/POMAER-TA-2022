clear; close all; clc;

perfis = {'x2l_v3.dat'};        % par = [0.137 0.3784 -0.0364 0.44];                  
Re = 1e4:1.5e4:2.2e5;

ev = 0.12:0.005:0.14;
cv = -0.03:-0.005:-0.05;
ch = 0.38:0.02:0.46;

i = 1;
for var1 = 1:length(ev)
    for var2 = 1:length(cv)
        for var3 = 1:length(ch)
            par = [ev(var1) 0.3784 cv(var2) ch(var3)];
%             Chico_fun_eh(perfis{1},i,Re,par);
            fprintf('EH_%d.mat salvo!\n',i);
            i = i+1;
        end
    end
end
fprintf('Geracao de perfis finalizada!\n')