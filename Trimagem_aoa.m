function Trimagem_aoa(geo,flc)
%% ==================== Parametros de entrada =============================
load('nova85eh')
load('ex_flc')

% geo.s.pos(2,1) = -1.2;
% geo.s.b(2,2) = 0.45;
% geo.s.perfil(2,1:2) = {'x2l_v3.mat' 'x2l_v3.mat'};
%  geo.s.perfil(3,1) = 23;
%  geo.s.perfil(3,2) = 23;

% geo.s.ai = [0;0;0];
% geo.o.panel         = 15;                                                    % Numero de paineis por secao de LS (Ideal: 25)
% geo.o.itermax       = 30;
eff = 1;                                                                  % Efetividade do profundor
aoamax = 20;                                                                % Maximo angulo de ataque que o codigo buscara CLtrim
aoamin = -3;
deflexaomax = -10;                                                          % Deflexao maxima do profundor
ID_prof = 2;                                                                % Superficie de controle
V = 12;
%% ======================= Prelocando variaveis ===========================
CL = zeros(geo.surfacenum,1);
Cm = zeros(geo.surfacenum,1);
%% ========================== Chama VLM ===================================
flc.Voo = V;                                                                % Declarando a velocidade para o VLM
flc.case(1).aoa = (aoamin:2:aoamax);                                             % Range de angulos que serao calculados para as asas
% flc.case(2).aoa = (10:-1:deflexaomax);                                      % Range de angulos que serao calculados para a empenagem
coef = coeffs_22(geo,flc,0,[1 2],1);                                       % Chamando VLM
for j=1:geo.surfacenum
    coeff.fit(j).CL = fit(coef(j).aoa',coef(j).CL','linearinterp');    % Nesse loop e feito o fit dos coeficientes (apenas para simplificar o acesso aos coeficientes)
    coeff.fit(j).CD = fit(coef(j).aoa',coef(j).CD','linearinterp');
    coeff.fit(j).Cm25 = fit(coef(j).aoa',coef(j).Cm25','linearinterp');
end
%% =================== CL por deflexao do prof ============================
flc.case(1).aoa = [0 -5];
coeffsEH = coeffs_22(geo,flc,0,2,2);
CL_deltae = (coeffsEH(2).CL(1) - coeffsEH(2).CL(2))/(coeffsEH(2).aoa(1) - coeffsEH(2).aoa(2))*eff*coeffsEH(2).Sref/coef(1).Sref;
i = 0;
for aoa=aoamin:0.5:aoamax
    i = i + 1;
    xo = -2;
    [deflexao,errotrim] = fminsearch(@trimagem,xo);
    trim.aoa(i) = aoa;
    trim.deflexao(i) = deflexao;
    trim.erro(i) = errotrim;
end
%% ===================== Plot dos resultados ==============================
figure
plot(trim.aoa,trim.deflexao)
grid on
xlabel('Aoa [graus]')
ylabel('Deflexao do profundor [graus]')
title('Trimagem por aoa')
figure
plot(trim.aoa,trim.erro)
grid on
xlabel('Aoa [graus]')
ylabel('Erro do codigo [ ]')
title('Erro do codigo')

%% =================== Funcao de otimizacao trimagem ======================
function Errotrim = trimagem(x)                                            % Funcao para otimizar
deflexao = x;                                                              % A funcao recebe o vetor x a deflexao
for j=1:geo.surfacenum
    M = geo.s.neta(j)*[0 -geo.s.pos(j,3) geo.s.pos(j,2); geo.s.pos(j,3) 0 -geo.s.pos(j,1); -geo.s.pos(j,2) geo.s.pos(j,1) 0]*([cosd(aoa) 0 -sind(aoa);0 1 0;sind(aoa) 0 cosd(aoa)]*[-coeff.fit(j).CD(aoa-geo.s.deda(j)*aoa-geo.s.eo(j));0;-coeff.fit(j).CL(aoa-geo.s.deda(j)*aoa-geo.s.eo(j))]);
    Cm(j) = M(2)/coef(1).Cref + geo.s.neta(j)*coeff.fit(j).Cm25(aoa - geo.s.deda(j)*aoa - geo.s.eo(j));
end
Cm_aeronave = sum(Cm);
Mprof = geo.s.neta(ID_prof)*[0 -geo.s.pos(ID_prof,3) geo.s.pos(ID_prof,2); geo.s.pos(ID_prof,3) 0 -geo.s.pos(ID_prof,1); -geo.s.pos(ID_prof,2) geo.s.pos(ID_prof,1) 0]*([cosd(aoa) 0 -sind(aoa);0 1 0;sind(aoa) 0 cosd(aoa)]*[0;0;-CL_deltae*deflexao]);
Cm_prof = Mprof(2)/coef(1).Cref;
Errotrim = abs(Cm_aeronave + Cm_prof)*100;                                 % Erro de Cm (soma do Cm da aeronave + Cm do profundor)
end

end