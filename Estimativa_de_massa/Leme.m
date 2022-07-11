function [M] = Leme (env,cr,cp)

%% DADOS DE ENTRADA %%

esp = 0.08925; % [m] Espaçamento entre as nervuras

%% DADOS DE MATERIAL %%

dens_balsa = 136; % [Kg/m³] Densidade da balsa
bonder = 0.005; % [Kg] Massa de bonder por frasco
fita = 0.044757; % [Kg/m²] Densidade por área de asa de entelagem de fita
cov = 0.025575; % [Kg/m²] Densidade por área de asa de entelagem de coverite

chapa1 = 0.001; % [m] Espessura da chapa 1 de balsa
chapa2 = 0.0015; % [m] Espessura da chapa 2 de balsa
chapa3 = 0.002; % [m] Espessura da chapa 3 de balsa

%% IMPORTAÇÃO DO PERFIL %%

load NACA0012.dat;
perf = NACA0012; % Vetor com as coordenadas parametrizadas do perfil

%% NÚMERO DE NERVURAS %%

nerv = ceil(env/esp);
if mod(nerv,2)==1
    nerv = nerv+1;
end

%% VETOR DE CORDAS %%

c(1)=cp;
for i=2:nerv
     c(i) = c(i-1)+(cr-cp)/(nerv/2);
end

%% CÁLCULO DAS ÁREAS E COMPRIMENTOS DOS PERFIS %%

y = linspace(-env/2,env/2,nerv);

for i=1:nerv
    perfis_asa(:,:,i)=c(i)*perf; % Vetor com as cordenadas reais dos perfis
    comp_perf(i)=sum(sqrt(diff(perfis_asa(:,1,i)).^2+diff(perfis_asa(:,2,i)).^2)); % Comprimento do perfil
    area_perf(i)=polyarea(perfis_asa(:,1,i),perfis_asa(:,2,i)); % Área do perfil
end

comp_nerv = sum(comp_perf)-comp_perf(nerv/2)-comp_perf(nerv/2+1); % Somatório dos comprimentos dos perfis
area_nerv = sum(area_perf); % Somatório das áreas dos perfis de balsa
area_ent=(comp_perf(1:length(comp_perf)-1)+comp_perf(2:length(comp_perf))).*diff(y)/2; % Áreas de intra e extradorso
area_ent=sum(area_ent); % Somatório da área de entelagem

%% COMPRIMENTO DO BORDO DE FUGA %%

comp_fuga = env;

%% ÁREA DO BORDO DE ATAQUE %%

area_vareta = 0.006*0.006/2; % Área da vareta de balsa do bordo
comp_bordo = 4*sqrt((env/2)^2 + (0.75*cr-0.75*cp)^2); % Comprimento do bordo da parte trapezoidal

%% VOLUME DE BALSAS %%

vol_nerv = area_nerv*chapa1; % Volume de balsa das nervuras
vol_fuga = 0.02*comp_fuga*chapa1; % Volume de balsa do bordo
vol_capstrike = 0.005*(0.67*comp_nerv)*chapa1; % Volume de balsa dos capstrikes
vol_vareta = area_vareta*(2*comp_fuga+comp_bordo); % Volume da vareta de balsa do bordo

%% MASSAS %%

M_nerv = vol_nerv*dens_balsa; % Massa de nervuras
M_fuga = vol_fuga*dens_balsa; % Massa do bordo de fuga
M_capstrike = vol_capstrike*dens_balsa; % Massa dos capstrikes
M_vareta = vol_vareta*dens_balsa; % Massa da vereta de balsa do bordo
M_bonder = 3*bonder; % Massa de superbonder
M_ent = area_ent*cov; % Massa de coverite

M = M_nerv+M_fuga+M_capstrike+M_vareta+M_bonder+M_ent;

%% PLOTAGEM DA ASA %%

% for i=1:nerv
%     perfis_asa2(:,i,1:2)=c(i)*perf; % Apenas para plotagem da asa
%     perfis_asa2(:,i,3)=y(i)*ones(length(perf),1); % Apenas para plotagem da asa
% end
% 
% surf(perfis_asa2(:,:,3),perfis_asa2(:,:,1),perfis_asa2(:,:,2));
% axis equal
