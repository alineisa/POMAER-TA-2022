function [Rtubo,ttubo,M_tubo] = Dimensiona(env,MTOW)
% Dados aeronave TA ano passado para teste
% env = 1.986; % m
% MTOW = 13.87; % kg
FC = 1.78; 
CS = 1.5;

% Definicao de variavel
% gama = cp/cr;
b = env;
% semi = b/2;
% x = linspace(0,semi,10);
% x = linspace(-semi,semi,21);

% Dados tubo de carbono
rho = 1570;  % densidade em kg/mm^3
sigma = 300*10^6; % tensao de escoamento em Pa

% Carregamento na asa
% Lr = (MTOW*FC)/b; % secao retangular
% Lt = @(x) ((2*MTOW*FC)/(b*(1+gama)))*(1+(2*x/b)*(gama-1)); % secao trapezoidal
% Le = @(x) ((4*MTOW*FC)/(b*pi))*(sqrt(1-((2*x/b).^2))); % secao teorica eliptica
% L = @(x) ((Lt + Le)/2); % carregamento na asa - Schrenk

% Integrar L duas vezes para encontrar Momento Fletor na asa
% Condicoes de contorno: M(semi) = V(semi) = 0
% V = @(x) ((MTOW.*FC)/(b.*pi)).*((b.*asin((2.*x)/b))+ (2.*x.*sqrt(1-((4.*x.^2)/(b.^2)))))+((MTOW.*FC)/2);
M = @(x) ((MTOW*FC)/(6*pi)).*((6.*x.*(asin((2.*x)/b)))-(b.*((1-((4.*(x.^2))/(b^2))).^(3/2)))+(3*b.*sqrt(1-((4.*(x.^2))/(b^2))))-(3*pi.*x));
Mmax = M(0);
% plot(x,M) para testar se ta dando certo a integral (n ta)

% Dimensionamento
esp = linspace(0.001,0.006,6); % m
raio = linspace(0.001,0.006,6); % m
for j = 1:length(esp)
    for k = 1:length(raio)
        a_tubo = pi*(raio(k)^2-(raio(k)-esp(j))^2); % m^2 area tubo
        v_tubo = a_tubo*b;  % m^3 volume tubo
        m_tubo(j,k) = 2*v_tubo*rho; % kg massa tubo
        I_min(j,k) = ((Mmax*(raio(k)/2)*CS)/sigma);
            if esp(j)>raio(k)
                m_tubo(j,k) = 0;
            else
                m_tubo(j,k) = m_tubo(j,k);
            end     
            I(j,k) = (pi/4)*((raio(k)^4)-(esp(j)^4)); % inercia tubo
                if esp(j)>raio(k)
                    I(j,k) = 0;
                else
                    I(j,k) = I(j,k);
                end     
                    if I(j,k)>=I_min(j,k)
                        m_tubo(j,k) = m_tubo(j,k);
                    else
                        m_tubo(j,k) = NaN;
                    end
    end
end
[M_tubo,Id] = min(m_tubo(:)); % kg 
[ttubo, Rtubo] = ind2sub(size(m_tubo),Id); 