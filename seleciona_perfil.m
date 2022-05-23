% FUNCAO PARA DEFINIR PERFIL
% Desenvolvida para selecionar o perfil da asa
function [perfil] = seleciona_perfil(choice_perf)
% Primeira selecao com MHs
    if choice_perf == 0
        perfil = 'WTU_01.mat';  
    elseif choice_perf == 1
       	perfil = 'P1.mat';
	elseif choice_perf == 2
        perfil = 'P1.mat';
	elseif choice_perf == 3
        perfil = 'MH78_4_1.mat';
    elseif choice_perf == 4
        perfil = 'P2.mat';
    elseif choice_perf == 5
        perfil = 'P2.mat';
    elseif choice_perf ==6
        perfil = 'P3.mat';
    elseif choice_perf == 7
        perfil = 'x2l_v3_2_1.mat';
    elseif choice_perf == 8
        perfil = 'MH84.mat';

% Segunda selecao com hipersustentadores 

%     if choice_perf == 0
%         perfil = 'WTU_01.mat';  
%     elseif choice_perf == 1
%        	perfil = 'BA7_top10_WTU_01pdat.mat';
% 	elseif choice_perf == 2
%         perfil = 'BA7_top10.mat';
% 	elseif choice_perf == 3
%         perfil = 's1223.mat';
%     elseif choice_perf == 4
%         perfil = 'ET_M2007.mat';
%     elseif choice_perf == 5
%         perfil = 'x2017_01.mat';
%     elseif choice_perf == 6
%         perfil = 'ETW_05.mat';
        
% Empenagem
	elseif choice_perf == 10
        perfil = 'NACA0012';
	elseif choice_perf == 11
        perfil = 'NACA0015';
    elseif choice_perf == 12
        perfil = 'x2l_v3.mat';
    end
end