function [cl,CL,G] = LINEAR_VLM(plane,fltcond,varargin)
%--------------------------------------------%
%     _    _ _____ ____ _____ ____ _____     %
%    | \  / |  _  |  __|  _  |  __|  _  |    %
%    |  \/  | [_] | (__| [_] | (__| (_) |    %
%    |_|  |_|_/ \_|____|_/ \_|____|_____|    %
% Multi-Analysis  Code for Airplane COncepts %
%                                            %
%--------------------------------------------%
%				LINEAR VLM CODE				 %
%--------------------------------------------%
%
% This function ...
%
% INPUTS:
% plane		:	An  variable  of  the  Airplane  class , with at least, one
%				Lifting Surface with the aerodynamic mesh already computed.
% fltcond	:	An variable of the FlightConditions class.
%
% OUTPUTS:
% The code outputs directly, only cl, CL, and G, wich are necessary for the 
% nonlinear code.  However, all the coefficients  and loads are exported to
% Airplane.LiftingSurfaces(:).Aero    and    Airplane.Aero.   For   further 
% information    about    the    coefficients,    see   Airplane_Aero   and
% LiftingSurface_Aero classes.
%
% FLAGS:
%	-append				:	Append polar to Airplane aerodynamics sections.
%
%	-polarset <n>		:	Append polar to specified <n> polar set. If not
%							specified, use polar set with the bigger index.
%
%	-newset				:	Create new polar set and store  analysis there.
%							
%	-polarn   <n>		:	Append  polar  to  position  <n>.  It  is   not
%							necessary to use -append when using -polarn.
%
%	-alphas <alpha vec>	:	Run  alpha  sweep  with alphas specified in the
%							vector <alpha vec>, all of the other parameters
%							of the fltcond variable remain constant.   This 
%							flag  automatically  create  a  new  polar set,  
%							unless  user  use the flag -polarset <n>.
%
%	-beta  <beta  vec> :	Run   beta   sweep   with beta specified in the
%							vector  <beta vec>, all of the other parameters
%							of the fltcond variable remain constant.   This 
%							flag  automatically  create  a  new  polar set,  
%							unless  user  use the flag -polarset <n>.
%
%	-NL <alpha> <iter>	:	Tells the code it is being called by the NL_VLM, 
%							and  therefore,  it should use the alpha vector
%							from  that  code.  In addition,  it  avoids  to 
%							calculate unnecessarily other outputs than cl.
%
% Exemples of use:
%	plane = Airplane;
%	fltcond = FlightConditions;
%	(setup plane and fltcond)
%	NL_VLM( plane, fltcond, '-append', '-itermax',10 )
%	NL_VLM( plane, fltcond, '-alphas , [0:2:10], '-dispstat' )
%	LINEAR_VLM(plane,fltcond,'-polarset',1)
%	LINEAR_VLM(plane,fltcond,'-alphas',[0:2:10])
%
% Author: André Rezende Dessimoni Carvalho
%

%% ===================================================================== %%
%								PREPARATION								  %
% ======================================================================= %

% Flags
% -------------------------------------
% Default flags
pol_append		= false;		% Append polar
NL_simulation	= false;		% Check if the code is called by the nonlinear VLM
GetLoads		= false; 
GetCoeffs		= false;

% User Flags
i=1;
while i <= length(varargin)
	switch varargin{i}
		case '-append'
			pol_append = true;
			i=i+1;
		case '-NL'
			NL_simulation = true; 
			alpha	= varargin{i+1}*180/pi;
			w		= varargin{i+2};
			iter_NL = varargin{i+3};
			i=i+4;
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



% WAKE DISCRETIZATION
% -------------------------------------
if ~plane.Aero.Settings.WakeInitialized  % If not yet initialized
	if (NL_simulation && iter_NL==0) || ~NL_simulation	 % If it is called by the NonLinear code, just compute in the first iteraction
		DiscretizerWake(plane, fltcond);
	end
    if	plane.Aero.Settings.WakeType == 1 || ...		% Fixed wake just have to be computed once
		plane.Aero.Settings.WakeType == 3				% Free wake is computed in a dedicated routine
		plane.Aero.Settings.WakeInitialized = 1;
    end
end



% NUMBER OF LS's AND AERODYNAMIC PANELS
% -------------------------------------
% Number of LS's
nLS   = length(plane.LiftingSurfaces);

% Number of stations on each LS
nstat = zeros(nLS,1);
for LSn=1:nLS
	nstat(LSn) = length(plane.LiftingSurfaces(LSn).Geo.C);
end

% Number of spanwise aerodynamic panels
npan  = zeros(nLS,1);
for LSn=1:nLS
		npan(LSn) =	plane.LiftingSurfaces(LSn).Aero.Mesh.Ny_tot;
end
nmesh = sum(npan);

% CONSTANTS
% -------------------------------------
CG  = repmat(plane.Mass.CG,nmesh,1);	% CG Coordinates
S   = plane.Geo.Area.Sref;				% Reference area

% "GLOBAL" MATRICES
% -------------------------------------
n		= plane.Aero.Mesh.Normal;					% Normal to aerodynamic panels
PC34	= plane.Aero.Mesh.PC34;						% Control points coordinates at 3/4*c
PC25	= plane.Aero.Mesh.PC25;						% Control points coordinates at 1/4*c
c       = plane.Aero.Mesh.Chord;					% Chord of aerdynamic panels
Yb0		= plane.Aero.Mesh.Yb0;						% Yb panel coordinates
dArea	= plane.Aero.Mesh.Area;
Vort	= plane.Aero.Wake.Vortices;					% Vortex sheet

% FLIGHT CONDITIONS
% -------------------------------------
Voo		= fltcond.Voo;										
beta	= fltcond.beta *ones(nmesh,1);
p		= fltcond.p;
q		= fltcond.q;
r		= fltcond.r;
rho		= fltcond.rho;

if ~NL_simulation
	alpha	= fltcond.alpha*ones(nmesh,1);
end


%% ===================================================================== %%
%									SOLVER								  %
% ======================================================================= %


% MATRIX OF INFLUENCE
% ------------------------------------
if ~NL_simulation
	if (isempty(plane.Aero.Mesh.InfluenceMatrix) || plane.Aero.Settings.WakeType~=1) || ...
	   (isempty(plane.Aero.Mesh.InfluenceMatrix) && plane.Aero.Settings.WakeType==1)
			w = InfluenceMatrix(plane,fltcond);
	else 
		w = plane.Aero.Mesh.InfluenceMatrix;
	end
end

% VELOCITY COMPONENTS
% ------------------------------------
% Uniform velocity
Voo_vec(:,1:3) = Voo*[cosd(alpha).*cosd(beta), -cosd(alpha).*sind(beta), sind(alpha)];

% Maneuver velocity
r34 = PC34 - CG.*ones(nmesh,3);
Vm  = zeros(nmesh,3);
for i=1:nmesh
    Vm(i,:) = cross(r34(i,:),[p q r]);
end

% Free stream components
V_vec = Voo_vec+Vm;


% UNDISTUBED VELOCITY MATRIX (RHS of the system eq.)
% ------------------------------------
B = zeros(nmesh,1);
for i=1:nmesh
	N = n(i,:);
	N = N/norm(N);
	B(i,1) = -dot(V_vec(i,:),N) ;
end


% SOLVING SYSTEM TO FIND CIRCULATION
% ------------------------------------
G = linsolve(w,B);


%% ===================================================================== %%
%							POST CALCULATIONS							  %
% ======================================================================= %

% FORCE(y) AND cl(y) CALCULATION
% ------------------------------------
if fltcond.beta == 0
	
	 % See Anderson, Fundamental of Aerodynamics (5 ed.), Eq. 5.21
	 cl = 2*G./(Voo.*c);

else
	
	Vind14 = zeros(nmesh,3);
	Vtot14 = zeros(nmesh,3);
	dF	   = zeros(nmesh,3);

	for i=1:nmesh

		% Induced velocity at 1/4*c of the i-Panel by the j-Vortices
		for j=1:nmesh	
			Vind14(i,:)	= Vind14(i,:) + VORTEX_INDUCED_mex(PC25(i,:),Vort(j,:,:),G(j),1);
		end

		% Total velocity at 1/4*c, including induced, uniform and maneuver
		Vtot14(i,:) = Vind14(i,:) + Voo_vec(i,:) + Vm(i,:);

		% V2-V1 is the geometric vector of the bounding vortex of the i-panel
		V1 = [Vort(i, end/2,   1)	Vort(i, end/2,   2)		Vort(i, end/2,   3)];
		V2 = [Vort(i, end/2+1, 1)	Vort(i, end/2+1, 2)		Vort(i, end/2+1, 3)];

		% Force at the panel i
		dF(i,:) = rho*cross(Vtot14(i,:),(V2-V1)*G(i));
	end

	dFx = dF(:,1);
	dFy = dF(:,2);
	dFz = dF(:,3);
	cx	= dFx./(.5*rho*Voo^2.*dArea);
	cy	= dFy./(.5*rho*Voo^2.*dArea);
	cz	= dFz./(.5*rho*Voo^2.*dArea);
	
	cl =	dF(:,3)./(.5*rho*Voo^2.*gradient(Yb0).*c);
% 	cdi =	dF(:,1)./(.5*rho*Voo^2.*gradient(Yb0).*c);
	
	plane.Aero.Loads(polar_n).fx = dFx;
	plane.Aero.Loads(polar_n).fy = dFy;
	plane.Aero.Loads(polar_n).fz = dFz;
	plane.Aero.Loads(polar_n).cx = cx;
	plane.Aero.Loads(polar_n).cy = cy;
	plane.Aero.Loads(polar_n).cz = cz;
% 	plane.Aero.Loads(polar_n).cdi = cdi;
	
	
	for LSn=1:nLS
		index_LS = plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2);
		plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cx = cx(index_LS);
		plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cy = cy(index_LS);
		plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cz = cz(index_LS);
% 		plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cdi = cdi(index_LS);
	end
end

% figure(1); hold on
% for LSn=1:nLS
% 	ind = plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2);
% 	plot(Yb0(ind),G(ind))
% end

%% ===================================================================== %%
%									OUTPUTS								  %
% ======================================================================= %

CL = 1/S * trapz(Yb0,c.*cl);

if ~ NL_simulation
	if GetLoads
		InterpSpanData( plane, 2, polar_n );

		if GetCoeffs
			CalcCoeffs( plane, polar_n)
		end
	end
end

