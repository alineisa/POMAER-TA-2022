function [surf, ev, fu, tp] = dspCoeff_alpha0_Lucy(geo,flc,sim,v_tas,v_reduzido,std)

%% Inicializacao
CL          = zeros(1,length(v_reduzido));
CD          = zeros(1,length(v_reduzido));

CDev        = zeros(1,length(v_reduzido));
fu.CD       = zeros(1,length(v_reduzido));
tp.CD       = zeros(1,length(v_reduzido));

CL_ajustada = zeros(1,length(v_reduzido));
CD_ajustada = zeros(1,length(v_reduzido));

ev.CD       = zeros(1,length(v_reduzido));
fu.CD       = zeros(1,length(v_reduzido));
tp.CD       = zeros(1,length(v_reduzido));

%% OBTENCAO DOS COEFICIENTES AERODINAMICOS
surfacenum	= geo.LiftingSurface.surfacenum;
plotar      = 0;

% Coeficientes da empenagem horizontal a partir do ajuste da rede neural
flc.aoa     = - std.eo + geo.LiftingSurface.incidence(3,1);
flc.Voo     = v_reduzido;
coefEH      = Lucy(geo,flc);
coefEH      = coefEH*geo.LiftingSurface.Sw(3)/geo.LiftingSurface.Sw(1);
CL(3,:)     = coefEH(1,:);
CD(3,:)     = coefEH(2,:);

% Coeficientes de sustentacao e arrasto para o ang de ataque nulo para asas 
for c = 1:length(v_reduzido)
    flc.Voo     = v_reduzido(c);
    flc.aoa     = 0;
    coef        = VLManda(geo, flc, sim, 0, '-wings');

    for i = 1:surfacenum-1
        CL(i,c) = coef(i).Coeffs.CL;
        CD(i,c) = coef(i).Coeffs.CD;
    end

    CDev(c)     = 2*0.02962*exp(-0.1025*flc.Voo);
end

for c=1:length(v_reduzido)
    flc.Voo = v_reduzido(c);
    [cdl,cdservo,cdeb,cdem,cdtp] = arrasto_sempolar(geo,flc);

    tp.CD(c) = cdtp;                            % arrasto do trem de pouso
    fu.CD(c) = cdl + cdservo + cdeb + cdem;     % arrasto do boom, montantes e servos
end

fu.CD = 1.00*fu.CD;
tp.CD = 1.00*tp.CD;
CD    = 1.00*CD;

%% AJUSTE DE CURVAS
% Superficies sustentadoras
for i = 1:surfacenum
    CL_ajustada    = fit(v_reduzido', CL(i,:)',  'smoothingspline', 'SmoothingParam', 0.5);
    CD_ajustada    = fit(v_reduzido', CD(i,:)',  'smoothingspline', 'SmoothingParam', 0.5);

    surf.CL(i,:)   = CL_ajustada(v_tas);
    surf.CD(i,:)   = CD_ajustada(v_tas);
end

% ev
ev.CD = fit(v_reduzido', CDev',  'smoothingspline', 'SmoothingParam', 0.5);
ev.CD = ev.CD(v_tas);

% fu
fu.CD = fit(v_reduzido', fu.CD', 'smoothingspline', 'SmoothingParam', 0.5);
fu.CD = fu.CD(v_tas);

% tp
tp.CD = fit(v_reduzido', tp.CD', 'smoothingspline', 'SmoothingParam', 0.5);
tp.CD = tp.CD(v_tas);

end