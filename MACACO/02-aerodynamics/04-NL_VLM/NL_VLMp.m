function [CLs,CDs,Cm25s,dist1,dist2] = NL_VLMp(plane,fltcond,varargin)
%--------------------------------------------%
%     _    _ _____ ____ _____ ____ _____     %
%    | \  / |  _  |  __|  _  |  __|  _  |    %
%    |  \/  | [_] | (__| [_] | (__| (_) |    %
%    |_|  |_|_/ \_|____|_/ \_|____|_____|    %
% Multi-Analysis  Code for Airplane COncepts %
%                                            %
%--------------------------------------------%
%			NON LINEAR VLM CODE				 %
%--------------------------------------------%
%
% This function ...
%
% INPUTS:
%	plane	:	An  variable  of  the  Airplane  class,  with  at least one 
%				Lifting Surface with the aerodynamic mesh already computed.
%	fltcond :	An variable of the FlightConditions class.  
%
% Flags:
%	-append				:	Append polar to Airplane aerodynamics sections.
%
%	-nogetloads			:
%
%	-tol <tol>			:	Tolerance for the iterative solver
%
%	-itermax <iters>	:	Maximum number of iteractions
%
%	*-polarset <n>		:	Append polar to specified <n> polar set. If not
%							specified, use polar set with the bigger index.
%
%	*-newset			:	Create new polar set and store  analysis there.
%							
%	*-polarn   <n>		:	Append  polar  to  position  <n>.  It  is   not
%							necessary to use -append when using -polarn.
%
%	*-alphas <alpha vec>:	Run  alpha  sweep  with alphas specified in the
%							vector <alpha vec>, all of the other parameters
%							of the fltcond variable remain constant.   This 
%							flag  automatically  create  a  new  polar set,  
%							unless  user  use the flag -polarset <n>.
%
%	*-beta  <beta  vec>	:	Run   beta   sweep   with beta specified in the
%							vector  <beta vec>, all of the other parameters
%							of the fltcond variable remain constant.   This 
%							flag  automatically  create  a  new  polar set,  
%							unless  user  use the flag -polarset <n>.
%
%	*-findCLmax			:	Find  airplane  maximun  CL  using a bissection
%							strategy. Default number of iterations: 5.
%
%	*-findCLmax_it <iter>:	Change number of iterations of flag -findCLmax.
%
%	-dispstat			:	Display statistics in the end of the analysis.
%
%	Obs.: "*" means the flag is not yet implemented
%
% OUTPUTS:
% All  the  coefficients   and  loads calculated are  exported  directly to 
% Airplane.LiftingSurfaces(:).Aero    and    Airplane.Aero.   For   further 
% information    about    the    coefficients,    see   Airplane_Aero   and
% LiftingSurface_Aero classes.
%
% Examples of use: 
%	plane = Airplane;
%	fltcond = FlightConditions;
%	(setup plane and fltcond)
%	NL_VLM( plane, fltcond, '-append', '-itermax',10 )
%	NL_VLM( plane, fltcond, '-alphas , [0:2:10], '-dispstat' )
%
% Author: André Rezende Dessimoni Carvalho
%

elap_time_i = tic;
%% ===================================================================== %%
%								PREPARATION								  %
% ======================================================================= %

% Flags
% -------------------------------------
% Default flags
pol_append	= false;
dispstat	= false;
GetLoads	= true; 
GetCoeffs	= true;
tol			= 1e-4;
iter_max	= 20;

% User Flags
i=1;
while i <= length(varargin)
	switch varargin{i}
		case '-append'
			pol_append = true;
			i=i+1;
		case '-tol'
			tol = varargin{i+1};
			i=i+2;
		case '-itermax'
			iter_max = varargin{i+1};
			i=i+2;
		case '-dispstat'
			dispstat = true;
			i=i+1;
		case '-nogetloads'
			GetLoads = false;
			i=i+1;
		case '-nogetcoeffs'
			GetCoeffs = false;
			i=i+1;
		otherwise
			warning(['Unknow option ' varargin{i}])
			i=i+1;
	end
end

if pol_append
	polar_n = length(plane.Aero.Loads) + 1;
else
	polar_n = 1;
end

correct_2dclalpha = plane.Aero.Settings.NLVLM.correct_2dclalpha;

% QUANTIDADE DE SUPERFICIES E PAINEIS
% ------------------------------------
% Quantidade de superficies sustentadoras
nLS   = length(plane.LiftingSurfaces);

% Quantidade de estacoes em cada superficie
nstat = zeros(nLS,1);
for LSn=1:nLS
	nstat(LSn) = length(plane.LiftingSurfaces(LSn).Geo.C);
end

% Quantdade de paineis aerodinamicos
% nmeshLS = plane.Aero.nmeshLS;
nmesh = plane.Aero.nmesh;

Yb0 = plane.Aero.Mesh.Yb0;
c = plane.Aero.Mesh.Chord;
S = plane.Geo.Area.Sref;
	
Re_pan = c*fltcond.Voo*fltcond.rho/fltcond.mi;	
plane.Aero.Loads(polar_n).Re_pan = Re_pan;


plane.Aero.Loads(polar_n).Re	= fltcond.Re_cref;
plane.Aero.Loads(polar_n).Ma	= fltcond.Ma;
plane.Aero.Loads(polar_n).Voo	= fltcond.Voo;
plane.Aero.Loads(polar_n).alpha = fltcond.alpha;
plane.Aero.Loads(polar_n).beta	= fltcond.beta;
plane.Aero.Loads(polar_n).p		= fltcond.p;
plane.Aero.Loads(polar_n).q		= fltcond.q;
plane.Aero.Loads(polar_n).r		= fltcond.r;
plane.Aero.Loads(polar_n).rho	= fltcond.rho;
plane.Aero.Loads(polar_n).mu	= fltcond.mi;
plane.Aero.Loads(polar_n).H		= fltcond.H;
plane.Aero.Loads(polar_n).Sref	= S;
plane.Aero.Loads(polar_n).Bref	= plane.Geo.b;
plane.Aero.Loads(polar_n).MAC	= plane.Geo.MAC;

for LSn=1:nLS
	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Re		= fltcond.Re_cref;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Ma		= fltcond.Ma;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Voo		= fltcond.Voo;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).alpha	= fltcond.alpha;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).beta		= fltcond.beta;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).p		= fltcond.p;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).q		= fltcond.q;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).r		= fltcond.r;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).rho		= fltcond.rho;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).mu		= fltcond.mi;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).H		= fltcond.H;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Sref		= plane.Geo.Area.Sref;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Bref		= plane.Geo.b;
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).MAC		= plane.Geo.MAC;

