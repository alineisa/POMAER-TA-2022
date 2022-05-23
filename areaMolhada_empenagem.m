%% �REA MOLHADA DA EMPENAGEM
function [areawet] = areaMolhada_empenagem(cr,cp,b,airfoil)
%% Nomenclatura

%DADOS DE SA�DA:
    % areawet => �rea molhada da empenagem (horizontal ou vertical)
    
%DOADOS DE ENTRADA:
    % cp        => Corda da ponta da empenagem;
    % cr        => Corda da raiz da empenagem;
    % b         => Envergadura da empenagem.


%% C�lculos

% Perfil da empenagem vertical:
perfil  = strcat('MACACO\CURVAS\', airfoil,'.mat');
perfil  = ImportObj('MACACO\CURVAS\NACA0015.mat');
x       = perfil.xy(:,1);
y       = perfil.xy(:,2);
perf    = [x y];

% Multiplicando perfil unit�rio pela corda:
perfil_ponta_ht = cp*perf;
perfil_raiz_ht  = cr*perf;
    
% Per�metro de cada perfil. Somat�ria da dist�ncia entre cada ponto:
comp_ponta_ht   = sum(sqrt(diff(perfil_ponta_ht(:,1)).^2 + diff(perfil_ponta_ht(:,2)).^2));
comp_raiz_ht    = sum(sqrt(diff(perfil_raiz_ht(:,1)).^2 + diff(perfil_raiz_ht(:,2)).^2));
    
% �rea superior da empenagem vertical:
area_lateral    = polyarea(perfil_ponta_ht(:,1), perfil_ponta_ht(:,2));

areawet         = (comp_ponta_ht + comp_raiz_ht)*b*0.5 + 2*area_lateral;

%% Refer�ncias
% Geometria Anal�tica.