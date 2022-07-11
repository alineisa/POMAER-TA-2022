function [ w ] = InfluenceMatrix( plane, fltcond )


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



% "GLOBAL" MATRICES
% -------------------------------------
n		= plane.Aero.Mesh.Normal;					% Normal to aerodynamic panels
PC34	= plane.Aero.Mesh.PC34;						% Control points coordinates at 3/4*c
Vort	= plane.Aero.Wake.Vortices;					% Vortex sheet


% Check if it is symmetric
IsSymLS					= zeros(nLS,0);
IsSymSimulation			= 0;
IsSymSimulation_factor	= 1;
for LSn=1:nLS
		IsSymLS(LSn) = plane.LiftingSurfaces(LSn).Geo.YSymmetry;
end
if  (all(IsSymLS)    && all(npan==npan(1)) && ...
     fltcond.beta==0 && fltcond.p == 0     && fltcond.q == 0 && fltcond.r == 0)

	IsSymSimulation			= 1;
	IsSymSimulation_factor	= 0.5;
	
end


% MATRIX OF COFFICIENTS OF INFLUENCE
% -------------------------------------------------------------------------------

w    = zeros(nmesh,nmesh);

for i=1:nmesh									% influence at the i control point
	for j=1:nmesh*IsSymSimulation_factor		% by the vortex j

		% Velocity induced at point i by vortex j with unit intensity 
		Vind	= VORTEX_INDUCED_mex(PC34(i,:),Vort(j,:,:),1,1);

		% Influence matrix  (LHS of the system eq.)
		w(i,j)	= dot(Vind,n(i,:));
		
	end
end
if IsSymSimulation
 	w(1:end, nmesh/2+1:end) = rot90(w(1:end,1:nmesh/2),2);
end


plane.Aero.Mesh.InfluenceMatrix = w;
end

