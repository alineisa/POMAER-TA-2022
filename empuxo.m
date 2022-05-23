 % clear all;close all; clc;

function [E]=empuxo(v,x, rho)
%% Nomenclatura

%DADOS DE SA�DA:
% E => Empuxo do grupo motopropulsor

% DADOS DE ENTRADA:
% v => Vetor de velocidades [m/s];
% x => Escolha do grupo motopropulsor

%% C�LCULOS

% v = 0:0.1:25;

if x==0
	
	% H�lice APC 13x4 com o Magnum .61
	%E =  -0.0001504.*v.^3-0.001705.*v.^2-0.7751.*v+ 40.65; (2018)
	E = 9.2439e-05*v.^3 - 0.0113*v.^2 - 0.8038*v + 37.1415;
elseif x==1
	
	% H�lice APC 12.25x3.75 com o Magnum .61
	
% 	freio = 20;
% 	va = 1.95;
% 	indice = find(v<va+v(1),1,'last');
% 	E(1:indice-1) = (.0007.*v(indice).^3-.0365.*v(indice).^2-.2472.*v(indice)+36.8267 - freio)/(va).*v(1:indice-1) + freio;
% 	E(indice:length(v)) = .0007.*v(indice:length(v)).^3-.0365.*v(indice:length(v)).^2-.2472.*v(indice:length(v))+36.8267;
	
% 	E = 0.00112.*v.^3 - 0.04084 .*v.^2 - 0.5278.*v + 40.28;
% 	E = .0007.*v.^3-.0365.*v.^2-.2472.*v+36.8267;
   %E = .93*(0.0007*v.^3 - 0.0331*v.^2 - 0.4077.*v + 41.0597); (2018)
    E = 9.5298e-05*v.^3 - 0.0117*v.^2 - 0.5827*v + 38.1307;
	
elseif x==2
	% H�lice Master Airscrew 13x4 com o Magnum .61
	% E = 0.000167.*v.^3 -0.003675 .*v.^2-0.9392.*v +  40.59; (2018)
    E = 9.0533e-05*v.^3 - 0.0111*v.^2 - 0.7873*v + 37.1205;
elseif x==3
    %Helice kbulosa braba de bh by Lucas C e Joshin (SK 200KV)
    E = 0.0004*v.^3 + 0.0145*v.^2 - 2.6316*v + 62.63;
end

E = (E*rho/1.1116)*0.9;

% v=0:0.1:20;
% 	E1 =  -0.0001504.*v.^3-0.001705.*v.^2-0.7751.*v+ 40.65;
% 	E2 = 0.00112.*v.^3 - 0.04084 .*v.^2 - 0.5278.*v + 40.28;
% 	E3 = 0.000167.*v.^3 -0.003675 .*v.^2-0.9392.*v +  40.59;
% 	plot(v,E1,v,E2,v,E3)
% plot(v,E,'linewidth',2)
% grid on
% hold on
% Et = E.*cosd(2*v).*(1 + sind(0.8*v))+0.6;
% plot(v,Et,'linewidth',2)
% title('Tra��o Experimental');
% xlabel('Velocidade (TAS) [m/s]');
% ylabel('Tra��o [N]');
% legend('Velocidade','Tra��o');