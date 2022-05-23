function [surf] = dspCoeff_varalpha_Lucy(geo,flc,sim,ard,std)
% Funcao para obter os coeficientes aerodinamicos das asas e eh
% considerando varia��o do alpha (rota��o) e da velocidade
% Considerando a aeronave como partmove = alpha da asa e igual ao alpha da eh
    
%% Inicializacao
surfacenum  = geo.LiftingSurface.surfacenum;

CLarf = zeros(1,surfacenum);
CDarf = zeros(1,surfacenum);

%% Coeficientes de sustentacao e arrasto variando o ang de ataque da asa
flc.Voo     = 10 + flc.v_vento;

lim2        = ard.alpha_estol - 5;
alpha1      = [0 lim2/2 lim2];
alpha2      = lim2+.5:.5:ard.alpha_estol;
alpha       = [alpha1 alpha2];
flc.aoa     = alpha;

coef        = VLManda(geo, flc, sim, 0, '-wings');

for i=1:length(alpha)
    for s = 1:surfacenum-1
        CLarf(s,i) = coef(s).Coeffs(i).CL;
        CDarf(s,i) = coef(s).Coeffs(i).CD;
    end
end

dt          = [0:0.01:0.6];
alpha       = [0:ard.alpha_estol/(length(dt)-1):ard.alpha_estol];

%% Ajuste dos coeficientes aerodinamicos
for i = 1:surfacenum-1
    CL_ajustada     = fit(flc.aoa', CLarf(i,:)',  'smoothingspline', 'SmoothingParam', 0.5);
    CD_ajustada     = fit(flc.aoa', CDarf(i,:)',  'smoothingspline', 'SmoothingParam', 0.5);
    
    surf.CLarf(i,:)    = CL_ajustada(alpha);
    surf.CDarf(i,:)    = CD_ajustada(alpha);
end


% Coeficientes da empenagem horizontal a partir do ajuste da rede neural
flc.aoa     = alpha - std.deda*alpha - std.eo*ones(1,length(alpha)) + geo.LiftingSurface.incidence(3,1)*ones(1,length(alpha));
coefEH      = Lucy(geo,flc);
coefEH      = coefEH*geo.LiftingSurface.Sw(3)/geo.LiftingSurface.Sw(1);
surf.CLarf(3,:)  = coefEH(1,:) + std.CLprof;
surf.CDarf(3,:)  = coefEH(2,:);


surf.alpha = alpha;
surf.CDarf = 1.00*surf.CDarf;
surf.CLarf = 1.00*surf.CLarf;

end