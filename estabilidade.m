% Estabilidade 2022 - Vitor José

function [penal,std] = estabilidade(geo,flc,sim,ard)
% Tentativa - 0.035 CG - 60 cm - 
% Margem 5 %
% Inicializacao
penal =  0;
std.CLprof = 0;

ProfID = geo.LiftingSurface.surfacenum;
Sref   = geo.LiftingSurface.Sw(1);
Cref   = geo.MAC;

m   = 13;
Iyy = 477402610*(0.001)^3+m*0.15^2;
a   = 0.1;

%% Estabilidade estatica 
% CM_alpha deve ser negativo - A curva de CM deve ser decrescente
% freq = 1.5;
% omega_n = freq;
% Req_Malpha_Q = -omega_n^2*Iyy/(0.5*flc.rho*flc.Voo^2)
% Req_Malpha_Q = -0.07;

% Calcular margem estatica maior que 6 %
Req_margem = 0.06;

% coeffs    => Sai do VLM
% coef      => Transposicao da estrutura
% coeff     => Ajuste
arf = min([ard.alpha_estol 20]);
std.arf = arf;
aoa_min  = -2;
aoa_step = 3;
step     = 3;
flc.aoa = [aoa_min:aoa_step:ard.alpha_estol-1 ard.alpha_estol];
if sim.paralelo
    coeffs = VLMandap(geo,flc,sim,0,'-LiftingSurfaces');
else
    coeffs = VLManda(geo,flc,sim,0,'-LiftingSurfaces');
end

if coeffs(3).penal
    fprintf('Penalizada no coeficiente\n')
    penal = 1;
    return
end

for j=1:geo.LiftingSurface.surfacenum
    for i = 1:length(coeffs(j).Coeffs)
        coef(j).CL(i) = coeffs(j).Coeffs(i).CL;
        coef(j).CD(i) = coeffs(j).Coeffs(i).CD;
        coef(j).Cm25(i) = coeffs(j).Coeffs(i).Cm25;
    end
    coeff.fit(j).CL = fit(flc.aoa',coef(j).CL','linearinterp');         % Nesse loop e feito o fit dos coeficientes (apenas para simplificar o acesso aos coeficientes)
    coeff.fit(j).CD = fit(flc.aoa',coef(j).CD','linearinterp');
    coeff.fit(j).Cm25 = fit(flc.aoa',coef(j).Cm25','linearinterp');
end
std.coeff_aoa = coeff;

% Mude a posicao do CG aqui
cg = 0.07:-0.005:-0.03;
% cg = 0.02
for cg_provisorio = cg
    geo.cg.pos(1) = cg_provisorio;
    s.pos = -(geo.LiftingSurface.pos-geo.cg.pos);

    k = 1;
    for aoa = aoa_min:step:arf
        for j=1:geo.LiftingSurface.surfacenum
            M = [0 -s.pos(j,3) s.pos(j,2); s.pos(j,3) 0 -s.pos(j,1); -s.pos(j,2) s.pos(j,1) 0]*([cosd(aoa) 0 -sind(aoa);0 1 0;sind(aoa) 0 cosd(aoa)]*[-coeff.fit(j).CD(aoa);0;-coeff.fit(j).CL(aoa)]);
            Cm(j) = M(2)/geo.MAC + coeff.fit(j).Cm25(aoa);
            CL(j) = coeff.fit(j).CL(aoa);
        end
        CL_plot(k) = sum(CL);    
        Cm_plot(k) = sum(Cm);
        alpha_plot(k) = aoa;
        k = k+1;
    end  
    
    Cm_alpha = (Cm_plot(2:end)-Cm_plot(1:end-1))./((alpha_plot(2:end)-alpha_plot(1:end-1))*pi/180);
    CL_alpha = (CL_plot(2:end)-CL_plot(1:end-1))./((alpha_plot(2:end)-alpha_plot(1:end-1))*pi/180);
    
    Cond_neg = prod(sort(Cm_plot) == flip(Cm_plot));    % Condicao de derivada negativa
    Cond_margem = prod(Cm_alpha./CL_alpha <= -Req_margem);     % COndicao de obedecer margem estatica
    plot(alpha_plot(2:end),-Cm_alpha./CL_alpha)
