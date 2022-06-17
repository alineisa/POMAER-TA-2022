function [geo,penal] = geometrico(aeronave,sim)
%% ================================ Observacoes ================================
% Modelo Geometrico do POMAER Tucano Regular 2021
% Autores: Filipe FranÃ§a & Lucas Honorio

% Eixos de referencia:
% A origem fica no CA da asa.
% eixo x positivo para tras
% eixo z positivo para cima
% Asa dividida em 2 secoes (2 perfis)

%  __________________ __
% |                  |  ....      
% |                  |        |
% |                  |        |
% |__________________|__....   


%% -------------------- PARAMETROS DE ENTRADA DEFINIDOS -------------------
surfacenum     	= 2;                                                        % [-]  asa + EH
geo.LiftingSurface.surfacenum = surfacenum;

%   ASA
geo.LiftingSurface.h(1,1) = .135;                                        	% [m] Altura do CA da raiz da asa inferior ao solo(n�o alterei pois n�o pretendo colocar enflechamento e diedro no projeto) 
geo.LiftingSurface.e(1:2,1:3) = 0;                                          % [deg] Enflechamento de cada secao das asas 
geo.LiftingSurface.d(1:2,1:3) = 0;                                          % [deg] Diedro de cada secao das asas

%   EMPENAGEM HORIZONTAL
geo.LiftingSurface.e(surfacenum,1)          = 0;                            % [deg] Enflechamento da empenagem horizontal
geo.LiftingSurface.d(surfacenum,1)          = 0;                            % [deg] Diedro da empenagem horizontal
geo.LiftingSurface.wo(1:2,1:4)              = 0;                            % [deg] vetor de angulo de washout dos perfis das asas

%   EMPENAGEM VERTICAL
geo.ev.e(1)          = 0;                                                   % [deg] Enflechamento da empenagem horizontal
geo.ev.d(1)          = 0;                                                  	% [deg] Diedro da empenagem horizontal

% 	TAILBOOM
geo.tail.hcc    = .15;                                                      % [m] Altura da secao transversal do tailboom
geo.tail.ecc	= .1;                                                       % [m] Largura da secao transversal do tailboom
geo.tail.lcc	= .3;                                                       % [m] Comprimento do tailboom

% 	TREM DE POUSO
geo.tp.bico_beq = .017;                                                     % [m] Distancia da bequilha ao bordo de ataque da asa
geo.tp.tp_CG    = .015;                                       				% [m] distancia do TP ao CG

%% ------------------- PARAMETROS DE ENTRADA DA FUNCAO --------------------
% ASAS
geo.LiftingSurface.B(1,1)  	    = aeronave.asa1(1);                         % [m] Envergadura da asa inferior


geo.LiftingSurface.AR(1,1) 		= aeronave.asa1(2);						    % [-] Alongamento da asa inferior


geo.LiftingSurface.pest(1,1)    = aeronave.asa1(3);						    % [-] Tamanho percentual da estação central da asa inferior


geo.LiftingSurface.lamb(1,1) 	= 1;                                        % [-] Afilamento da primeira secao asa inferior
geo.LiftingSurface.lamb(2,1) 	= 1;                                        % [-] Afilamento da primeira secao asa superior



geo.LiftingSurface.perfil(1,1)	= aeronave.asa1(5);                         % [-] Perfis da asa inferior

geo.LiftingSurface.perfil(1,2)	= aeronave.asa1(6);                         % [-] Perfis da asa inferior

geo.LiftingSurface.perfil(1,3)	= aeronave.asa1(7);                         % [-] Perfis da asa inferior


geo.LiftingSurface.twist(1,:) = aeronave.incid(1:3);
geo.LiftingSurface.twist(2,:) = aeronave.incid(4:6);

% EMPENAGEM HORIZONTAL
geo.LiftingSurface.B(surfacenum,1)          = aeronave.eh(1);               % [m] Envergadura da EH
geo.LiftingSurface.c(surfacenum,1)          = aeronave.eh(2); 			    % [m] corda da raiz da EH
geo.LiftingSurface.pos(surfacenum,3)        = aeronave.eh(6);               % [m] Altura da EH a partir da asa inferior
geo.LiftingSurface.perfil(surfacenum,1)     = aeronave.eh(3);               % [-] Perfil da EH
geo.LiftingSurface.incidence(surfacenum,1)  = aeronave.eh(4);               % [deg] Incidencia da eh
geo.LiftingSurface.tau  			        = aeronave.eh(5); 				% [-] Efetividade do profundor (tau)

