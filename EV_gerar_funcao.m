clear; close all; clc;
% flc.v_vento = 1;
% v1         = 0:0.3:1.5;
% v2         = 2:.5:10;
% v3         = 11:15;
% v_reduzido = [v1, v2, v3];
% v_reduzido = v_reduzido + flc.v_vento;
v_reduzido = [2.65 4.45 6.25 8.05 9.85 11.65 13.45 15.0];

aviao = Airplane;

aviao.LiftingSurfaces.IsMain = 1;
aviao.LiftingSurfaces.label = 'Asa principal';
aviao.LiftingSurfaces.Geo.Yb = [0    0.23];
aviao.LiftingSurfaces.Geo.C = [0.18 0.18];
aviao.LiftingSurfaces.Geo.Dihedral = [0];
aviao.LiftingSurfaces.Geo.Sweep = [0];
aviao.LiftingSurfaces.Geo.TwistY = [0 0 0 0];
aviao.LiftingSurfaces.Geo.Incidence = 0;
aviao.LiftingSurfaces(1).Geo.pos.x = 0;
aviao.LiftingSurfaces(1).Geo.pos.y = 0;
aviao.LiftingSurfaces(1).Geo.pos.z = 0;
perfil(1) = ImportObj('NACA0012.mat');
aviao.LiftingSurfaces(1).Aero.Airfoils.Data = [perfil(1) perfil(1)];

aviao.UpdateGeo;
%aviao.PlotGeo('-airfoils','-nimage',5);

%% - Malha
aviao.LiftingSurfaces(1).Aero.Mesh.Ny = [10];
aviao.LiftingSurfaces(1).Aero.Mesh.TypeY = [3];
 
aviao.UpdateAeroMesh;
%aviao.PlotMesh;
%% - Condições de voo
condicao = FlightConditions;

condicao.rho = 1.112;
condicao.alpha = 0;

%% - Solver
for j = 1:length(v_reduzido)
    condicao.Voo = v_reduzido(j);
    NL_VLM(aviao, condicao,'-append','-itermax',20);

    CLplane(j) = aviao.Aero.Coeffs(j).CL;
    CDplane(j) = aviao.Aero.Coeffs(j).CD; 
    CDev(j)     = 0.02962*exp(-0.1025*condicao.Voo);
    CD(j)          = 0.0504*condicao.Voo^(-0.4)*exp(-0.084*condicao.Voo^0.6)+0.0015;
end
plot(v_reduzido,CDplane,v_reduzido,CD);