title('Margem estatica')
    if  Cond_neg && Cond_margem
        std.cg = geo.cg.pos(1);
        fprintf('Passou em estabilidade estatica com CG %5.3f m atras do CA.\n',geo.cg.pos(1))
        break
    elseif cg_provisorio == cg(end)
        fprintf('Nao passou em estabilidade estatica :(\n')
        penal = 1;
        return
    end 
end

% disp('Continuou')
% Plot

% figure
% plot(alpha_plot(2:end),-Cm_alpha./CL_alpha)
% title('Margem estatica')
figure
plot(alpha_plot(2:end),Cm_alpha)
title('Cm_alpha')
figure
plot(alpha_plot(2:end),CL_alpha)
title('CL_alpha')

% 
% grid on;
% xlabel('Alpha (Graus)')
% ylabel('Cm Total')
% title('Cm x alpha')
%% Rotacao
deflexao0 = geo.LiftingSurface.incidence(ProfID);
% deflexao = ard.estoleh;
deflexao = ard.def;


flc.aoa = 10;
geo.LiftingSurface.incidence(ProfID) = deflexao;
coeffs2 = VLManda(geo,flc,sim,0,'-LiftingSurfaces');

if coeffs2(3).penal
    fprintf('Penalizada no coeficiente\n')
    penal = 1;
    return
end

std.CLprof = coeffs2(ProfID).Coeffs.CL-coeff.fit(ProfID).CL(flc.aoa);
std.CLdeltae = std.CLprof/(deflexao-deflexao0);

% Inicializacao 
i       = 1;
t       = 0;
theta   = 0;        % Angulo entre referenciais
dt      = 0.005;    % Infinitesimal de tempo
thetaum = 0;        % Vel. angular

% Posicoes
CA = zeros(3,ProfID);                % Prealocacao
for aux_s = 1:ProfID
    CA(:,aux_s) = [s.pos(aux_s,1) + geo.tp.pos(1);0;s.pos(aux_s,3) + geo.tp.pos(3)];
end 
CAt = CA(:,ProfID);

% Centro de gravidade
Xcg = geo.tp.pos(1);
Zcg = geo.tp.pos(3);
CG  = [Xcg;0;Zcg];

% Motor
T = [empuxo(flc.Voo,geo.mp.conjunto,flc.rho);0;0];
Zmotor = -(geo.mp.pos(3)-geo.tp.pos(3));
ENG    = [0;0;Zmotor];

% Peso
W = [0;0;m*flc.g];

% Forca inercial
Finercia = [-a*m;0;0];

% Loop - Nao e necssario
% while theta < arf  % Para loop apenas descomentar o while e o if t > 2
    E1 = [cosd(theta) 0 -sind(theta); 0 1 0 ; sind(theta) 0 cosd(theta)];
    
    % Momento das asas
    for j = 1:ProfID-1
        alpha = theta; % - geo.s.deda(j)*theta - geo.s.eo(j); % ?
        
        Lw(:,j) = [0;0;-0.5*flc.rho*(flc.Voo^2)*Sref*coeff.fit(j).CL(alpha)];
        Dw(:,j) = [-0.5*flc.rho*(flc.Voo^2)*Sref*coeff.fit(j).CD(alpha);0;0];
        Mw(:,j) = [0; 0.5*flc.rho*(flc.Voo^2)*Sref*coeff.fit(j).Cm25(alpha)*Cref;0];
    
        M(:,j) = cross(CA(:,j),(E1*(Lw(:,j)+Dw(:,j))));
    end
    
    % Momento do profundor
    Lt = [0;0;-0.5*flc.rho*(flc.Voo^2)*Sref*(coeff.fit(ProfID).CL(alpha)+std.CLprof)];
    Dt = [-0.5*flc.rho*(flc.Voo^2)*Sref*coeff.fit(ProfID).CD(alpha);0;0];
    Mt = [0; 0.5*flc.rho*(flc.Voo^2)*Sref*coeff.fit(ProfID).Cm25(alpha)*Cref;0];
    
    Mprof = cross(CAt,(E1*(Lt+Dt)))+Mt;
    
    % Momento do motor
    Mmotor = cross(ENG,T);
    
    % Momento inercial
    Mcg = cross(CG,(E1*(Finercia+W)));
    
    % Momento totalLt
    Mtotal = sum(M(2,:))+sum(Mw(2,:))+Mprof(2)+Mmotor(2)+Mcg(2);
    
    if  Mtotal < 0 && theta == 0
        Mtotal = 0;
    end
    
    theta = theta*pi/180;       % Trasnformacao de graus para radianos
    thetadois = Mtotal/Iyy; % Aceleracao angular

    thetaum = thetaum + thetadois*dt; % Velocidade angular
    theta = theta + thetaum*dt + thetadois*dt^2/2; 
    
    t = t + dt;
    theta = theta*180/pi; % Trasnformacao de radianos para graus
    