% EMPENAGEM VERTICAL
geo.ev.B        = aeronave.ev(1);                                           % [m] envergadura da EV
geo.ev.posEH    = aeronave.ev(2);                                           % [m] Posicao do centro da EV em relacao ao CA da EH
geo.ev.perfil   = aeronave.ev(3);                                           % [m] perfil da EV

% MOTO-PROPULSOR
geo.mp.pos_gap  = aeronave.outros(4);                                       % [m] Posição do motor em z em relação ao gap
geo.mp.conjunto = aeronave.outros(3);                                       % [-] indice do conjunto moto-propulsor selecionado (ver funcao empuxo)
geo.bico        = 0.0675;                                                   % [m] 

% CG
geo.cg.h        = aeronave.outros(1);                                       % [-] posicao do CG horizontal em funcao da corda da raiz
geo.cg.v        = aeronave.outros(2);                                       % [-] posicao do CG vertical em funcao do gap

%% ==================== Definicao das dimensoes da asa ====================
for i=1:surfacenum-1
    % Numero de secoes das asas
    geo.LiftingSurface.section_num(i,1) = 2; %deixa 2 secoes mesmo?
    
	% Area das asas
	geo.LiftingSurface.Sw(i,1) = ((geo.LiftingSurface.B(i)).^2)./(geo.LiftingSurface.AR(i));
    
	% Posicao do inicio de cada secao e da ponta
    geo.LiftingSurface.b(i,1) = 0;                                                             % posicao do perfil da raiz
	geo.LiftingSurface.b(i,2) = geo.LiftingSurface.pest(i)*geo.LiftingSurface.B(i)/2 ;         % posicao do segundo perfil (primeira - segunda secao)
	geo.LiftingSurface.b(i,3) = geo.LiftingSurface.B(i)/2; 	                                   % posicao do terceiro perfil (segunda - terceira secao) (tira essa parte?)
    
	% cordas dos perfis de inicio de cada secao
	geo.LiftingSurface.c(i,1) = 0.5*geo.LiftingSurface.Sw(i)/(geo.LiftingSurface.b(i,2)+((geo.LiftingSurface.b(i,3)-geo.LiftingSurface.b(i,2))*(1+geo.LiftingSurface.lamb(i,2))/2));
	geo.LiftingSurface.c(i,2) = geo.LiftingSurface.c(i,1)*geo.LiftingSurface.lamb(i,1);
	geo.LiftingSurface.c(i,3) = geo.LiftingSurface.c(i,2)*geo.LiftingSurface.lamb(i,2);

	% angulos de torcao dos perfis de inicio de cada secao
    geo.LiftingSurface.incidence(i,1) = 0;

	% Areas de cada secao
    geo.LiftingSurface.S(i,1)   = (geo.LiftingSurface.c(i,1) + geo.LiftingSurface.c(i,2))*(geo.LiftingSurface.b(i,2)-geo.LiftingSurface.b(i,1))/2;
    geo.LiftingSurface.S(i,2)   = (geo.LiftingSurface.c(i,2) + geo.LiftingSurface.c(i,3))*(geo.LiftingSurface.b(i,3)-geo.LiftingSurface.b(i,2))/2;

	% Area da asa
	geo.LiftingSurface.Sw(i,1)	= 2*sum(geo.LiftingSurface.S(i,:));
end
% Posicionamento das asas
geo.LiftingSurface.pos(1,1) = 0;
geo.LiftingSurface.pos(1,2) = 0;
geo.LiftingSurface.pos(1,3) = 0;

geo.LiftingSurface.pos(2,1) = geo.LiftingSurface.Stagger+(geo.LiftingSurface.c(2,1)*0.25)-(geo.LiftingSurface.c(1,1)*0.25);
geo.LiftingSurface.pos(2,2) = 0;
geo.LiftingSurface.pos(2,3) = geo.LiftingSurface.Gap;

