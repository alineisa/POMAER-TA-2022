function [CDsp_t] = arrasto_sempolar(geo)
%% Variaveis de saida:
% CD_supw   = Coeficiente de arrasto do suporte de carga
% CD_montw = Coeficiente de arrasto do montante trelicado
% CD_boomw = Coeficiente de arrasto do boom trelicado
% CD_tpw   = Coeficiente de arrasto do trem de pouso
% CD_servw = Coeficiente de arrasto do servo do motor
% CD_linww = Coeficiente de arrasto das linkagens
%%  Suporte de cargas                     
%    Frontal                    Lateral
%   _________              __________________ 
%  |         |            |                  |      
%  |         | H          |                  |  H
%  |         |            |                  |         
%  |_________|            |__________________|   
%       L                           C
%% Coeficientes
CD_trem = 0.008;        % Coeficiente retirado do relatório de 2020, com área de referência igual a 0.83m^2
Cd_tubo = 1.17;         % Coeficiente bidimansional de secao circular. Referência na espessura do tubo;
CD_box  = 0.29;          % Coeficient tridimensional de arrasto do suporte, e relacaoo a area frontal. Carenado.
CD_cil  = 1.0;          % Coeficient tridimensional de arrasto de um cilindro de frente, e relacaoo a area frontal;

%% Entrada
Sw      = geo.LiftingSurface.Sw(1);      % Area Projetada da asa
%======================== Suporte de carga ================================
Volume_sup = 0.0019;                 % [m^3] Volume estimado para o suporte de cargas
CG = 0.25;                           % Posicao estimada do CG
comp_ate_cg = -geo.LiftingSurface.Stagger+CG*geo.LiftingSurface.c(1,1); % [m] Distancia do bordo de ataque da asa superior até o CG

L = 0.1;                             % [m] Largura da trelica e suporte
C = 2*(comp_ate_cg-geo.bico);        % [m] Cooprimento do suporte
H = Volume_sup/(L*C);                % [m] Altura do suporte

S_supo = H*L;                        % [m^2] Area de referência di suporte
%=========================== Trelica ======================================
D_mont = 0.004;                      % [m] Diâmetro do tubo de carbono do montante
H_mont = geo.LiftingSurface.Gap-H;   % [m] Altura do montante trelicado
Qv_mont = 2;                         % [ ] Quantidade de tubos alinhas por comprimento na vertical
Qh_mont =(-2.5+6*geo.LiftingSurface.Gap); % [ ] Quantidade de tubos na horizontal;

Sv_tubo = D_mont*H_mont*Qv_mont;     % [m^2] Area dos tubos na vertical
Sh_tubo = D_mont*L*Qh_mont;          % [m^2] Area dos tubos na horizontal

D_boom = 0.0035;
H_boom = geo.LiftingSurface.pos(3,3)-geo.LiftingSurface.pos(2,3); % [m] Altura do boom
%=========================== Trem de pouso ================================
S_tp   = 0.83;                       %[m^2] Area de referência do coeficiente de arrasto do trem de pouso
%============================= Linkagem ===================================
Q_link   = 2;                        % [ ] Quantidade dos tubos de linkagem
D_link   = 1.4e-3;                   % [m] Diametro do tubo de linkagem

S_link   = Q_link*pi*((D_link/2)^2); % [m^2] Área frontal dos tubos
%=============================== Servo  ===================================
H_servo  = 19.5e-3;                                                     
L_servo  = 38e-3;     

S_servo  = H_servo*L_servo;
%% Cálculo dos coeficientes de arrasto
%======================== Suporte de carga ================================
CD_supw = CD_box*S_supo/Sw;

%=========================== Trelica ======================================
CD_montw = Cd_tubo*(Sv_tubo+Sh_tubo)/Sw;
CD_boomw = CD_montw*(H_boom/H_mont)*(D_boom/D_mont);

%=========================== Trem de pouso ================================
CD_tpw = CD_trem*S_tp/Sw;

%============================= Linkagem ===================================
CD_linw = CD_cil*S_link/Sw;

%=============================== Servo  ===================================
CD_servw = CD_box*S_servo/Sw;

CDsp_t = CD_servw+CD_linw+CD_tpw+CD_boomw+CD_montw+CD_supw;
end

%% REFERENCIAS:

% Equacoes e tabelas conseguidos em:
% http://faculty.dwc.edu/sadraey/Chapter%203.%20Drag%20Force%20and%20its%20Coefficient.pdf
% Coeficiente de arrasto medio de uma secao retangular: file:///C:/Users/amand/Downloads/Aerodynamics%20and%20Flight%20Mechanics.pdf;
% Coeficiente de arrasto medio de uma secao circular: https://avionicsengineering.files.wordpress.com/2016/11/john-d-anderson-jr-fundamentals-of-aerodynamics.pdf,pï¿½gina 318; http://professor.ufabc.edu.br/~roldao.rocha/wordpress/wp-content/uploads/Est_Docente_Q3-2017.pdf
% Calculo do diametro equivalente realizado segundo Barros. [pag. 4.4.3-2]