%     % Para o plot
%     Mtotal_plot(i) = Mtotal; 
%     theta_plot(i) = theta;
%     tempo_plot(i) = t;
%     % Mcg = cross(CG,(E1*W))+cross(CG,(E1*Finercia));
%     Mcg_plot(i) = Mcg(2);
%     M_prof_plot(i) = Mprof(2);
%     M_motor_plot(i) = Mmotor(2);
%     
% for j = 1:ProfID-1
%     M_plot(i,j) = M(2,j)+Mw(2,j);
% end
    i = i+1;
    if Mtotal < 0 % t > 2
%        theta = arf + 2;
        disp('Nao rotacionou :(');
        penal = 1;
        return
    end 
%end
fprintf('Rotacionou!\n')

% figure(1); hold on
% for j = 1:ProfID-1
%     plot(tempo_plot,M_plot(:,j))
%     legenda(j) = {['Asa ' num2str(j)]};
% end
% plot(tempo_plot,Mcg_plot,tempo_plot,M_prof_plot,tempo_plot,M_motor_plot,tempo_plot,Mtotal_plot);
% legenda = {legenda{1:end} 'Forças Inerciais' 'EH + Profundor' 'Motor' 'Momento Total'};
% legend(legenda)
% xlabel('Tempo (s)')
% ylabel('Momento (N*m)')
% grid on
% 
% figure(2)
% plot(tempo_plot, theta_plot)
% xlabel ('Tempo (s)')
% ylabel ('AoA (graus)')
% grid on
% 
% figure(3)
% aoa = 0:.5:arf;
% plot(aoa,coeff.fit(1).CL(aoa)+coeff.fit(2).CL(aoa))
% ylabel ('CL global')
% xlabel ('AoA (graus)')
% grid on

%% Trimagem
lim_inferior = ard.estoleh;
lim_superior = 10;
M = Cm_plot.*0.5.*flc.Voo^2.*flc.rho.*Sref.*Cref-empuxo(flc.Voo,geo.mp.conjunto,flc.rho)*geo.mp.pos(3);
Lprof = -M./s.pos(ProfID,1);
CLprof = Lprof./(0.5.*flc.Voo^2.*flc.rho.*Sref);
deflex = deflexao0+(CLprof./std.CLprof)*deflexao;

dmin = min(deflex);
dmax = max(deflex);

std.alpha_plot = alpha_plot;
std.CLprof_plot = CLprof;
std.deflex_plot = deflex;

if dmin < lim_inferior || dmax > lim_superior
        fprintf('Nao trimavel :( %4.1f° e %4.1f°\n',dmin,dmax)
        penal = 1;
        return
end
fprintf('Trimagem defletindo entre %4.1f° e %4.1f°\n',dmin,dmax)
std.range = abs(dmax-dmin);
% plot(alpha_plot,deflex);
% grid on;