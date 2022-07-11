function  GetLoadss( plane,fltcond,cl,G,Re_pan,alpha_eff,pol_append)

% GEOMMETRIC DATA
% ------------------------------------
% Quantidade de superficies sustentadoras
nLS   = plane.Geo.nLS;

% Quantidade de estacoes em cada superficie
nstat = plane.Geo.nstatLS;

% Quantdade de paineis aerodinamicos
nmesh = plane.Aero.nmesh;

% Cordas
c       = plane.Aero.Mesh.Chord;

% Posições y
y		= plane.Aero.Mesh.Yb;

% QUANTIDADE DE SUPERFICIES E PAINEIS
% ------------------------------------

i_f = 0;
if pol_append
    polar_n = length(plane.LiftingSurfaces(1).Aero.Loads(:))+1;
else
    polar_n = 1;
end


for LSn=1:nLS
	
	IsSym = 1; if plane.LiftingSurfaces(LSn).Geo.YSymmetry; IsSym = 2; end
	
	i_i = i_f+1;
	i_f = i_i+plane.LiftingSurfaces(LSn).Aero.Mesh.Ny*IsSym-1;
	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).fltcond	= fltcond;
	if ~isempty(Re_pan)
		plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Re	= Re_pan(i_i:i_f);
	end
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).c			= plane.LiftingSurfaces(LSn).Aero.Mesh.Chord;
	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).G			= G(i_i:i_f);

	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).alpha_eff	= alpha_eff(i_i:i_f);
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).alpha_i		= fltcond.alpha*pi/180 + plane.LiftingSurfaces(LSn).Aero.Mesh.ig*pi/180 - alpha_eff(i_i:i_f);
	
	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cl		= cl(i_i:i_f);
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cd0		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cdi		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cd		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cm		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cx		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cy		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cz		= [];
	
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cp		= [];
	plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).Cf		= [];	
	
end


S = plane.Geo.Area.Sref;
b = plane.Geo.b;
Voo = fltcond.Voo;

CL = 1/S * trapz(y,c.*cl);
plane.Aero.Coeffs(polar_n).CL = CL;


plane.Aero.Coeffs(polar_n).Crol = 1/(S*b) * trapz(y,cl.*c.*y);
plane.Aero.Loads(polar_n).G = G;
% 
alpha_i = plane.LiftingSurfaces(1).Aero.Loads(polar_n).alpha_i;



%Aqui só tá funcionando para um perfil, tem que implementar interpolação para dois
perf = plane.LiftingSurfaces.Aero.Airfoils.Data(1);
for i=1:nmesh
	indRe   = max(find([perf.pol.Re]<=Re_pan(i),1,'first'),1);
	ind_a_1 = max(find(perf.pol(indRe).alpha>=alpha_eff(i)*180/pi,1,'first'),2);
	ind_a_2	= ind_a_1-1;
	
	cd1 = perf.pol(7).Cd(ind_a_1);
	cd2 = perf.pol(7).Cd(ind_a_2);
	
	cd0(i,1) = interp1([perf.pol(indRe).alpha(ind_a_1),perf.pol(indRe).alpha(ind_a_2)],[cd1,cd2],alpha_eff(i)*180/pi,'linear','extrap'); 
	
	cm1 = perf.pol(7).Cm(ind_a_1);
	cm2 = perf.pol(7).Cm(ind_a_2);
	
	cm(i,1) = interp1([perf.pol(indRe).alpha(ind_a_1),perf.pol(indRe).alpha(ind_a_2)],[cm1,cm2],alpha_eff(i)*180/pi,'linear','extrap'); 
	
end




end


