function [penal,std] = estabilidade(geo,flc,sim,ard)
geo.mp.pos = [0;0;geo.cg.v];
if ard.alpha_estol > 20
    ard.alpha_estol = 20;
end
%% ========================== Constantes ==================================
kk = 0;
m = 17;                                                                     % Mtow de analise para rotacao
a = 0.95;                                                                   % Aceleracao no final da pista
deflexao = -15;                                                             % Deflexao maxima do profundor
flc.aoa = [-1 0 ard.alpha_estol];                                           % Aoa de analise no VLM
flc.Voo = 11.1;                                                             % Velocidade de analise
tp_xcg = 0.025;                                                             % Distancia em X entre o TP e o CG
tp_zcg = geo.cg.v;                                                          % Distancia em Z entre o TP e o CG
%% =================== Apenas pegando alguns valores ======================
tal = geo.LiftingSurface.tau;
penal = 0;
neta = 0.9;
std.neta = 0.9;
%% =================== Prealocando algumas variaveis ======================
cm = [0 0];
CA = zeros(3,3);
Mw = zeros(3,2);
Lw = Mw;
Dw = Mw;
%% ========================== Chamada VLM =================================
aoa = flc.aoa;
if sim.paralelo
    coeffs = VLMandap(geo,flc,sim,0,'-LiftingSurfaces');
else
    coeffs = VLManda(geo,flc,sim,0,'-LiftingSurfaces');
end
%% ======================= In????cio do Loop de CG ===========================
for kk = 0.23:0.01:0.29
    geo.cg.h = kk;
    geo.cg.pos(1)   = (geo.cg.h-0.25)*geo.LiftingSurface.c(1,3);
    geo.tp.pos(1)   = tp_xcg + geo.cg.pos(1);  
%% ==================== Posicoes com relacao ao CG ========================
geo.LiftingSurface.pos = -geo.LiftingSurface.pos;                           % Passando para eixos de estabilidade
geo.LiftingSurface.pos(:,1) = geo.cg.pos(1)*ones(3,1) + geo.LiftingSurface.pos(:,1);
geo.LiftingSurface.pos(:,3) = geo.cg.pos(3)*ones(3,1) + geo.LiftingSurface.pos(:,3);
geo.mp.pos = -geo.mp.pos;
%% ======================= Estabilidade Estatica ==========================
[E]=empuxo(flc.Voo,geo.mp.conjunto,flc.rho);
CT = E/(0.5*flc.rho*10^2*coeffs(1).Coeffs(1,1).Sref);                       % Coeficiente de tracao
Cmtm = CT*(geo.cg.pos(3) - geo.mp.pos(3))/coeffs(1).MAC;                                      % CM total do motor
deltaCG = 0;
%Calculo do Cm para alfa -1
for j=1:3                                                          %CM asas para alfa -1
    M = [0 -geo.LiftingSurface.pos(j,3) geo.LiftingSurface.pos(j,2); geo.LiftingSurface.pos(j,3) 0 -(geo.LiftingSurface.pos(j,1)+deltaCG); -geo.LiftingSurface.pos(j,2) (geo.LiftingSurface.pos(j,1)+deltaCG) 0]*([cosd(aoa(1)) 0 -sind(aoa(1));0 1 0;sind(aoa(1)) 0 cosd(aoa(1))]*[-coeffs(j).Coeffs(1,1).CD;0;-coeffs(j).Coeffs(1,1).CL]);
    cm(j) = M(2)/coeffs(1).MAC;% + coeffs(j).Coeffs(1,1).Cm25;
end
Cmt1 = sum(cm);                                            %CM total para alfa -1

%Calculo do Cm para alfa 0
for j=1:3                                                          %Cm asas para alfa 0
    M = [0 -geo.LiftingSurface.pos(j,3) geo.LiftingSurface.pos(j,2); geo.LiftingSurface.pos(j,3) 0 -(geo.LiftingSurface.pos(j,1)+deltaCG); -geo.LiftingSurface.pos(j,2) (geo.LiftingSurface.pos(j,1)+deltaCG) 0]*([cosd(aoa(2)) 0 -sind(aoa(2));0 1 0;sind(aoa(2)) 0 cosd(aoa(2))]*[-coeffs(j).Coeffs(1,2).CD;0;-coeffs(j).Coeffs(1,2).CL]);
    cm(j) = M(2)/coeffs(1).MAC;% + coeffs(j).Coeffs(1,2).Cm25;
