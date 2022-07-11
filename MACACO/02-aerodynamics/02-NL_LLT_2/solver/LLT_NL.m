%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						LINHA SUSTENTADORA NÃO LINEAR					  %
%						   André Rezende  Dessimoni						  %
%																		  %
% Código de linha sustentadora não linear baseado em					  %
% Anderson - Fundamentals of Aerodynamics, 5ed. com derivadas obtidas por %
% diferenças centradas de 2° ordem e condição de contorno aproximada por  %
% interpolação unidimensional de terceira ordem.						  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [AERODATA3D] = LLT_NL(solver,geo,supcmd,fltcond,plota)

%% ====================== CONVERSÃO DAS VARIÁVEIS =========================	
% -----> Solver
n					= solver.n;
D					= solver.D;	
conv_Gama			= solver.conv_Gama;
conv_CL				= solver.conv_CL;
iters				= solver.iters;
Gama0				= solver.Gama0;
break_stall			= solver.break_stall;	


% -----> Configurações do plot
plota_sofinal		= plota.sofinal;
plota_gerais		= plota.gerais;
plota_conv			= plota.conv;
plota_curvaCL		= plota.curvaCL.run; 
plota_curvaCL_ae	= plota.curvaCL.ae;

plota_distCL		= plota.dist.CL;
plota_distCD		= plota.dist.CD	;
plota_distCMc4		= plota.dist.CMc4;

plota_asa3D			= plota.asa3D.run; 
	plota_asa3D_perf				= plota.asa3D.perf;
	plota_asa3D_saveSTL				= plota.asa3D.saveSTL;
	plota_asa3D_saveSTL_name		= plota.asa3D.saveSTL_name;
	plota_asa3D_saveSTL_simmetry	= plota.asa3D.saveSTL_simmetry;
	
plota_estacoes		= plota.estacoes.run; 
	plota_plota_estac_vortex = plota.estacoes.plota_estac_vortex;
plota_cor		= plota.cor;	

% -----> Flight Conditions
a_atk				= fltcond.a_atk;
Voo					= fltcond.Voo;
H					= fltcond.H;
Temp				= fltcond.Temp;	
rho					= fltcond.rho;
mi					= fltcond.mi;

% -----> Geometria
xref_m				= geo(1).xref_m;
zref_m				= geo(1).zref_m;
cl_eq				= geo(1).cl_eq;
cl_polar			= geo(1).cl_polar;	
cl_curvas2global	= geo(1).cl_curvas2global;
if cl_eq
	cl_eq_func		= geo(1).cl_eq_func;
elseif cl_polar	
	cl_polar_file		= geo(1).cl_polar_file;
end
Y					= geo(1).Y;
C					= geo(1).C;
y					= geo(1).y;
b					= geo(1).b;
c					= geo(1).c;
i_g					= geo(1).i_g;
sweep				= geo(1).sweep;

S					= geo(1).S;
AR					= geo(1).AR;
CMA					= geo(1).CMA;

% -----> Superfícies de comando
supcmd_run			= supcmd.run;
posy				= supcmd(1).posy;
deflex_linear		= supcmd(1).deflex_linear;
dcl_da				= supcmd(1).dcl_da;
dcd0_da				= supcmd(1).dcd0_da;
dcmc4_da			= supcmd(1).dcmc4_da;
da					= supcmd(1).da;
deflex_polar		= supcmd(1).deflex_polar;




%% ====================== PROCESSO ITERATIVO ==============================
Dy		= y(2)-y(1);
CL_ant	= -inf;


% if isempty(posy)==0
% 	for ii=1:length(posy)
% 		n_ini(ii) = find(y>=posy(ii,1),1,'first');
% 		n_fim(ii) = find(y<=posy(ii,2),1,'last');
% 	end
% end