end

%% ===================================================================== %%
%								SOLVER									  %
% ======================================================================= %

% WAKE DISCRETIZATION
% -------------------------------------
DiscretizerWake(plane, fltcond);

% MATRIX OF INFLUENCE
% ------------------------------------
if	(isempty(plane.Aero.Mesh.InfluenceMatrix) || plane.Aero.Settings.WakeType~=1) || ...
	(isempty(plane.Aero.Mesh.InfluenceMatrix) && plane.Aero.Settings.WakeType==1)
			w = InfluenceMatrix(plane,fltcond);
else 
			w = plane.Aero.Mesh.InfluenceMatrix;
end



% INICIALIZACAO DO SOLVER
% ------------------------------------

% 0) Angulo de ataque do escoamento
alpha_inic  = fltcond.alpha*ones(nmesh,1)*pi/180;	% alpha_g em rad
persistent del alpha_ant cl_visc_ant

if isempty(alpha_ant)
	alpha_ant = alpha_inic;
	cl_visc_ant = zeros(nmesh,1);
end

if isempty(del) || plane.Aero.Settings.NLVLM.Use_last_del_values == 0
	del			= zeros(nmesh,1);
else
	if plane.Aero.Settings.NLVLM.Use_last_del_values == 1
% 		del		=  del;
	elseif plane.Aero.Settings.NLVLM.Use_last_del_values == 2
		del		=  (alpha_inic - (cl_visc_ant + (alpha_inic-alpha_ant)*2*pi)/(2*pi))*0.9;
	end
end

% 1) Estimativa incial de delta e cl

alpha_decamb	= alpha_inic;
lift_slope		= 2*pi*ones(nmesh,1);

res = 1000;
iter = 0;


