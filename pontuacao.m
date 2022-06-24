function [PT] = pontuacao(CP, PV)
% Estudo de pontuação SAE Brasil aerodesign - torneio de acesso 2022
%mtow(peso total/tudo)
% PV(peso vazio/sem carga)
%carga paga(peso total - vazio)
%EE - quantidade de peso que a aeronave consegue levar


mtow = CP+PV;

if mtow > 20
    mtow = 20;
    CP = mtow - PV;
end

EE = CP/PV;

% PONTUAÇÃO DE VOO

Pvoo = 15*EE+CP;

%PONTUAÇÃO DE PROJETO
PP = 8.5;

%BONIFICAÇÃO
BT = 5;

%PONTUAÇÃO TOTAL

PT = Pvoo + PP + BT;

end