end
Cmt0 = sum(cm);                                            %CM total para alfa 0      

Malpha_Q = (Cmt0 - Cmt1)/((aoa(2) - aoa(1))*pi/180)*coeffs(1).MAC*coeffs(1).Coeffs(1,1).Sref;

if Malpha_Q > -0.07                                                      %CMalpha
    penal = 1;
    fprintf('Estabilidade, M_alpha/Q = %.3f\n',Malpha_Q)
end

 %Calculo do Cm para alfa max
 for j=1:3                                                          %Cm asas para alfa max
     M = [0 -geo.LiftingSurface.pos(j,3) geo.LiftingSurface.pos(j,2); geo.LiftingSurface.pos(j,3) 0 -(geo.LiftingSurface.pos(j,1)+deltaCG); -geo.LiftingSurface.pos(j,2) (geo.LiftingSurface.pos(j,1)+deltaCG) 0]*([cosd(aoa(3)) 0 -sind(aoa(3));0 1 0;sind(aoa(3)) 0 cosd(aoa(3))]*[-coeffs(j).Coeffs(1,3).CD;0;-coeffs(j).Coeffs(1,3).CL]);
     cm(j) = M(2)/coeffs(1).MAC + coeffs(j).Coeffs(1,2).Cm25;
 end
 Cmtmax = sum(cm);
 
 if Cmtmax > Cmt1 || Cmtmax > Cmt0
     penal = 1;
     disp('Gado demais (Cmalpha crescente)')
 end
%% ============================= Controle =================================
%Calculo Cm para aoa max e def max
if ~penal
flc.aoa = [0 5];
coeffseh = VLManda(geo,flc,sim,0,'-EH');
CLalphadef = (coeffseh(1).Coeffs(1,end).CL - coeffseh(1).Coeffs(1,1).CL)/(flc.aoa(end)-flc.aoa(1));
CLpartmove = tal*CLalphadef*deflexao*coeffseh(1).Coeffs(1,1).Sref/coeffs(1).Coeffs(1,1).Sref;
std.CLprof = CLpartmove;
Mprof = neta*[0 -geo.LiftingSurface.pos(3,3) geo.LiftingSurface.pos(3,2); geo.LiftingSurface.pos(3,3) 0 -geo.LiftingSurface.pos(3,1); -geo.LiftingSurface.pos(3,2) geo.LiftingSurface.pos(3,1) 0]*([cosd(aoa(end)) 0 -sind(aoa(end));0 1 0;sind(aoa(end)) 0 cosd(aoa(end))]*[0;0;-CLpartmove]);
Cm_prof = Mprof(2)/coeffs(1).MAC;                                        %Calculo Cm profundor para def m??????????????????x e alfa m??????????????????x
for j=1:3                                                          %Cm asas para alfa 0
    M = [0 -geo.LiftingSurface.pos(j,3) geo.LiftingSurface.pos(j,2); geo.LiftingSurface.pos(j,3) 0 -(geo.LiftingSurface.pos(j,1)); -geo.LiftingSurface.pos(j,2) (geo.LiftingSurface.pos(j,1)) 0]*([cosd(aoa(end)) 0 -sind(aoa(end));0 1 0;sind(aoa(end)) 0 cosd(aoa(end))]*[-coeffs(j).Coeffs(1,3).CD;0;-coeffs(j).Coeffs(1,3).CL]);
    cm(j) = M(2)/coeffs(1).MAC + coeffs(j).Coeffs(1,3).Cm25;
end
Cm_total = sum(cm) + Cmtm  + Cm_prof;                    
if Cm_total < 0
    penal = 1;
    fprintf('Aeronave n????o trim????vel para o CG = %.3f\n',geo.cg.h)
