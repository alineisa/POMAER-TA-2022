function [MTOW] = corrida(geo, flc, sim, ard, std)
% Modelo de Desempenho - Corrida de decolagem
% Tucano Aerodesign 2020 - Classe Regular
% Autores: Filipe França, Gabriel Guimaraes(Josh), Joao Paulo Leite

%% INICIALIZACAO
% Superficies Sustentadoras
surfacenum = geo.LiftingSurface.surfacenum;

% Velocidade
v_passo 	= 0.1;
v_lim   	= 15;
v  			= 0:v_passo:v_lim;
v  			= v + flc.v_vento;

v1         = 0:0.5:1.5;
v2         = 2:.7:10;
v3         = 11:v_lim;
v_reduzido = [v1, v2, v3];
v_reduzido = v_reduzido + flc.v_vento;

% Tempo
dt 			= 0.005;
i			= 1;
j           = 1;

CL          = zeros(surfacenum,length(v));
CD          = zeros(surfacenum,length(v));

% Condicoes da corrida
decolou = 0;
parar = 0;
passou_pista = 0;
MTOW        = 14.0;

% Coeficientes aerodinamicos para alpha = 0 c/ variacao de velocidade
[surf, ev, sp] = dspCoeff_alpha0(geo,flc,sim,v,v_reduzido);
[surf2]        = dspCoeff_varalpha(geo,flc,sim,ard,std);
surf           = catstruct(surf,surf2);

while true

% Caracteristicas da corrida
S_to		= zeros(1, 50*length(v));
S_lim 		= 50;
S_rot		= 42.00;
alpha		= zeros(1,length(v));
a_to		= zeros(1,length(v));
v_to    	= zeros(1,length(v));

% Forcas aerodinamicas
Lw			= zeros(1,length(v));
Dw			= zeros(1,length(v));

Leh			= zeros(1,length(v));
Deh			= zeros(1,length(v));

Dev         = zeros(1,length(v));
Dsp     	= zeros(1,length(v));

atrito      = zeros(1,length(v));
arrasto     = zeros(1,length(v));
L           = zeros(1,length(v));
Fz          = zeros(1,length(v));

% Calculo da tracao 
tracao          = zeros(1,length(v));