for a_atk_n = 1:length(a_atk)							% Repete o processo para cada elemento do vetor de ângulos de ataque
	
	
	% distribuição de ângulos de ataque [rad]
	alpha	= i_g' + a_atk(a_atk_n);
	
	% -----> Inicialização <-----
	t_a_atk = tic;
	warning_cl_out = false;
	Gama_inp= Gama0.*sqrt(1-(2.*y/b).^2);				% chute da distribuição de circulação inicial (eq 5.31)		- 2° passo
	iter		= 1;
	erro_Gama	= 1;
	erro_CL		= 1;
	CL_new		= 0;
	
	if geo(1).cl_polar	
		n_pol=size(cl_polar_file);
		for i=1:n_pol
			aero = load(cl_polar_file(i,:));
			aerodados(i).alpha = aero(:,1);
			aerodados(i).cl	= aero(:,2);
			aerodados(i).cd	= aero(:,3);
			aerodados(i).cm	= aero(:,4);
			ind_acl0 = find(aerodados(i).cl<=0,1,'last');
			acl0 = aerodados(i).alpha(ind_acl0);
		end
	end
	
	
	if geo(1).cl_curvas2global
		global aerodados2D
		
		Re = fltcond.rho*fltcond.Voo*geo(1).CMA/fltcond.mi;
		for Re_i = 1:length(aerodados2D(geo(1).perfiln).Re)
			if aerodados2D(geo(1).perfiln).Re(Re_i).Re >= Re
				break
			end
		end
		if Re_i~=1
			Re_i = Re_i-1;
		end
		aerodados(i).alpha	= aerodados2D(geo(1).perfiln).Re(Re_i).alpha;
		aerodados(i).cl		= aerodados2D(geo(1).perfiln).Re(Re_i).Cl;
		aerodados(i).cd		= aerodados2D(geo(1).perfiln).Re(Re_i).Cd;
		aerodados(i).cm		= aerodados2D(geo(1).perfiln).Re(Re_i).Cm;

	
		
		ind_acl0 = find(aerodados(i).cl<=0,1,'last');
		acl0 = aerodados(i).alpha(ind_acl0);
	end
		
		
		
	

	
	
	% ----->  Processo iterativo
	while iter<=iters && erro_Gama(iter)>=conv_Gama && erro_CL(iter)>=conv_CL
		
 		dGama_dy  = derivada_2o_dif_cent(Gama_inp,y(2)-y(1));	% aproximação para a derivada da circulação
				
		alpha_i = calc_alpha_i(n,dGama_dy,Voo,b,y);				% cálculo do ângulo de ataque induzido (eq 5.75 e eq 5.76)  - 3° passo
		alpha_eff=alpha-alpha_i;								% ângulo de ataque efetivo									- 4° passo
		
		% obtenção do cl' em cada estação																					- 5° passo
		get_cl
		
		% condições de contorno
		%-> cl nulo nas extremidades
		cl(1)=0;
		cl(n+1)=0;
 		
		%-> cl nas seçoes adjacentes às extremidades aproximados por interpolação
		% unidimensional de terceira ordem (correção necessária devido ao método de derivada)
		cl(2) = Dy* (cl(5)/(4*Dy) - 3*cl(4)/(3*Dy) + 3*cl(3)/(2*Dy));
		cl(n) = Dy* (cl(n-3)/(4*Dy) - 3*cl(n-2)/(3*Dy) + 3*cl(n-1)/(2*Dy));

		%-> correção do cl para enflechamento
