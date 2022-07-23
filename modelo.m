function [result] = modelo(x,~,individuo)
% MODELO DE OTIMIZACAO
% TUCANO 2021 - CLASSE REGULAR
% Autores: Filipe Franca
x=[4.4582548666528 0.336096641016638 0.562953602732129 0.107787356210436 0.346001976895613 1.86703581990955 0.415167243894771 1.43715998170697 0.297968361665727 0.548898190060895]
% PARAMETROS DA SIMULACAO
tic;                % inicio da contagem de tempo
sim.paralelo  = 0;  % Indica se usa ou n??o processamento paralelo
                    % OBS: Caso rodar paralelo, pre-definir o numero de
                    % processadores pelo comando parpool(n)
                    % Ex: 3 processadores - parpool(3)
                    
sim.panel    = 15;  % [-] Numero parametrizado de paineis VLM
sim.intermax = 25;  % [-] Numero de iteracoes maxima no VLM
                    
sim.dist     = 0;   % [-] Comando para retirar alpha efetivo do VLM (usado apenas para o estol...)
sim.npro     = 3;   % [-] Caso paralelo, quantos processamentos de uma vez no estol
sim.ajuste   = 1;   % [-] Uso de curvas polinomiais ou interpoladas

% PARAMETROS GEOMETRICOS DA AERONAVE (VARIAVEIS DE OTIMIZACAO)

			% ASAS
%             4.00    7.00 		% 01 [ ] Alongamento da asa
%             0.20    0.80       	% 02 [ ] Tamanho percentual da esta??o central
% 			0.50    0.70		% 03 [ ] Afilamento da estacao da ponta da asa
% 		    0.00    0.99   	    % 04 [ ] Perfil da asa secao 1
%             0.00    0.99        % 05 [ ] Perfil da asa secao 2
%             0.00    5.00        % 06 [graus] Incidencia da asa
%             % EMPENAGEM HORIZONTAL
%             0.30    0.70        % 07 [m] Envergadura da empenagem horizontal
%             0.50    1.50        % 08 [m] le
%             0.18    0.30        % 09 [m] corda da EH
%             0.00    0.60        % 10 [m] altura da EH
% 			];

aeronave.asa1    = [1.99 x(1) x(2) x(3) floor(x(4)) floor(x(5)) floor(x(6))];
% ['Envergadura' 'Alongamento' 'Estacao central' 'Afilamento da ponta' 'Perfil1' 'Perfil2' 'Incidencia da Asa' ] 
aeronave.eh      = [x(7) x(9) 10 0 1 x(10) x(8)];
% ['Envergadura' 'Corda' 'Perfil' 'Incidencia' 'Efetividade' 'Altura[metros]' 'le'];
aeronave.ev      = [0.23 0.00 10];
% ['Envergadura da ev' 'Posicao do centro em relacao ao CA da EH' 'Perfil EV'];
aeronave.outros  = [0.23 0.45 3 0.45];
% ['Posicao do CG em funcao da corda' 'Posicao vertical do CG ' 'Grupo moto-propulsor' 'Posicao vertical do motor];

% GEOMETRICO
[geo,penal]     = geometrico(aeronave,sim);

% FLIGTH CONDITIONS
[flc] = condicoesVOO();

% PLOTAR
VLManda(geo,flc,sim,2,'-LiftingSurfaces');% So colar na command Window

%% ------------------------- AERODINAMICA ---------------------------------
% Calculo do estol
if ~penal
    if sim.paralelo 
        [ard,geo]               = estolp(geo, flc, sim);

    else 
        [ard,geo]               = estol(geo, flc, sim);
    end
    ard.def = ard.estoleh + x(5);
% save('ard','ard','geo')
% load('ard')
end

%% --------------------------- ESTABILIDADE -------------------------------
[penal,std] = estabilidade(geo,flc,sim,ard);

%% -------------------------- PONTUACAO -----------------------------------
if penal
	% Estimativa de mtow(peso total/tudo) para aeronaves penalizadas
	mtow   			= 7;

	% Estimativa de PV(peso vazio/sem carga) para aeronaves penalizadas
	pv 				= 3.5;

	% Calculo da carga paga(peso total - vazio) maxima da aeronave
	cp 				= mtow - pv;

else
	% Calculo do MTOW da aeronave pelo modulo de dsp
 [mtow]   		= corrida(geo, flc, sim, ard, std);

% 	% Calculo do PV da aeronave pelo estima massa
	[pv,~] 			= EstimaMassa(geo, mtow);
	fclose('all');

	% Calculo da carga paga maxima da aeronave
	cp = mtow - pv;
 end

[Pontuacao] 		= pontuacao(cp, pv);
result              = -Pontuacao;
tempo = toc;

%% -------------------------------- DISPLAY --------------------------------
fprintf('Aeronave n: %d; Iter: %d; Ind: %d\n\n', individuo(3), individuo(1), individuo(2))

if ~penal
fprintf('Para o CG horizontal em rela????o ?? corda da asa inferior = %f\n',std.cgzinho);
end
fprintf('MTOW = %f\n', mtow);
fprintf('PV = %f\n', pv);
fprintf('PONTOS = %f\n\n', Pontuacao);


fprintf('Envergadura = %.3f\n', geo.LiftingSurface.B(1));
fprintf('le = %f\n\n', geo.LiftingSurface.le);


fprintf('TEMPO = %.3f\n',tempo);
disp('Vetor x: '); disp(mat2str(x));
disp('===================================================================');
end