%% LOOP
    while true

        indice = int16(round(v_to(i)/v_passo + 1));                             % indice correspondente a velocidade da iteracao

        if S_to(i) <= S_rot
            alpha(i) = 0;

            for s = 1:surfacenum
                CL(s,:) = surf.CL(s,indice);
                CD(s,:) = surf.CD(s,indice);
            end
 
			tracao_v  = empuxo(v_to(i)+flc.v_vento, geo.mp.conjunto, flc.rho);
            tracao(i) = tracao_v * cosd(alpha(i));
			
            pd_s	  = 0.5 * flc.rho * (v_to(i) + flc.v_vento)^2;                  % pressao dinamica DIVIDIDO pela area de referencia

            CLw = sum(CL(1:surfacenum-1));
            CDw = sum(CD(1:surfacenum-1));

            Lw(i)  = pd_s * CLw * geo.LiftingSurface.Sw(1,1);                          
            Dw(i)  = pd_s * CDw * geo.LiftingSurface.Sw(1,1);        

            Leh(i) = pd_s * CL(surfacenum) * geo.LiftingSurface.Sw(1,1);
            Deh(i) = pd_s * CD(surfacenum) * geo.LiftingSurface.Sw(1,1);

        else
            
            if j <= length(surf.alpha)
                alpha(i) = surf.alpha(j);
                
                for s = 1:surfacenum
                    CL(s,:) = surf.CLarf(s,j);
                    CD(s,:) = surf.CDarf(s,j);
                end

            else
                alpha(i) = surf.alpha(end);
                
                for s = 1:surfacenum
                    CL(s,:) = surf.CLarf(s,end);
                    CD(s,:) = surf.CDarf(s,end);
                end
            end

			
			tracao_v  = empuxo(v_to(i)+flc.v_vento, geo.mp.conjunto, flc.rho);
            tracao(i) = tracao_v * cosd(alpha(i));
            pd_s	  = 0.5 * flc.rho * (v_to(i) + flc.v_vento)^2; 				% pressao dinamica DIVIDIDO pela area de referencia

            CLw = sum(CL(1:surfacenum-1));
            CDw = sum(CD(1:surfacenum-1));
            
            Lw(i) = pd_s * CLw * geo.LiftingSurface.Sw(1,1);
            Dw(i) = pd_s * CDw * geo.LiftingSurface.Sw(1,1);

            Leh(i) = pd_s * CL(surfacenum) * geo.LiftingSurface.Sw(1,1);        
            Deh(i) = pd_s * CD(surfacenum) * geo.LiftingSurface.Sw(1,1);

            j = j + 1;
        end

        % Arrasto da ev
        Dev(i) = pd_s * ev.CD(indice) * geo.LiftingSurface.Sw(1,1);

        % Arrasto sem polar
        Dsp(i) = pd_s * sp.CD(indice) * geo.LiftingSurface.Sw(1,1);

        % Peso da aeronave
        W = MTOW * flc.g;
        L(i) = Lw(i) + Leh(i) + tracao_v * sind(alpha(i));

        % Forca de atrito [N]:
        atrito(i) = flc.mi * (W - L(i));

        % Forca de arrasto [N]:
        arrasto(i)	= (Dw(i) + Dev(i) + Dsp(i) + Deh(i));

        if atrito(i) < 0
            atrito(i) = 0;
        end

        if isnan(atrito(i)) && i ~= 1
            atrito(i) = atrito(i-1);
        elseif isnan(atrito(i)) && i == 1
            atrito(i) = 0;
        end

        if arrasto(i) < 0
            arrasto(i) = 0;
        end

        if isnan(arrasto(i)) && i ~= 1
            arrasto(i) = arrasto(i-1);
        elseif isnan(arrasto(i)) && i == 1
            arrasto(i) = 0;
        end

        a_to(i) = (tracao(i) - arrasto(i) - atrito(i))/MTOW;
        Fz(i) = L(i) - W; 

        if a_to(i) <= 0.1
            Fz_check = interp1([a_to(i-1) a_to(i)],[Fz(i-1) Fz(i)],0.1);
            if Fz_check > 0 && Fz(i) >=0
                decolou = 1;
                break
            else
                parar = 1;
                break
            end
        elseif (L(i)-W) >= 0
            decolou = 1;
            break
        elseif (S_to(i) > S_lim && L(i) < W)
            passou_pista = 1;
            break
        end

        S_to(i + 1) = S_to(i) + (v_to(i) * dt) + (a_to(i) * (dt^2))/2;
        v_to(i + 1) = v_to(i) + (a_to(i) * dt);

        i = i + 1;
    end
    
    if decolou
        fprintf('Decolou, mtow = %.3f\n',MTOW)
        MTOW = MTOW + 0.05;
        decolou = 0;
    elseif passou_pista
        MTOW = MTOW - 0.05;
        fprintf('Varou pista, mtow = %.3f\n',MTOW)
        break
    elseif parar
        MTOW = MTOW - 0.05;
        fprintf('Aceleracao negativa, mtow = %.3f\n',MTOW)
        break
    end

    i = 1; j = 1;
end

%% PLOTS
% figure (51)
% plot(S_to(1:i),v_to(1:i),S_to(1:i),a_to(1:i),S_to(1:i),atrito(1:i),S_to(1:i),tracao(1:i),S_to(1:i),arrasto(1:i));
% legend('Velocidade','Aceleracao','Atrito','tracao','arrasto')
% xlabel('Comprimento de pista [m]')
% grid on
% 
% figure (52)
% plot(S_to(1:i-1),alpha(1:i-1),S_to(1:i-1),L(1:i-1),S_to(1:i),arrasto(1:i))
% legend('Alfa','Sustentacao','Arrasto')
% xlabel ('Comprimento de pista')
% grid on

end