function [coordenadas] = Bezier_para_dat(pts)
%OBS: Alteracao do programa "esquema_AR1.m" do otimizador de perfis
%11/04/2021 - Vitor José

%Rotina responsável por interpretar o pontos tentativa "pts" e a partir 
%deles, montar um perfil com base em quatro curvas de bézier.
%autor: André Rezende

%% --- INTERPRETA O VETOR pts --- %%

% %     1      2      3      4
x_c_a=[0     ,0.1   ,pts(3),pts(4)];
y_c_a=[pts(1),pts(2),pts(5),pts(5)];

%      5       6       7       8
x_c_f=[pts(4), pts(6), pts(7), 1];
y_c_f=[pts(5), pts(5), pts(8), 0];

%      9  10      11       12 
x_e_a=[0,      0, pts(10), pts(11)];
y_e_a=[0, pts(9), pts(12), pts(12)];

%      13       14       15       16 
x_e_f=[pts(11), pts(13), pts(14), pts(16) 1];
y_e_f=[pts(12), pts(12), pts(15), pts(17) 0];


for i=1:3
    if y_c_a(i)>y_c_a(i+1)
        break
    end
end

for i=1:3
    if y_c_f(i)<y_c_f(i+1)
        break
    end
end

%% Daqui pra baixo é só côntas, só côntas JAJAJA (Sepulveda, Alonso)
%% CALCULA OS POLINÔMIOS DE BÉZIER DAS LINHAS DE CAMBRA E ESPESSURA %%
nplot=100;
for i = 1:length(x_c_a)
    %nplot = 25;                
    t = linspace(0,1,nplot);
    pto_c_a(i,:) = [x_c_a(i),y_c_a(i)]; %coordenadas do ponto de controle
    [~,~,lin_cambra_a] = BEZIER(0,1,pto_c_a,t); %lin_cambra: Linha de cambra inicial
    %BEZIER é a função que calcula o polinômio de Bézier
end
for i = 1:length(x_c_f)
        %nplot = 25;                
    t = linspace(0,1,nplot);
    pto_c_f(i,:) = [x_c_f(i),y_c_f(i)]; %coordenadas do ponto de controle
    [~,~,lin_cambra_f] = BEZIER(0,1,pto_c_f,t); %lin_cambra: Linha de cambra inicial
end
nplot=2*nplot;
for i=1:length(x_e_a)
       % nplot = 50;                
    t = linspace(0,1,nplot);
    pto_e_a(i,:) =[x_e_a(i),y_e_a(i)];
    [~,~,lin_esp_a] = BEZIER(0,1,pto_e_a,t); % Linha de espessura de ataque
end
for i=1:length(x_e_f)
       % nplot = 50;                
    t = linspace(0,1,nplot);
    pto_e_f(i,:) =[x_e_f(i),y_e_f(i)];
    [~,~,lin_esp_f] = BEZIER(0,1,pto_e_f,t); % Linha de espessura de fuga
end

%% TRAÇA A LINHA DE CAMBRA CORRIGIDA (Cx,Cy) %%
%Para que a parametrização funcione, a linha de cambra deve ter o mesmo formato da inicial,
%porém com as abscissas da linha de espessura. Ou seja, a linha de cambra certa é a
%sobreposição dos pontos da de linha sobre a de cambra.

lin_cambra=[lin_cambra_a;lin_cambra_f];

Cx = [lin_esp_a(:,1);lin_esp_f(:,1)];  % abscissa do ponto k da linha de cambra corrigida

h_a  = lin_esp_a(:,2);  % valor hk da espessura do ponto k
h_f  = lin_esp_f(:,2);
%encontra o coeficiente angular de cada segmento de reta
for k=1:nplot-1 %y-y0=m(x-x0)
    m(k)=((lin_cambra(k+1,2)-lin_cambra(k,2))/(lin_cambra(k+1,1)-lin_cambra(k,1)));        %coeficiente angular de cada seção da linha de cambra
end

%Projeta os pontos da linha de espessura sobre a curva de cambra
for j=1:nplot-1     %varre todos os pontos da linha de espessura de ataque
    for k=1:nplot-1 %verifica em qual segmento de reta que o ponto se encontra
        if lin_esp_a(j,1) >= lin_cambra(k,1) && lin_esp_a(j,1) <= lin_cambra(k+1,1)
            Cy(j)= m(k)*(Cx(j,1)-lin_cambra(k,1))+lin_cambra(k,2);
        end
        
    end
