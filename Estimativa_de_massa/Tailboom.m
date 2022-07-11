function [M] = Tailboom (comp,h,lst,hst)

%% Dados de Entrada %%

% dens = 0.0091;                                                           % Densidade linear do tubo de carbono(kg/cm).
dens = 0.0013;                                                             % Densidade do laminado de carbono(kg/cm^3)

%% C�lculo do tamanho real do boom %%

size=sqrt((comp^2)+(h^2))*10^2;                                            % Comprimento do boom no plano xz em cm. 

%% Determina��o do n�mero de se��es no boom treli�ado %% 

% s = 0;
%                                                   
% if size <= 0.50                                                          % N�mero de se��es no boom. 
%        s = 3;
%     elseif size > 0.50 && size <= 0.65
%        s = 4;
%     elseif size > 0.65 && size <= 0.80
%        s = 5;
%     else size > 0.80
%        s = 6;
% end

%% Soma de massas para aumento n�o linear: aumento de espessura, pontos de fixa��o para o boom treli�ado %%

% j = 0;
% 
%                                                                          % Massas extras al�m do crescimento linear 
% if size <= 0.50
%        j = 5;
%     elseif size > 0.50 && size <= 0.65
%         j = 8;
%     elseif size > 0.65 && size <= 0.80
%         j = 13;
%     else size > 0.80
%         j = 19;
%  end

%% C�lculo do comprimento total de tubos utilizado no boom treli�ado %%

% x = size/s;                                                              % Comprimento lateral de cada se��o.
% y = s*x*4;                                                               % Comprimento dos 4 tubos laterais. 
% z = s*(2*(sqrt((x^2)+(lst^2))+2*(sqrt((x^2)+(hst^2)))));                 % Comprimento dos tubos diagonais.
% w = (s+1)*(2*lst + 2*hst);                                               % Comprimento dos tubos que formam as transi��es entre se��es.
% % soma = z + y + w


%% Calculo da area da base se��o tranversal circular do boom caix�o

raio = 2;                                                                  % Raio da base do laminado em cm
esp = 0.1;                                                                 % Espessura do laminado em cm
a_base = pi*(raio^2-(raio-esp)^2);                                         % Area da base do laminado em cm^2
  
%% Penaliza��o pelo aumento do comprimento do boom tendo em vista que a otimiza��o tende ao L.E. m�ximo %%

% p = (s-3)*15;                                                            % Penaliza��o em fun��o do n�mero de se��es 

%% C�lculo da massa do boom %% 

%M = (y+z+w+j)*dens;                                                       % Multiplica��o da densidade linear (Kg/cm) pelo comprimento total de tubos (cm) treli�a
M = size*a_base*dens;                                                      % Multiplica��o da densidade (Kg/cm^3) pelo volume do laminado (cm^3) do caix�o