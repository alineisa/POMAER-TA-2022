function [PesoVazio,M] = EstimaMassa (geo, mtow)

cd 'Estimativa_de_massa'

% function [PesoVazio,M] = EstimaMassa (bw,croot,ctip,b_t,mtow,beh,creh,cteh,hvt1,hvt2,hvt3,crev1,crev2,crev3,cpev1,cpev2,cpev3,choice)

%% DADOS DE ENTRADA %%
%  tic
% env.asa   = bw;    % [m] Envergadura da asa
% cr.asa    = croot; % [m] Corda da raiz da asa
% cp.asa    = ctip;  % [m] Corda da ponta da asa
% ret.asa   = b_t;   % Porcentagem retangular da asa
% % 
% MTOW      = mtow;  % [kg] MTOW
% % 
% env.prof  = beh;   % [m] Envergadura profundor
% cr.prof   = creh;  % [m] Corda da raiz profundor
% cp.prof   = cteh;  % [m] Corda da ponta profundor
% % 
% env.leme1 = hvt1;  % [m] Envergadura leme
% cr.leme1  = crev1; % [m] Corda da raiz leme
% cp.leme1  = cpev1; % [m] Corda da ponta leme
% % 
% env.leme2 = hvt2;  % [m] Envergadura leme
% cr.leme2  = crev2; % [m] Corda da raiz leme
% cp.leme2  = cpev2; % [m] Corda da ponta leme
% % 
% env.leme3 = hvt3;  % [m] Envergadura leme
% cr.leme3  = crev3; % [m] Corda da raiz leme
% cp.leme3  = cpev3; % [m] Corda da ponta leme
%% DADOS DE ENTRADA %%
env.asa   = geo.LiftingSurface.B(1,1);    % [m] Envergadura da asa
cr.asa    = geo.LiftingSurface.c(1,1);    % [m] Corda da raiz da asa
cp.asa    = geo.LiftingSurface.c(1,3);		% [m] Corda da ponta da asa
ret.asa   = geo.LiftingSurface.pest(1,1);% Porcentagem retangular da asa
gap       = geo.LiftingSurface.Gap;

MTOW      = mtow;					% [kg] MTOW
% 
env.prof  = geo.LiftingSurface.B(3,1);				% [m] Envergadura profundor
cr.prof   = geo.LiftingSurface.c(3,1);				% [m] Corda da raiz profundor
cp.prof   = geo.LiftingSurface.c(3,1);				% [m] Corda da ponta profundor
% 
env.leme = geo.ev.B;					% [m] Envergadura leme
cr.leme  = geo.ev.c(1);				% [m] Corda da raiz leme
cp.leme  = geo.ev.c(2); 				% [m] Corda da ponta leme

choice	 = geo.mp.conjunto;

%% MASSAS %%

M.Rodab  = 0.028;  % Roda bequilha sem oring 0.02
M.Rodat  = 0.030; % Roda trem de pouso sem oring 0.025
M.Oring  = 0.006; % Oring
M.Mancal = 0.012; % Mancal da bequilha
M.Rola   = 0.004; % Rolamento
M.Trem   = 0.050; % Trem de pouso
M.Par    = 0.006; % Parafusos, arruelas e porcas
M.Tanque = 0.022; % Tanque de combustível
M.Beq    = 0.012; % Bequilha
M.Fus    = 0.160; % Fuselagem entelada
M.Fio    = 0.013; % [kg/k] Fiação, com conector, por metro
M.Servop = 0.045;  % Servo profundor 0.03
M.Servol = 0.017*4; % Servo leme
M.Servob = 0.018; % Servo bequilha
M.Servom = 0.01;  % Servo motor
M.Ubeck  = 0.028; % Ubeck
% M.Bat    = 0.042; % Bateria
M.Recep  = 0.023; % Receptor
M.Freio  = 0.035; % Conjunto freio com servo
M.Volt   = 0.005; % Voltwatch

if choice == 0
    M.Mot = .048 + .688 + 0.042; % APC 13x4 + Magnum.61
elseif choice == 1
    M.Mot = .040 + .688 + 0.042; % APC 12.25 + Magnum.61
elseif choice == 2
    M.Mot = .040 + .520 + 0.042; % APC 12.25 + OS.55
elseif choice == 3
    M.Mot = .048 + .232 + 0.42 + 0.020 + 0.227; % Helice kbulosa braba de bh by Lucas C e Joshin (SK 200KV)
end
%%
% if geo.w.flap > 0
%      M.Flap = 0.11;
%  else
      M.Flap = 0;
% end
% % 
% if geo.w.e(1) >= 5 && geo.w.e(2) >= 10
%      M.Enf1 = 0.05;
% else
      M.Enf1 = 0;
% end
% %     
% if geo.w.pb(2) >= 0.03 && geo.w.e(2) >= 10
%      M.Enf2 = 0.05;
% else
   M.Enf2 = 0;
% end
% % 
% if geo.w.d(2) < -3
%      M.died = 0.02;
% else
   M.died = 0;
% end

if env.prof>1.5
   M.FixProf=(9.9892e-6)*exp(4.606*env.prof)+.050;
else
    M.FixProf=0;
end

%%
[M.Asa,Rtubo] = Asa_balsa (env.asa,cr.asa,cp.asa,ret.asa,MTOW);             % Massa asa completa
% M.asa = 0.409040555547619;
% Rtubo = 0.003;
% keyboard;
[M.Prof]      = Profundor (env.prof,cr.prof,cp.prof);                       % Massa profundor completo
[M.Leme]      = Leme (env.leme,cr.leme,cp.leme);                            % Massa leme
[M.Trelica]   = Trelica (gap);
% M.Mont=(0.1/0.6)*gap;                                                        %Massa Montantes da aeronave
% 
% if gap>=0.6 && gap<0.7
%     M.Mont=M.Mont+0.020;
% elseif gap>=0.7 && gap<0.8
%     M.Mont=M.Mont+0.040;
% elseif gap>=0.8 && gap<0.9
%     M.Mont=M.Mont+0.060;
% elseif gap>=0.9 && gap<1.0
%     M.Mont=M.Mont+0.080;
% elseif gap>=1.0 && gap<1.1
%     M.Mont=M.Mont+0.100;
% elseif gap>=1.1 && gap<1.2
%     M.Mont=M.Mont+0.120;
% elseif gap>=1.2 && gap<1.3
%     M.Mont=M.Mont+0.140;
% elseif gap>=1.3 && gap<1.4
%     M.Mont=M.Mont+0.160;
% end

M.Fuscomp     = M.Fus+M.Mancal+4*M.Par+M.Tanque+M.Servob+M.Servom;          % Fuselagem completa
M.Conjtrem    = M.Rodab+2*M.Rodat+3*(M.Oring+M.Rola)+M.Trem+M.Beq+M.Freio;  % Conjunto trem de pouso
M.Emp         = M.Servop+M.Servol;              							% Empenagens
M.Elet        = 2*M.Fio+M.Ubeck+M.Recep+M.Volt;                       % Elétrica

PesoVazio = 2*M.Asa+M.Fuscomp+M.Conjtrem+M.Elet+M.Mot+M.Flap+M.Enf1+M.Enf2+M.died+M.Prof+M.Emp+M.Leme+M.Trelica+M.FixProf;                  % Peso vazio total

% M.PesoVazio = PesoVazio;

cd ..
end