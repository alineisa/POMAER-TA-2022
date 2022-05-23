function Y = Lucy(geo,flc)
%% =========================== LIMITACOES =================================
% Range de aoa = -15 a +15 [graus]
% Range de velocidades = 1 a 17[m/s]
% Range de cordas = 0.15 a 0.30 [m]
% Range de envergaduras = 0.8 a 2 [m]
%% ============================ CONSTANTES ================================
% Perfil = NACA0012
% Densidado do ar = 1.12 [kg/m^3]
%% ========================= FORMATO DE INPUT =============================
% flc.aoa = angulos de ataque (podem ser analisados varios ao mesmo tempo)
% flc.Voo = velocidade de analise (podem ser analisadas varias ao mesmo tempo)
% geo.LiftingSurface.c(3,1) = corda da EH
% geo.LiftingSurface.B(3,1) = envergadura da EH
% ATENCAO! NAO PODEM SER ENVIADOS MULTIPLOS VALORES DE VELOCIDADE E ANGULO
% DE ATAQUE AO MESMO TEMPO!
%% ========================= FORMATO DE OUTPUT ============================
% Y(1,xxx) = CL na condicao xxx
% Y(2,xxx) = CD na condicao xxx
% Y(3,xxx) = Cm25 na condicao xxx
%% ======================== EXEMPLO DE INPUT 1 ============================
% flc.aoa = [-14 2 4 5];
% flc.Voo = 7;
% geo.LiftingSurface.c(3,1) = 0.25;
% geo.LiftingSurface.B(3,1) = 1.5;
%% ======================== EXEMPLO DE INPUT 2 ============================
% flc.aoa = 0;
% flc.Voo = 1:0.1:10;
% geo.LiftingSurface.c(3,1) = 0.25;
% geo.LiftingSurface.B(3,1) = 1.5;
%% ===================== EXEMPLO DE INPUT ERRADO ==========================
% flc.aoa = [-14 2 4 5];
% flc.Voo = 1:0.1:10;
% geo.LiftingSurface.c(3,1) = 0.25;
% geo.LiftingSurface.B(3,1) = 1.5;
%% ============= CHECANDO PARA VER SE NENHUM DADO E EXTRAPOLADO ===========
teste1 = flc.Voo < 1;
teste1 = teste1 + (flc.Voo > 17);
teste2 = geo.LiftingSurface.c(3,1)>0.30 || geo.LiftingSurface.c(3,1)<0.15;
teste3 = geo.LiftingSurface.B(3,1)>2.00 || geo.LiftingSurface.B(3,1)<0.8;
teste4 = flc.aoa > 15;
teste4 = teste4 + (flc.aoa < -15);
erro = sum(teste1) + sum(teste2) + sum(teste3) + sum(teste4);
if ~erro
%% FORMATANDO VALORES NEGATIVOS DE AOA
Negativo = flc.aoa<0;
flc.aoa = abs(flc.aoa);
%% ================ FORMATANDO GEO POMAER > INPUT LUCY ====================
if length(flc.Voo) > 1 && length(flc.aoa) > 1
    error('Inputs incorretos, mais de um valor de aoa e velocidade passados ao mesmo tempo, ler linha 31 do codigo!');
elseif length(flc.aoa) > 1
    X(1,:) = flc.aoa;
    X(2,:) = geo.LiftingSurface.c(3,1)*ones(1,length(flc.aoa));
    X(3,:) = geo.LiftingSurface.B(3,1)*ones(1,length(flc.aoa))/2;
    X(4,:) = flc.Voo*ones(1,length(flc.aoa));
else
    X(1,:) = flc.aoa*ones(1,length(flc.Voo));
    X(2,:) = geo.LiftingSurface.c(3,1)*ones(1,length(flc.Voo));
    X(3,:) = geo.LiftingSurface.B(3,1)*ones(1,length(flc.Voo))/2;
    X(4,:) = flc.Voo;