geo.comprimento = 3.2 - geo.LiftingSurface.B(1,1) - 0.01;
%% ==================== Definicao das dimensoes da eh =====================
% Numero de secoes da empenagem horizontal
geo.LiftingSurface.section_num(surfacenum,1) = 1;

geo.LiftingSurface.b(surfacenum,1) = 0;                                     % [m] posicao do perfil da raiz da eh
geo.LiftingSurface.b(surfacenum,2) = geo.LiftingSurface.B(surfacenum)/2;    % [m] posicao do perfil da ponta da eh

% cordas da empenagem horizontal
geo.LiftingSurface.c(surfacenum,1) = geo.LiftingSurface.c(surfacenum,1);    % [m] corda da raiz da eh
geo.LiftingSurface.c(surfacenum,2) = geo.LiftingSurface.c(surfacenum,1);    % [m] corda da ponta da eh

% perfis da empenagem horizontal
geo.LiftingSurface.perfil(surfacenum,1) = geo.LiftingSurface.perfil(surfacenum,1); % [-] perfil da raiz
geo.LiftingSurface.perfil(surfacenum,2) = geo.LiftingSurface.perfil(surfacenum,1); % [-] perfil da ponta

% angulos de incidencia de cada perfil da empenagem horizontal
geo.LiftingSurface.incidence(surfacenum,1) = geo.LiftingSurface.incidence(surfacenum,1);

% angulos de torcao em cada perfil (input VLM)
geo.LiftingSurface.twist(surfacenum,:) = 0;    % definido como vetor de zeros pois nao se esta avaliando torcao na empenagem

% Area de cada secao da empenagem horizontal
geo.LiftingSurface.S(surfacenum,1) = (geo.LiftingSurface.c(surfacenum,1) + geo.LiftingSurface.c(surfacenum,2))*(geo.LiftingSurface.b(surfacenum,2)-geo.LiftingSurface.b(surfacenum,1))/2;

% Area total da empenagem e alongamento
geo.LiftingSurface.Sw(surfacenum,1) = 2*sum(geo.LiftingSurface.S(surfacenum,:));
geo.LiftingSurface.AR(surfacenum,1) = (geo.LiftingSurface.B(surfacenum)^2)/geo.LiftingSurface.Sw(surfacenum);

% Posicionamento da empenagem
if geo.LiftingSurface.Stagger <= 0
    geo.LiftingSurface.le = geo.comprimento + geo.LiftingSurface.Stagger - geo.LiftingSurface.c(1,1)*0.25 - geo.LiftingSurface.c(surfacenum,1)*0.75;
else
    geo.LiftingSurface.le = geo.comprimento - geo.LiftingSurface.c(1,1)*0.25 - geo.LiftingSurface.c(surfacenum,1)*0.75;
end

geo.LiftingSurface.pos(surfacenum,1) = geo.LiftingSurface.le;
geo.LiftingSurface.pos(surfacenum,2) = 0;
geo.LiftingSurface.pos(surfacenum,2) = geo.LiftingSurface.pos(surfacenum,2); %mudei para 2
%% ==================== Distribuicao das malhas ===========================
geo.LiftingSurface.Mesh.Definido = [1;1;1];  % Define se utilizara as distribuicoes pre-definidas

% Fator de densidade de cada estacao
densi_central = 0.81;   
densi_ponta   = 1.00;
densi_EH      = 1.85;

% Calculo das distribuicoes de malha 
geo.LiftingSurface.Mesh.Ny(1,1) = floor(geo.LiftingSurface.pest(1).*2.*sim.panel.*densi_central);
geo.LiftingSurface.Mesh.Ny(2,1) = floor(geo.LiftingSurface.pest(2).*2.*sim.panel.*densi_central);
geo.LiftingSurface.Mesh.Ny(1,2) = floor((2*sim.panel-geo.LiftingSurface.Mesh.Ny(1,1)).*densi_ponta);
geo.LiftingSurface.Mesh.Ny(2,2) = floor((2*sim.panel-geo.LiftingSurface.Mesh.Ny(2,1)).*densi_ponta);
geo.LiftingSurface.Mesh.Ny(3,1) = floor((geo.LiftingSurface.b(3,2)./geo.LiftingSurface.b(1,3)).*sim.panel.*densi_EH);
%% ==================== Definicao das dimensoes da ev =====================
geo.ev.section_num = 1;

