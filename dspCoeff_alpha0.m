function [surf, ev, sp] = dspCoeff_alpha0(geo,flc,sim,v_tas,v_reduzido) 
%% Inicializacao 
CL          = zeros(1,length(v_reduzido)); 
CD          = zeros(1,length(v_reduzido)); 
CM          = zeros(1,length(v_reduzido)); 
 
sp.CD       = zeros(1,length(v_reduzido)); 
 
CL_ajustada = zeros(1,length(v_reduzido)); 
CD_ajustada = zeros(1,length(v_reduzido)); 
CM_ajustada = zeros(1,length(v_reduzido)); 
 
ev.CD       = zeros(1,length(v_reduzido)); 
sp.CD       = zeros(1,length(v_reduzido)); 
 
%% OBTENCAO DOS COEFICIENTES AERODINAMICOS 
surfacenum	= geo.LiftingSurface.surfacenum; 
plotar      = 0; 
flc.Voo     = v_reduzido; 
flc.aoa     = 0; 

if sim.paralelo
    coef        = VLMandap(geo, flc, sim, 0, '-LiftingSurfaces'); 
else
    coef        = VLManda(geo, flc, sim, 0, '-LiftingSurfaces');
end
 
% Coeficientes de sustentacao e arrasto para o ang de ataque nulo 
for c = 1:length(v_reduzido) 
    for i = 1:surfacenum 
        CL(i,c) = coef(i).Coeffs(c).CL; 
        CD(i,c) = coef(i).Coeffs(c).CD; 
        CM(i,c) = coef(i).Coeffs(c).Cm25; 
    end 
    %CDev(c)     = 2*0.02962*exp(-0.1025*flc.Voo);  %Aeronave 2019 
end 
 
ev.CD    = (0.0504.*v_tas.^(-0.4).*exp(-0.084.*v_tas.^0.6)+0.0015).*(0.0828./geo.LiftingSurface.Sw(1,1)); 
 
[CDsp_t] = arrasto_sempolar(geo); 
  
sp.CD(1:length(v_tas)) = CDsp_t;                              
 
ev.CD = 1.20*ev.CD; 
sp.CD = 1.00*sp.CD; 
CD    = 1.20*CD; 
 
%% AJUSTE DE CURVAS 
% Superficies sustentadoras 
for i = 1:surfacenum 
    CL_ajustada    = fit(v_reduzido', CL(i,:)',  'smoothingspline', 'SmoothingParam', 0.5); 
    CD_ajustada    = fit(v_reduzido', CD(i,:)',  'smoothingspline', 'SmoothingParam', 0.5); 
    CM_ajustada    = fit(v_reduzido', CM(i,:)',  'smoothingspline', 'SmoothingParam', 0.5); 
 
    surf.CL(i,:)   = CL_ajustada(v_tas); 
    surf.CD(i,:)   = CD_ajustada(v_tas); 
    surf.CM(i,:)   = CM_ajustada(v_tas); 
end 
end