% SOLVER
% ------------------------------------
while  max(res)>=tol && iter<iter_max

	% 2) Caracteristicas aerodinamicas calculadas usando VLM classico
	[cl_inv,~,G] = LINEAR_VLM(plane,fltcond,'-NL',alpha_decamb,w,iter);
	
	% 3) Calculo do angulo de ataque efetivo usando o cl obtido no item 2
	alpha_eff = cl_inv./(lift_slope) - del; % alpha_eff em rad
	plane.Aero.Loads(polar_n).alpha_eff = alpha_eff*180/pi;
	
	% 4.1) Calculo do cl_visc usando a polar pra o alpha_eff do item 3
	cl_visc = InterpSpanData( plane, 1, polar_n );
	
	% 4.2) Calculo de Dcl = cl_visc-cl_inv
	Dcl = (cl_visc - cl_inv);
	
	% 5) Recalcula del e alpha
	% Alteração Fator de amortecimento para estabilização
	D = ones(1,nmesh);
	if iter>iter_max/4
		D(res>tol) = .1;
	end
		
	del = del + D'.*Dcl./lift_slope; % del em rad
	alpha_decamb = alpha_inic+del;    % alpha_g em rad
	
	% 7) Checa convergencia
	res = abs(cl_inv-cl_visc);
	CL = 1/S * trapz(Yb0,c.*cl_visc);
	
	% non-convergence criteria
	if abs(max(alpha_decamb))-abs(min(alpha_decamb))>20*pi/180
		if CL>5 || CL<-5
			CL = nan;
			cl_visc(1:end) = nan;
		end
		break
	end

	
	if correct_2dclalpha
		i=0;
		for LSn=1:nLS
				IsSym = 1; if plane.LiftingSurfaces(LSn).Geo.YSymmetry; IsSym = 2; end
				for statn=1:nstat(LSn)-1
					for pann=1:plane.LiftingSurfaces(LSn).Aero.Mesh.Ny*IsSym
							i=i+1;
							a1 = alpha_eff(i)-1*pi/180;
							a2 = alpha_eff(i)+1*pi/180;
							if plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq
								cl1= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).cl(a1*180/pi,Re_pan(i));
								cl2= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).cl(a2*180/pi,Re_pan(i));
							else
								cl1= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).cl(a1*180/pi,Re_pan(i),'interp');
								cl2= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).cl(a2*180/pi,Re_pan(i),'interp');
							end
							lift_slope(i) = (6*pi + (cl2-cl1)/(a2-a1))/4;
							if lift_slope(i)<1 && lift_slope(i)>=0
								lift_slope(i) = 1;
							elseif lift_slope(i)>-1 && lift_slope(i)<0
								lift_slope(i) = -1;
							elseif lift_slope(i)>17.5
								lift_slope(i)=17.5;
							elseif  lift_slope(i)<-17.5
								lift_slope(i)=-17.5;
							end
					end
				end
		end
	else
		lift_slope(1:end) = 2*pi;
	end
		
	iter = iter+1;

end
alpha_ant = alpha_decamb;
cl_visc_ant = cl_visc;


plane.Aero.Loads(polar_n).G = G;
plane.Aero.Loads(polar_n).alpha_ind = (fltcond.alpha + plane.Aero.Mesh.Twist) - alpha_eff*180/pi;
for LSn = 1:nLS
	
	LS_mesh	= plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2);

	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).G			= G(LS_mesh)';
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).alpha_ind	= plane.Aero.Loads(polar_n).alpha_ind(LS_mesh);	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Re_pan		= Re_pan(LS_mesh);
	
end


if GetLoads
	InterpSpanData( plane, 2, polar_n );
	
	if GetCoeffs
		CalcCoeffs( plane, polar_n)
	end
end

CLs = zeros(nLS,1);
CDs = zeros(nLS,1);
Cm25s = zeros(nLS,1);

for LSn = 1:nLS
    CLs(LSn) = plane.LiftingSurfaces(LSn).Aero.Coeffs.CL;
    CDs(LSn) = plane.LiftingSurfaces(LSn).Aero.Coeffs.CD;
    Cm25s(LSn) = plane.LiftingSurfaces(LSn).Aero.Coeffs.Cm25;
end

dist1 = plane.LiftingSurfaces(1).Aero.Loads.cl; 
dist2 = plane.LiftingSurfaces(2).Aero.Loads.cl; 

elap_time = toc(elap_time_i);
if dispstat
	fprintf('alpha: %2.2f  |  iters:  %i | elapsed time: %2.6f\n',fltcond.alpha, iter, elap_time)
end
