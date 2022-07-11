function [M] = Profundor (env,cr,cp)

%% DADOS DE ENTRADA %%

esp = 0.0515; % [m] Espa�amento entre as nervuras
ret = 1; % Porcentagem retangular

%% DADOS DE MATERIAL %%

dens_carb = 1600; % [Kg/m�] Densidade do carbono
dens_balsa = 136; % [Kg/m�] Densidade da balsa
bonder = 0.005; % [Kg] Massa de bonder por frasco
fita = 0.044757; % [Kg/m�] Densidade por �rea de asa de entelagem de fita
cov = 0.025575; % [Kg/m�] Densidade por �rea de asa de entelagem de coverite

chapa1 = 0.001; % [m] Espessura da chapa 1 de balsa
chapa2 = 0.0015; % [m] Espessura da chapa 2 de balsa
chapa3 = 0.002; % [m] Espessura da chapa 3 de balsa

%% IMPORTA��O DO PERFIL %%

load NACA-2412.dat;
perf = NACA_2412; % Vetor com as coordenadas parametrizadas do perfil

%% N�MERO DE NERVURAS %%

env_ret = env*ret; % [m] Envergadura retangular
env_tra = env-env_ret; % [m] Envergadura trapezoidal

nerv_tra = ceil(env_tra/esp);
if nerv_tra <= 0
	%keyboard;
end
if mod(nerv_tra,2)==1
    nerv_tra = nerv_tra+1;
end
nerv_ret = ceil(env_ret/esp);
if mod(nerv_ret,2)==1
    nerv_ret = nerv_ret+1;
end
nerv = nerv_tra+nerv_ret;

%% VETOR DE CORDAS %%

c(1)=cp;
for i=2:nerv
    if i<=nerv_tra/2
        c(i) = c(i-1)+(cr-cp)/(nerv_tra/2);
    elseif i>nerv_tra/2 & i<=(nerv_tra/2+nerv_ret)
        c(i) = cr;
    else
        c(i) = c(i-1)-(cr-cp)/(nerv_tra/2);
    end
end

%% C�LCULO DAS �REAS E COMPRIMENTOS DOS PERFIS %%

y = linspace(-env/2,env/2,nerv);

for i=1:nerv
    perfis_asa(:,:,i)=c(i)*perf; % Vetor com as cordenadas reais dos perfis
    comp_perf(i)=sum(sqrt(diff(perfis_asa(:,1,i)).^2+diff(perfis_asa(:,2,i)).^2)); % Comprimento do perfil
    area_perf(i)=polyarea(perfis_asa(:,1,i),perfis_asa(:,2,i)); % �rea do perfil
end

comp_nerv = sum(comp_perf)-comp_perf(nerv/2)-comp_perf(nerv/2+1); % Somat�rio dos comprimentos dos perfis
area_nerv = sum(area_perf); % Somat�rio das �reas dos perfis de balsa
area_ent=(comp_perf(1:length(comp_perf)-1)+comp_perf(2:length(comp_perf))).*diff(y)/2; % �reas de intra e extradorso
area_ent=sum(area_ent); % Somat�rio da �rea de entelagem

%% COMPRIMENTO DO BORDO DE FUGA %%

comp_fuga_tra = 4*sqrt((env_tra/2)^2 + (0.75*cr-0.75*cp)^2); % Comprimento do bordo da parte trapezoidal
comp_fuga_ret = 2*env_ret; % Comprimento do bordo da parte retangular
comp_fuga = comp_fuga_tra+comp_fuga_ret; % Comprimento total do bordo

%% �REA DO BORDO DE ATAQUE %%

comp_casca = sum(sqrt(diff(perfis_asa(22:62,1,:)).^2+diff(perfis_asa(22:62,2,:)).^2)); % Comprimento da casca do bordo
area_casca = sum((comp_casca(1,1:nerv-1)+comp_casca(1,2:nerv)).*diff(y)*0.5); % C�lculo da �rea da casca
area_vareta = 0.01*0.01/2; % �rea da vareta de balsa do bordo
area_long = (sqrt((perfis_asa(29,1,1)-perfis_asa(60,1,1))^2+(perfis_asa(29,2,1)-perfis_asa(60,2,1))^2)+...
    sqrt((perfis_asa(29,1,2)-perfis_asa(60,1,2))^2+(perfis_asa(29,2,2)-perfis_asa(60,2,2))^2))*...
    (y(2)-y(1))*0.5; % �rea da segunda longarina
for i=2:nerv-1
    area_long = area_long+(sqrt((perfis_asa(29,1,i)-perfis_asa(60,1,i))^2+(perfis_asa(29,2,i)-perfis_asa(60,2,i))^2)+...
    sqrt((perfis_asa(29,1,i+1)-perfis_asa(60,1,i+1))^2+(perfis_asa(29,2,i+1)-perfis_asa(60,2,i+1))^2))*...
    (y(i+1)-y(i))*0.5; % �rea da segunda longarina
end
area_bordo = area_casca+area_long; % �rea total do bordo

%% VOLUME DE BALSAS %%

vol_nerv = area_nerv*chapa2; % Volume de balsa das nervuras
vol_fuga = 0.02*comp_fuga*chapa1; % Volume de balsa do bordo
vol_capstrike = 0.005*(0.67*comp_nerv)*chapa1; % Volume de balsa dos capstrikes
vol_bordo = area_bordo*(chapa1); % Volume do bordo
vol_vareta = area_vareta*env; % Volume da vareta de balsa do bordo

%% TUBO DE CARBONO %%

Rtubo = 4;
ttubo = 1;
Rtubo = Rtubo/1000; % [m] Raio externo do tubo
ttubo = ttubo/1000; % [m] Espessura do tubo
area_tubo = pi*(Rtubo^2-(Rtubo-ttubo)^2); % [m�] �rea do tubo
vol_tubo = area_tubo*env; % [m�] Volume do tubo

%% MASSAS %%

M_tubo = 0.5*vol_tubo*dens_carb; % Massa do tubo de carbono
M_nerv = vol_nerv*dens_balsa; % Massa de nervuras
M_fuga = vol_fuga*dens_balsa; % Massa do bordo de fuga
M_capstrike = vol_capstrike*dens_balsa; % Massa dos capstrikes
M_vareta = vol_vareta*dens_balsa; % Massa da vereta de balsa do bordo
M_bonder = 3*bonder; % Massa de superbonder
M_ent = area_ent*cov; % Massa de coverite
M_bordo = vol_bordo*dens_balsa; % Massa do bordo de ataque

M = M_tubo+M_nerv+M_fuga+M_capstrike+M_vareta+M_bonder+M_ent+M_bordo;

%% PLOTAGEM DA ASA %%

% for i=1:nerv
%     perfis_asa2(:,i,1:2)=c(i)*perf; % Apenas para plotagem da asa
%     perfis_asa2(:,i,3)=y(i)*ones(length(perf),1); % Apenas para plotagem da asa
% end
% 
% surf(perfis_asa2(:,:,3),perfis_asa2(:,:,1),perfis_asa2(:,:,2));
% axis equal
