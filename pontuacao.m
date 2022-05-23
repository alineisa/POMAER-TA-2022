function [Pvoo] = pontuacao(CP, PV_prev, NR, t)
% Estudo de pontuação SAE Brasil aerodesign - classe regular 2018

mtow = CP+PV_prev;

if mtow > 20
    mtow = 20;
    CP = mtow - PV_prev;
end

% DEFINIÇÕES DE PREVISÃO
NR_max		= 185;
PV_real		= PV_prev;
CP_real		= CP;
CP_prev		= CP;

% PONUTACAO DE PROJETO
P_apres 	= 30;
P_proj 		= NR + P_apres + 30;

% PONTUAÇÃO DE VOO
P_cp		= 12.5*CP;

FPR	= min([1 (0.5 + 0.9*NR/NR_max)]);
FPV			= 1.10 - 15*((PV_prev - PV_real)./PV_prev).^2;

P_voo		= FPR.*FPV.*P_cp;
P_ac		= 30 - 830.*(abs((CP_prev - CP_real)./CP_prev)).^1.75;

P_bateria	= P_voo + P_ac;

% MELHOR SITUAÇÃO DE PONTUAÇÃO DE CONFIABILIDADE
P_b1		= P_bateria;
P_b2		= P_bateria;

B_cf		= 20*(1 - (5*(P_b1 - P_b2)./P_b1).^2);

% BONIFICAÇÃO
B_po		= 1.0*CP;

for c = 1:length(t)
	B_rc(c)= min([20 (40-t(c)./3)]');
end

% PONTUAÇÃO TOTAL
Pvoo		= P_bateria + B_po + B_rc + B_cf;

end