end
%% ======================== REDE NEURAL CL ================================
% Input 1
x1_step1.xoffset = [0;0.15;0.4;1];
x1_step1.gain = [0.133333333333333;13.3333333333333;3.33333333333333;0.125];
x1_step1.ymin = -1;

% Layer 1
b1 = [0.35176203187422306;0.65222313079303551;-8.4378675401747767;-2.6315530477408804;0.8972629221465428;0.0173110578567796;-0.035384508311339866;0.82635138227317262;-0.85512995399229796;1.4776890144210368];
IW1_1 = [-0.12116597044471984 -0.12176684856547268 0.36011621569550778 -0.040834448121590358;-0.68769759942652753 0.095018966081471479 -0.064521310437277796 -0.010348482324720317;7.5426720287881324 -1.3133026102387926 0.94032362794194191 -2.6236243091675546;-3.7648482011530882 0.65842392059201793 -0.15570621494696801 1.4830146449788459;1.2808133429390394 -0.026978075746243058 0.082608836189550727 0.53835660224854187;-0.043993617426398395 0.014108690232749528 -0.022683181023453413 0.41137357474636954;-0.52365534568641792 0.013890211703019965 0.088074707829157703 0.072220857722746765;-0.27077207540781334 0.15370317816909929 -0.29865483201132476 0.11341614288629324;-1.1275549619509715 0.048726288159986156 -0.075867157715953329 -0.39765122880804549;-1.2745120316583749 0.063890332233837929 0.21308282288058147 0.22885053872657621];

% Layer 2
b2 = -0.42063142827673511;
LW2_1 = [-2.3283036594246393 -9.4112478455309674 -0.21025219814119089 -0.13009372202550659 -4.6623462789246357 -3.7023431407391683 8.8011341361705746 3.7896026796558968 -7.9752194998164079 2.1993792063687105];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 1.86744615661455;
y1_step1.xoffset = 0;

% ===== SIMULATION ========

% Dimensions
Q = size(X,2); % samples