end
r=j+1;
for j=1:nplot-1     %varre todos os pontos da linha de espessura de fuga
    for k=1:nplot-1 %verifica em qual segmento de reta que o ponto se encontra
        if lin_esp_f(j,1) >= lin_cambra(k,1) && lin_esp_f(j,1) <= lin_cambra(k+1,1)
            try
                Cy(r)= m(k)*(Cx(r,1)-lin_cambra(k,1))+lin_cambra(k,2);
            catch
                keyboard;
            end
            r=r+1;
        end
    end
end
Cy(2*nplot)=lin_cambra(nplot,2);                    % ordenada do ponto k da linha de cambra corrigida
Cx(2*nplot-1)=(Cx(2*nplot-2,1)+Cx(2*nplot,1))/2;    %por algum motivo o penúltimo ponto da erro, então faço uma interpolação linear entre ele e o antepenúltimo
Cy(2*nplot-1)=(Cy(1,2*nplot-2)+Cy(1,2*nplot))/2;


%% CALCULA O INTRADORSO E O EXTRADORSO %%
for k=1:2*nplot-1
    if k<=nplot
        theta(k)=atan((Cy(k+1)-Cy(k))/(Cx(k+1)-Cx(k))); % derivada da curva da linha de cambra no ponto k
        
        Pex(k)=Cx(k)-h_a(k)*sin(theta(k));% ponto do extradorso referente ao ponto k
        Pey(k)=Cy(k)+h_a(k)*cos(theta(k));
        
        Pix(k)=Cx(k)+h_a(k)*sin(theta(k));% ponto do intradorso referente ao ponto k
        Piy(k)=Cy(k)-h_a(k)*cos(theta(k));
    else
        theta(k)=atan((Cy(k+1)-Cy(k))/(Cx(k+1)-Cx(k))); % derivada da curva da linha de cambra no ponto k
        
        Pex(k)=Cx(k)-h_f(k-nplot)*sin(theta(k));% ponto do extradorso referente ao ponto k
        Pey(k)=Cy(k)+h_f(k-nplot)*cos(theta(k));
        
        Pix(k)=Cx(k)+h_f(k-nplot)*sin(theta(k));% ponto do intradorso referente ao ponto k
        Piy(k)=Cy(k)-h_f(k-nplot)*cos(theta(k));
    end
end

Pex(nplot)=Pex(nplot+1);
Pix(nplot)=Pix(nplot+1);
Pey(nplot)=Pey(nplot+1);
Piy(nplot)=Piy(nplot+1);

Pex(2*nplot)=Cx(2*nplot);
Pix(2*nplot)=Cx(2*nplot);
Pey(2*nplot)=Cy(2*nplot);
Piy(2*nplot)=Cy(2*nplot);

X=[flip(Pex), Pix];                 % Corrige as coordenadas para o modo que o xfoil lê
Y=[flip(Pey), Piy];
coordenadas=[X' Y'];                % Coordenadas do perfil teste

% Bezier_plotado
end

%% --- SELIG 1223 --- %%
% 
% x_c_a=[ 0.000 0.10 0.3000 0.473];             %abscissas da linha de cambra
% y_c_a=[-0.011 0.065 0.0861     ];             %ordenadas da linha de cambra
% y_c_a(4)=y_c_a(3);
%
% x_c_f=[ x_c_a(4) 0.5      0.900 1.00];        %abscissas da linha de cambra
% y_c_f=[ y_c_a(4) y_c_a(4) 0.085 0.00];        %ordenadas da linha de cambra
%
%
% x_e_a=[0 0    0.10 0.20];                     %abscissas da linha de espessura do bordo de ataque
% y_e_a=[0 0.03 0.06     ];                     %ordenadas da linha de espessura do bordo de ataque
% y_e_a(4)=y_e_a(3);
%
% x_e_f=[x_e_a(4) 0.3276   0.6452 0.9013 1];	%abscissas da linha de espessura do bordo de fuga
% y_e_f=[y_e_a(3) y_e_a(3) 0.0104 0.0055 0];    %ordenadas da linha de espessura do bordo de fuga

%% --- RESULTADOS ANTERIORES --- %%
%20/10/15
%pts=[-0.0121000000000000 0.0713265722326751 0.270000000000000 0.449747041200917 0.0943216137516160 0.510000000000000 0.900000000000000 0.0928029391189759 0.0328847719902063 0.102000000000000 0.209963815677741 0.0623529778733802 0.312134116891775 0.645200000000000 0.0104367038009553 0.901721848450403 0.00853195239954302];