% 		cl = cl*cosd(sweep)^2; %  "The Simple Sweep Theory" -  Commercial Airplane Design Principles (Pasquale M. Sforza) - pag. 156
		cl = cl*cosd(sweep);   % Não utilizar o expoente 2 fez os resultados se ajustarem melhor ao DATCOM, AVL e MACHUP 
		
		% Gama iterativo
		Gama_new = .5*Voo*c.*cl;																							% - 6° passo
		Gama_old = Gama_inp;																								% - 7° passo
		Gama_inp = Gama_old+D*(Gama_new-Gama_old);																			% - 7° e 8° passo
		
		iter=iter+1;
		erro_Gama(iter) = max(abs(Gama_old-Gama_new));
		
		CL_old = CL_new;
		CL_new = 2/(Voo*S)*trapz(y,Gama_inp);
		erro_CL(iter) = abs(CL_old-CL_new);
	end
	
	
	% -----> Fim do processo iterativo <-----
	
	
	
	erro_Gama(1)=erro_Gama(2);
	erro_CL(1)	=erro_CL(2);
	if warning_cl_out
		% 		warning('dados bidimensionais requisitados fora do limite da polar => consinderando cl fora dos limites como o cl no limite')
	end
	
	
	
	%% ===================== CÁLCULOS FINAIS =================================
	CL(a_atk_n) = CL_new;
	CDi(a_atk_n)= 2/(Voo*S)*trapz(y,Gama_inp.*sin(alpha_i'));
	cdi = cl.*sin(alpha_i');
	w = -Gama_new./(4*pi*(b/2+y)) - Gama_new./(4*pi*(b/2-y));	% Downwash Eq. 5.12
	
	
	% --->  Os cálculos abaixo são baseados em:
	% Method for calculating wing characteristics by lifting-line theory using non-linear section data, NACA Technical Note n° 1269 
	% Conferir!!!
	get_cd0_cm	% Obtém os dados de distribuição de cd0 e cm(c/4) bidimensionais
	
	% Cálculo de arrastos
	cdtot = cd0+cdi;
	CD0(a_atk_n) = 1/S * trapz(y,cd0.*c);				% Eq. 17
	CDtot(a_atk_n) = CDi(a_atk_n)+CD0(a_atk_n);

	% Cálculo de Cm em c/4
	CMc4(a_atk_n)	= 1/(S*CMA)*trapz(y, cmc4.*(c.^2));	% Eq. 18 para considerando a referência na linha de c/4 da envergadura
	
	
	% Cálculo de Cm em uma referência dada
	p1 = cl'.*cos(alpha_eff) + cd0'.*sin(alpha_eff);
	p2 = cl'.*sin(alpha_eff) - cd0'.*cos(alpha_eff);
	cmref	= cmc4 - xref_m./c.*(p1') - zref_m./c.*(p2');
	CMref(a_atk_n)	= 1/(S*CMA)*trapz(y, cmref.*(c.^2));% Eq. 18 para a referência
	
	% Cálculo do coeficiente do momento de rolagem
	Clr(a_atk_n) = -1/(S*b)*trapz(y, cl.*c.*y);			% Eq. 20
	
	% Cálculo do coeficiente do momento de guinada induzida (devido à ditribuição de arrasto induzido)
	Cni(a_atk_n) = 1/(S*b)*trapz(y, cl.*c.*alpha_i'.*y);% Eq. 21 (foi retirado o pi/180 porque já está em rad (conferir se tá certo))
	
	% Cálculo do coeficiente de momento de guinada (devido à distribuição do arrasto de perfil)
	Cn0(a_atk_n) = 1/(S*b)*trapz(y, cd0.*c.*y);			% Eq. 22
	
	

	
	%% ========================= OUTPUT	======================================
	if plota_sofinal && (a_atk_n==length(a_atk) || (CL(a_atk_n)<CL_ant && break_stall))
		Plota
	elseif plota_sofinal == 0
		Plota
	end
	
	if CL(a_atk_n)<CL_ant && break_stall
		if plota.escrevecoefs
			disp('')
			disp('------------------------')
			fprintf('CL máximo: %2.6f\n', CL(a_atk_n-1))
			fprintf('alpha para CL máximo: %2.6f\n', a_atk(a_atk_n-1)*180/pi)
		end
 		break
	end
	CL_ant = CL(a_atk_n);
	
	if a_atk_n>1
		CL_alpha(a_atk_n) = (CL(a_atk_n)-CL(a_atk_n-1))/(a_atk(a_atk_n)-a_atk(a_atk_n-1));
	end
	if plota.escrevecoefs
		fprintf('\n---- a_atk = %2.2f° ---- \n',a_atk(a_atk_n)*180/pi)
		fprintf('Iterações: %i\n',iter);
		fprintf('Tempo gasto: %3.6f s \n\n', toc(t_a_atk))
		fprintf('CL	\t= %2.6f\n',CL(a_atk_n))
		fprintf('CDi	\t= %2.6f\n',CDi(a_atk_n))
		fprintf('CD0	\t= %2.6f\n',CD0(a_atk_n))
		fprintf('CDtot  \t= %2.6f\n',CDtot(a_atk_n))
		fprintf('CM(c/4)\t= %2.6f\n',CMc4(a_atk_n))
		fprintf('CMref  \t= %2.6f\n',CMref(a_atk_n))
		fprintf('Clr	\t= %2.6f\n',Clr(a_atk_n))
		fprintf('Cni	\t= %2.6f\n',Cni(a_atk_n))
		fprintf('Cn0	\t= %2.6f\n',Cn0(a_atk_n))
	end
	
end

AERODATA3D.a_atk	= a_atk*180/pi;
AERODATA3D.CL		= CL;
AERODATA3D.CDi		= CDi;
AERODATA3D.CD0		= CD0;
AERODATA3D.CDtot	= CDtot;
AERODATA3D.CMc4		= CMc4;
AERODATA3D.Clr		= Clr;
AERODATA3D.Cni		= Cni;
AERODATA3D.Cn0		= Cn0;
AERODATA3D.CL_alpha = CL_alpha;
