function [PT] = pontuacao(CP, PV)
% Estudo de pontua��o SAE Brasil aerodesign - torneio de acesso 2022
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

% PONTUA��O DE VOO

Pvoo = 15*EE+CP;

%PONTUA��O DE PROJETO
PP = 8.5;

%BONIFICA��O
BT = 5;

%PONTUA��O TOTAL

PT = Pvoo + PP + BT;

end