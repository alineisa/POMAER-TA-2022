% Accelerated Differencial Evolution [ADE]
% Aline
clear all; close all; clc;
SetPaths;
tempoi = clock;
%%
% VTR		"Value To Reach" (stop when std(function) < VTR)
		VTR = 1.e-2;


% XVmin,XVmax   vector of lower and bounds of initial population
%    		the algorithm seems to work well only if [XVmin,XVmax] 
%    		covers the region where the global minimum is expected
%               *** note: these are o bound constraints!! ***

% ======================== LIMITES DAS VARIAVEIS ==========================
%     	_________________________
%     	|            |           \
%		|   central  |   ponta    \
%       |____________|_____________\

       OB = [
			% ASAS
            4.00    7.00 		% 01 [ ] Alongamento da asa
            0.20    0.80       	% 02 [ ] Tamanho percentual da esta??o central
			0.50    0.70		% 03 [ ] Afilamento da estacao da ponta da asa
		    0.00    0.99   	    % 04 [ ] Perfil da asa secao 1
            0.00    0.99        % 05 [ ] Perfil da asa secao 2
            0.00    5.00        % 06 [graus] Incidencia da asa
            % EMPENAGEM HORIZONTAL
            0.30    0.70        % 07 [m] Envergadura da empenagem horizontal
            0.50    1.50        % 08 [m] le
            0.18    0.30        % 09 [m] corda da EH
            0.00    0.60        % 10 [m] altura da EH
			];
% =================================================================================
			 
        XVmin = OB(:,1)';        XVmax = OB(:,2)';

        
% D		number of parameters of the objective function 
		D = length(XVmin); 
		
% y		problem data vector (remains fixed during optimization)
		y=[]; 

% NP    number of population members
		NP = 12*D; 
        NPin = 5;

% itermax       maximum number of iterations (generations)
		itermax = 70;

% F     DE-stepsize F ex [0, 2]
		F = 0.8; 

% CR    crossover probabililty constant ex [0, 1]
		CR = 0.85; 

% strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
%                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
%                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
%                4 --> DE/best/2/exp           9 --> DE/best/2/bin
%                5 --> DE/rand/2/exp           else  DE/rand/2/bin

		strategy = 1;
 
% refresh       intermediate output will be produced after "refresh"
%               iterations. No intermediate output will be produced
%               if refresh is < 1
		refresh = 1;

% nvezes        Numero de otimizacoes a serem feitas
        nvezes  = 1;

% -------------------------------------------------------------------------

Individuos_otimizados = zeros(nvezes,D);
f_otimizados = zeros(1,nvezes);

for ijk = 1:nvezes
	[x,f,nf,Individuos_best,ind_itermax]=differential_evolution('modelo',VTR,D,XVmin,XVmax,y,NP,itermax,F,CR,strategy,refresh,ijk);
	Individuos_otimizados(ijk,:) = x;
	f_otimizados(ijk) = f;
	if abs(f)>= max(abs(f_otimizados))
		Otimizacao.x = x;
		Otimizacao.Pontuacao = abs(f);
		Otimizacao.Individuos_best = Individuos_best;
		Otimizacao.ind_itermax = ind_itermax;
	end
end

tempof = clock;
tempo = tempof - tempoi;

% atentar-se a mudancas de mes
tempo = tempo(3)*86400 + tempo(4)*3600 + tempo(5)*60 + tempo(6);

horas = fix(tempo/3600);
minutos = fix((tempo/3600 - horas)*60);
segundos = fix(((tempo/3600 - horas)*60 - minutos)*60);
fprintf('Tempo de otimizacao: %dh:%dmin:%ds.\n\n', horas, minutos, segundos)

disp('-------------------------------------------------------------------------------------------------------')
disp('                  ***Aeronave Otimizada***                  ')
disp(Otimizacao)
disp('                  ***Estatisticas da Otimizacao***                  ')
fprintf('  Media dos MTOW"s otimizados: %f\n\n',mean(f_otimizados))
fprintf('  Desvio padrao das pontuacoes da ultima interacao: %f\n\n',std(ind_itermax(:,1)))
fprintf('Tempo de otimizacao: %dh:%dmin:%ds.\n\n', horas, minutos, segundos)
disp('-------------------------------------------------------------------------------------------------------')
save('Otimizacao_WG_7.mat');

!fim.mp3
