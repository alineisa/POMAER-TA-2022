function [M] = Tailboom (comp,h,lst,hst)

%% Dados de Entrada %%

% dens = 0.0091;                                                           % Densidade linear do tubo de carbono(kg/cm).
dens = 0.0013;                                                             % Densidade do laminado de carbono(kg/cm^3)

%% Cálculo do tamanho real do boom %%

size=sqrt((comp^2)+(h^2))*10^2;                                            % Comprimento do boom no plano xz em cm. 

%% Determinação do número de seções no boom treliçado %% 

% s = 0;
%                                                   
% if size <= 0.50                                                          % Número de seções no boom. 
%        s = 3;
%     elseif size > 0.50 && size <= 0.65
%        s = 4;
%     elseif size > 0.65 && size <= 0.80
%        s = 5;
%     else size > 0.80
%        s = 6;
% end

%% Soma de massas para aumento não linear: aumento de espessura, pontos de fixação para o boom treliçado %%

% j = 0;
% 
%                                                                          % Massas extras além do crescimento linear 
% if size <= 0.50
%        j = 5;
%     elseif size > 0.50 && size <= 0.65
%         j = 8;
%     elseif size > 0.65 && size <= 0.80
%         j = 13;
%     else size > 0.80
%         j = 19;
%  end

%% Cálculo do comprimento total de tubos utilizado no boom treliçado %%

% x = size/s;                                                              % Comprimento lateral de cada seção.
% y = s*x*4;                                                               % Comprimento dos 4 tubos laterais. 
% z = s*(2*(sqrt((x^2)+(lst^2))+2*(sqrt((x^2)+(hst^2)))));                 % Comprimento dos tubos diagonais.
% w = (s+1)*(2*lst + 2*hst);                                               % Comprimento dos tubos que formam as transições entre seções.
% % soma = z + y + w


%% Calculo da area da base seção tranversal circular do boom caixão

raio = 2;                                                                  % Raio da base do laminado em cm
esp = 0.1;                                                                 % Espessura do laminado em cm
a_base = pi*(raio^2-(raio-esp)^2);                                         % Area da base do laminado em cm^2
  
%% Penalização pelo aumento do comprimento do boom tendo em vista que a otimização tende ao L.E. máximo %%

% p = (s-3)*15;                                                            % Penalização em função do número de seções 

%% Cálculo da massa do boom %% 

%M = (y+z+w+j)*dens;                                                       % Multiplicação da densidade linear (Kg/cm) pelo comprimento total de tubos (cm) treliça
M = size*a_base*dens;                                                      % Multiplicação da densidade (Kg/cm^3) pelo volume do laminado (cm^3) do caixão