function [result] = modelo(x,~,individuo)
% MODELO DE OTIMIZACAO
% TUCANO 2021 - CLASSE REGULAR
% Autores: Filipe Franca

% PARAMETROS DA SIMULACAO
tic;                % inicio da contagem de tempo
sim.paralelo  = 1;  % Indica se usa ou não processamento paralelo
                    % OBS: Caso rodar paralelo, pre-definir o numero de
                    % processadores pelo comando parpool(n)
                    % Ex: 3 processadores - parpool(3)
                    
sim.panel    = 14;  % [-] Numero parametrizado de paineis VLM
sim.intermax = 25;  % [-] Numero de iteracoes maxima no VLM
                    
sim.dist     = 0;   % [-] Comando para retirar alpha efetivo do VLM (usado apenas para o estol...)
sim.npro     = 3;   % [-] Caso paralelo, quantos processamentos de uma vez no estol
sim.ajuste   = 0;   % [-] Uso de curvas polinomiais ou interpoladas

% PARAMETROS GEOMETRICOS DA AERONAVE (VARIAVEIS DE OTIMIZACAO)
% 01 [ ] Alongamento da asa inferior
% 02 [ ] Alongamento da asa superior
% 03 [ ] Tamanho percentual da estacao central da asa superior
% 04 [ ] Afilamento da estacao da ponta da asa inferior
% 05 [ ] Afilamento da estacao da ponta da asa superior

% 06 [ ] Cambra perfil 1.1 e 1.2           (MH81_2_1)
% 07 [ ] Incidencia perfil 1.1             (MH81_2_1)
% 08 [ ] Incidencia perfil 1.2             (MH81_2_1)
% 09 [ ] Incidencia perfil 1.3             (MH78_4_1)

% 10 [ ] Cambra perfil 2.1 e 2.2           (WTU_01_1_1)
% 11 [ ] Cambra perfil 2.3                 (MH84_4_2)            
% 12 [ ] Incidencia perfil 2.1             (WTU_01_1_1)
% 13 [ ] Incidencia perfil 2.2             (WTU_01_1_1) 
% 14 [ ] Incidencia perfil 2.3             (WTU_01)    

% 15 [ ] Envergadura da empenagem horizontal (x2l_v3_2_1)

aeronave.asa1    = [2.41 x(1) 0.7 x(4) 1 2 3 1];
% ['Envergadura' 'Alongamento' 'Estacao central' 'Afilamento da ponta' 'Perfil1' 'Perfil2' 'Perfil3' 'Incidencia] 
aeronave.asa2    = [2.41 x(2) x(3) x(5) 4 5 6 1 -0.1 1];
% ['Envergadura' 'Alongamento' 'Estacao central' 'Afilamento da ponta' 'Perfil1'' Perfil2' 'Perfil3' 'Incidencia' 'Stagger' 'Gap']
aeronave.incid = [x(7) x(8) x(9) x(12) x(13) x(14)];
% Respectivas incidencias
aeronave.eh      = [x(15) 0.18 7 -5 0.5 1.365];
% ['Envergadura' 'Corda' 'Perfil' 'Incidencia' 'Efetividade' 'Altura[metros]'];
aeronave.ev      = [0.23 0.00 10];
% ['Envergadura da ev' 'Posicao do centro em relacao ao CA da EH' 'Perfil EV'];
aeronave.outros  = [0.23 0.45 3 0.45];
% ['Posicao do CG em funcao da corda' 'Posicao vertical do CG ' 'Grupo moto-propulsor' 'Posicao vertical do motor];

% GEOMETRICO
[geo,penal]     = geometrico(aeronave,sim);

% FLIGTH CONDITIONS
[flc] = condicoesVOO();

% DEFININDO NOVOS PERFIS
base = {'MH81' 'WTU_01' 'MH84'};
cambra = [x(6) x(10) x(11) ];
espessura = [2 1 2];
cambra = floor(cambra);
espessura = floor(espessura);
direciona_perfil(base,cambra,espessura) 

% PLOTAR
% VLManda(geo,flc,sim,2,'-LiftingSurfaces');% So colar na command Window

%% -------------------- ESTABILIDADE E CONTROLE ---------------------------
if ~penal
%    Calculo do angulo de estol da aeronave
%     if sim.paralelo
%         [ard]               = estolp(geo, flc, sim);
%     else
%         [ard]               = estol(geo, flc, sim);
%     end
     ard.alpha_estol = 17;
    
    % Avaliacao dos criterios de estabilidade (Margem Estï¿½tica, trimagem e rotaï¿½ï¿½o)
    [penal,std]         = estabilidade(geo,flc,sim,ard);
end

%% -------------------------- PONTUACAO -----------------------------------
if penal
	% Estimativa de mtow para aeronaves penalizadas
	mtow   			= 7;

	% Estimativa de PV para aeronaves penalizadas
	pv 				= 3.5;

	% Calculo da carga paga maxima da aeronave
	cp 				= mtow - pv;

else
	% Calculo do MTOW da aeronave pelo modulo de dsp
	[mtow]   		= corrida(geo, flc, sim, ard, std);

% 	% Calculo do PV da aeronave pelo estima massa
% 	[pv,~] 			= EstimaMassa(geo, mtow);
% 	fclose('all');
    pv = 3.5;
	
	% Calculo da carga paga maxima da aeronave
	cp = mtow - pv;
 end

[Pontuacao] 		= pontuacao(cp, pv, 154, 45);
result              = -Pontuacao;
tempo = toc;

%% -------------------------------- DISPLAY --------------------------------
fprintf('Aeronave n: %d; Iter: %d; Ind: %d\n\n', individuo(3), individuo(1), individuo(2))

if ~penal
fprintf('Para o CG horizontal em relação à corda da asa inferior = %f\n',std.cgzinho);
end
fprintf('MTOW = %f\n', mtow);
fprintf('PV = %f\n', pv);
fprintf('PONTOS = %f\n\n', Pontuacao);


fprintf('Envergadura = %.3f\n', geo.LiftingSurface.B(1));
fprintf('Comprimento = %.3f\n', geo.comprimento);
fprintf('le = %f\n\n', geo.LiftingSurface.le);


fprintf('TEMPO = %.3f\n',tempo);
disp('Vetor x: '); disp(mat2str(x));
disp('===================================================================');
end