end

% if ~penal
% CLpartmove = -CLpartmove;    
% Mprof = neta*[0 -geo.LiftingSurface.pos(3,3) geo.LiftingSurface.pos(3,2); geo.LiftingSurface.pos(3,3) 0 -geo.LiftingSurface.pos(3,1); -geo.LiftingSurface.pos(3,2) geo.LiftingSurface.pos(3,1) 0]*([cosd(aoa(2)) 0 -sind(aoa(2));0 1 0;sind(aoa(2)) 0 cosd(aoa(2))]*[0;0;-CLpartmove]);
% Cm_prof = Mprof(2)/coeffs(1).MAC;                                        %Calculo Cm profundor para def min e alfa min
% for j=1:3                                                          %Cm asas para alfa 1
%     M = [0 -geo.LiftingSurface.pos(j,3) geo.LiftingSurface.pos(j,2); geo.LiftingSurface.pos(j,3) 0 -(geo.LiftingSurface.pos(j,1)+deltaCG); -geo.LiftingSurface.pos(j,2) (geo.LiftingSurface.pos(j,1)+deltaCG) 0]*([cosd(aoa(2)) 0 -sind(aoa(2));0 1 0;sind(aoa(2)) 0 cosd(aoa(2))]*[-coeffs(j).Coeffs(1,2).CD;0;-coeffs(j).Coeffs(1,2).CL]);
%     cm(j) = M(2)/coeffs(1).MAC + coeffs(j).Coeffs(1,2).Cm25;
% end
% Cm_total = sum(cm) + Cm_prof; % Desconsiderando o motor pq a velocidade e alta
% if Cm_total > 0
%     penal = 1;
%     disp('Aeronave nao trimavel alfa min')
% end
% end
if ~penal
%% ===================== Posicoes com relacao ao TP =======================
CA(:,1) = geo.LiftingSurface.pos(:,1) + tp_xcg;
CA(:,3) = geo.LiftingSurface.pos(:,3) - tp_zcg;
CG = [tp_xcg;0;-tp_zcg];
%% ============================= Rotacao ==================================
pds = 0.5*flc.rho*flc.Voo^2*coeffs(1).Coeffs(1,1).Sref;                     % Pressao dinamica vezes area da asa
%Forcas
W = [0;0;m*flc.g];
Finercia = [-a*m;0;0];
Lt = [0;0;-neta*pds*coeffs(3).Coeffs(1,2).CL];
Dt = [-0.5*neta*pds*coeffs(3).Coeffs(1,2).CD;0;0];
Mt = [0; 0.5*neta*pds*coeffs(3).Coeffs(1,2).Cm25*coeffs(1).MAC;0];        
for j = 1:2
    Lw(:,j) = [0;0;-pds*coeffs(j).Coeffs(1,2).CL];
    Dw(:,j) = [-pds*coeffs(j).Coeffs(1,2).CD;0;0];
    Mw(:,j) = [0; pds*coeffs(j).Coeffs(1,2).Cm25*coeffs(1).MAC;0];
    Mw(:,j) = cross(CA(j,:)',((Lw(:,j)+Dw(:,j)))) + Mw(:,j);
end  
%Momentos
Mmotor = (geo.mp.pos(3))*E;
Mprof = CLpartmove*CA(3,1)*neta*pds;
Mcg = cross(CG,(Finercia+W));
Mt = cross(CA(3,:)',((Lt+Dt)+Mt));
Mtotal = Mmotor+Mcg(2)+sum(Mw(2,:))+Mt(2)+ Mprof;

if Mtotal < 1
    penal = 1;
    disp('Aeronave nao rotaciona p0ara ')
end
end
end
if ~penal
    std.cgzinho = geo.cg.h;
    break
end    
if penal && geo.cg.h < 0.29
    fprintf('Nao passou em estabilidade/controle/rotacao para o CGx = %f\n',geo.cg.h);
    penal = 0;    
end   
if penal && geo.cg.h == 0.29
    fprintf('Nao passou em estabilidade/controle/rotacao para o CGx = %f\n',geo.cg.h);
end
end