% Input 1
xp1 = mapminmax_apply(X,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
Y1 = mapminmax_reverse(a2,y1_step1);
Y1 = Y1.*(-1).^(Negativo);
%% ======================== REDE NEURAL CD ================================
% Input 1
x1_step1.xoffset = [0;0.15;0.4;1];
x1_step1.gain = [0.133333333333333;13.3333333333333;3.33333333333333;0.125];
x1_step1.ymin = -1;

% Layer 1
b1 = [0.2812811724868064;-0.95338749071184947;1.9788106370123248;-7.6457193979978513;-3.8559589234092644;0.68936978909722757;-0.3311652353808302;1.0709318418605596;4.3267017278421935;2.3874701168244541];
IW1_1 = [-0.60478258263265972 0.45082822582745369 -0.27903910894246819 1.1387448046147783;-1.1304423805951374 0.87914241246309333 -0.10203025300113035 -0.21177846284895732;-2.4651003379345418 0.30327003274052949 0.50579655715521465 0.97925064057541578;6.7354542499878116 -1.2958315285772248 0.87296686733253392 -2.0797498181020422;0.55141191386505073 -0.74010111262122924 0.13658762892410417 -4.9589518917468149;-0.4162673918724118 -0.095453519965664688 0.012915950128417023 0.074473735770837671;0.44299161150585881 -0.43632999862027372 0.23147416210083174 -1.0526711217191957;-0.8009764732138237 0.27548640574143346 0.16121825643521207 -0.61262593572659596;-0.42622314886540286 0.76109352172717437 -0.13217327718843949 5.4937201167041829;2.0254993293805272 -0.13781381197530873 -0.020512840991778244 -0.2832647666574295];

% Layer 2
b2 = 1.2659766785116675;
LW2_1 = [0.90835960309830455 -0.076695468547336984 -0.097927280560587499 0.23380917377152069 -0.65092905918376187 -1.855979538983298 1.0639555385481092 -0.24537760144772547 -0.67889999283459623 -0.18373595025298675];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 11.978571212557;
y1_step1.xoffset = 0.00741;

% ===== SIMULATION ========

% Dimensions
Q = size(X,2); % samples

% Input 1
xp1 = mapminmax_apply(X,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
Y2 = mapminmax_reverse(a2,y1_step1);
%% ======================== REDE NEURAL Cm25 ==============================
% Input 1
x1_step1.xoffset = [0;0.15;0.4;1];
x1_step1.gain = [0.133333333333333;13.3333333333333;3.33333333333333;0.125];
x1_step1.ymin = -1;

% Layer 1
b1 = [8.9760987826350611;1.1140008357890614;1.4151908743248183;-1.7866345204303309;1.5483981701961498;-0.96899369358079368;0.19915864437637726;1.1791076025212552;-4.859822210234241;0.31066950984796859;0.67468958134813228;1.281216245893003;3.3894482738305962;-2.9995825217600722;1.2467101861058965];
IW1_1 = [-7.7538725454716699 1.4116005347433553 -0.93127483785735954 3.3803968058867246;1.3790997967515441 0.11668122772729454 0.018284744559709177 0.14041864765644721;-0.88966144458609986 0.30986432804367209 -0.030403612312556103 1.9827624556633316;1.8125302737827664 -0.17518127437412209 -0.18624352635274188 -0.43913063179931655;-1.1006721262942332 0.36717791095729396 -0.039830538838681442 2.114565125904055;0.19887623744934632 -0.12105407037620838 -0.020692896369328855 -1.6263829018056339;0.41181190481447877 -0.16213785798081815 0.24076795456140429 -0.12847095493455662;1.288647841492387 0.14654710965373796 0.0078259512614399958 0.0056536074480054103;5.5586897779354416 -1.0028979437399304 0.57972738162958926 -0.93734058276838672;0.64891413287050115 -0.18804446453243359 0.23346129192760634 -0.18330445884784888;1.3735521256748164 -0.30004867868432139 0.23264694233092234 -0.35136545004351105;3.5564738906493836 -0.55541247784813097 0.23993279633732734 -1.1594548929192623;2.3407266359704444 0.15359169332191144 0.029284385346302854 1.7203606442579362;-1.8338607633286574 -0.1291187133735873 -0.015822406442796946 -1.6697052409878339;1.1336294326798975 0.1754663007131326 -0.010003023949747274 -0.21915635647078457];

% Layer 2
b2 = -1.5731755046945699;
LW2_1 = [0.58893465593434269 -15.782657168982734 -12.467417488675256 -1.7987390163954473 8.987124458997318 -3.3467800460735364 -15.313464528862708 25.511973762036192 0.54277541883654778 21.535054315209422 -6.6038298614089452 0.65804360841218568 -10.681622112459021 -10.845444615675563 -10.368736215604104];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 35.6358351214656;
y1_step1.xoffset = -0.0270363342365478;

% ===== SIMULATION ========

% Dimensions
Q = size(X,2); % samples

% Input 1
xp1 = mapminmax_apply(X,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
Y3 = mapminmax_reverse(a2,y1_step1);
Y3 = Y3.*(-1).^(Negativo);
%% ======================== FORMATANDO OUTPUTS ============================
Y(1,:) = Y1;                                                                % CL
Y(2,:) = Y2;                                                                % CD
Y(3,:) = Y3;                                                                % Cm25
else
    if sum(teste1)>0
        error('Input de velocidade invalido: condicao extrapolada')
    elseif sum(teste2)>0
        error('Input de corda invalido: valor extrapolado')
    elseif sum(teste3)>0
        error('Input de envergadura invalido: valor extrapolado')
    elseif sum(teste4)>0
        error('Input de angulo de ataque invalido: valor extrapolado')
    end
end
end
% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end