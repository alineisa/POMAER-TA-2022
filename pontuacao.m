function [PT] = pontuacao(CP, PV)
% Estudo de pontua��o SAE Brasil aerodesign - torneio de acesso 2022
%mtow(peso total/tudo)
% PV(peso vazio/sem carga)
%carga paga(peso total - vazio)


%EE - quantidade de peso que a aeronave consegue levar (aline: isso � carga
%paga, eficiencia estrutural � CP/PV)

mtow = CP+PV;

if mtow > 20
    mtow = 20;
    CP = mtow - PV;
end

EE = CP/PV;

% PONTUA��O DE VOO

Pvoo = 15*EE+CP;

%PONTUA��O DE PROJETO
PP = 8.5; %(aline: elas valem 10, pode considerar como 10 se quiser, mas se quiser deixar uma margem, tudo bem tambem)

%BONIFICA��O
BT = 5;

%PONTUA��O TOTAL

PT = Pvoo + PP + BT;

end

%ALINE: ficou muito bom!! parab�ns!