% Posicionamento de cada secao em relacao a raiz
geo.ev.b(1) = 0;                                                               % [m] posicao do perfil da raiz da eh
geo.ev.b(2) = geo.ev.B/2;                                                      % [m] posicao do perfil da ponta da eh

% cordas da empenagem horizontal
geo.ev.c(1) = geo.LiftingSurface.c(surfacenum,2);
geo.ev.c(2) = geo.ev.c(1);

% perfis da empenagem horizontal
geo.ev.perfil(1) = geo.ev.perfil(1);
geo.ev.perfil(2) = geo.ev.perfil(1);

% angulos de torcao em cada perfil (input VLM)
geo.ev.twist(:)  = [0 0];

% Area de cada secao da empenagem vertical
geo.ev.S    = (geo.ev.c(2)+geo.ev.c(1))*(geo.ev.b(2)-geo.ev.b(1))/2;

% Area total da empenagem e alongamento
geo.ev.Sw   = 2*sum(geo.ev.S(:));

geo.ev.AR   = (geo.ev.B^2)/geo.ev.Sw;

% Posicionamento da empenagem vertical
geo.ev.pos(1,1) = geo.LiftingSurface.le;                                    % [m] posicao em x da EV em relacao ao CA da asa inferior (mesma da EH)
geo.ev.pos(1,2) = geo.LiftingSurface.b(surfacenum,2);                       % [m] posicao em y da EV na ponta da empenagem horizontal
geo.ev.pos(1,3) = geo.LiftingSurface.pos(surfacenum,3)+geo.ev.posEH;        % [m] posicao em z da EV 

%% ============== Definicao do posicionamento do CG e TP =================
% CG
% geo.cg.pos(1)   = (geo.cg.h-0.25)*geo.LiftingSurface.c(1,3);              % [m] posicao do CG em x com origem no CA da asa inferior
geo.cg.pos(2)   = 0;                                                        % [m] posicao do CG em y com origem no CA da asa inferior
geo.cg.pos(3)   = geo.cg.v;                                                 % [m] posicao do CG em z com origem no CA da asa inferior

% Moto-propulsor
geo.mp.pos(1) = 0;                                                          % [m] Posicao do motor em x
geo.mp.pos(2) = 0;                                                          % [m] Posicao do motor em y
geo.mp.pos(3) = geo.mp.pos_gap;                                             % [m] Posicao do motor em z

% TREM DE POUSO
%geo.tp.pos(1)   = geo.tp.tp_CG + geo.cg.pos(1);          					% [m] distancia do trem de pouso ao CA da asa inferior em x
geo.tp.pos(2)   = 0;                                                        % [m] distancia do trem de pouso ao CA da asa inferior em y
geo.tp.pos(3)   = -geo.LiftingSurface.h(1,1);                               % [m] distancia do trem de pouso ao CA da asa inferior em z

%% ======================= Penalizacoes geometricas =======================
% disp(geo.LiftingSurface.B(1,1)+ abs(geo.LiftingSurface.Stagger) + (geo.LiftingSurface.c(1,1)*0.25) + geo.LiftingSurface.le + (geo.LiftingSurface.c(3,1)*0.75))
if -geo.LiftingSurface.Stagger+geo.LiftingSurface.c(1,1)> geo.comprimento || geo.LiftingSurface.c(1,1)>geo.comprimento
	penal = 1;
	disp('Corda da asa inferior maior que o limite de comprimento');
elseif geo.LiftingSurface.Stagger+geo.LiftingSurface.c(2,1)> geo.comprimento || geo.LiftingSurface.c(2,1)>geo.comprimento
	penal = 1;
%tirei a condicao da asa superior(tentando deixar monoplano em todo o codigo)
    disp('Corda da ponta menor que 15 cm (asa inferiror)');
elseif geo.LiftingSurface.c(2,3)<=0.15
	penal = 1;

end

end
