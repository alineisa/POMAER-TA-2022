function [ out ] = InterpSpanData( plane, mode, polar_n )

% ======================================================================= %
%								PREPARE									  %
% ======================================================================= %
persistent warning_polar
if isempty(warning_polar)
    warning_polar=0;
end

nLS		= plane.Geo.nLS;

if plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq == 1
	interp = [];
else
	interp = 'interp';
end

Re_pan		= plane.Aero.Loads(polar_n).Re_pan;
alpha_eff	= plane.Aero.Loads(polar_n).alpha_eff;

% ======================================================================= %
%							   CALCULATE								  %
% ======================================================================= %

cl = zeros(plane.Aero.Mesh.npan,1);
cd = zeros(plane.Aero.Mesh.npan,1);
cm = zeros(plane.Aero.Mesh.npan,1);

i=0;
for LSn=1:nLS % For each LiftingSurface
	
	% Number of panels on the LiftingSurface LSn
	npan = plane.LiftingSurfaces(LSn).Aero.Mesh.Ny_tot;
	
	
	for pann=1:npan % For each aero panel of the LiftingSurface LSn
		
		% indice i is used refering to the global (merged) mesh, used by alpha_eff and Re_pan
		i=i+1;	
		
		
		Yinner_ind = plane.LiftingSurfaces(LSn).Aero.Mesh.SpanInner_ind(pann);
		Youter_ind = plane.LiftingSurfaces(LSn).Aero.Mesh.SpanOuter_ind(pann);

		AirfoilData_inner	= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(Yinner_ind);
		AirfoilData_outer	= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(Youter_ind);
		
		
		
		% GET DATA FROM AIRFOIL DATA
		% -------------------------------------------------------------
	
		switch plane.LiftingSurfaces(LSn).Aero.Airfoils.InterpType(Yinner_ind)
			
			% Do not interpolate airfoil data (Use inner station data only)
			case 0
				switch mode
					
					% Return only cl (used in NLVLM)
					case 1
						
						cl(i)	= AirfoilData_inner.cl(alpha_eff(i),Re_pan(i),interp);
				
					% Return cd, cm 
					case 2
						
						if isempty([AirfoilData_inner.pol.Re])
							ReIndex = 1;
						else
							[~,ReIndex] = min(abs([AirfoilData_inner.pol.Re]-Re_pan(i)));
						end
						
						ind_a1 = find(AirfoilData_inner.pol(ReIndex).alpha<=alpha_eff(i),1,'last');
						if ind_a1 == length(AirfoilData_inner.pol(ReIndex).alpha)
							ind_a1 = ind_a1 -1;
                        elseif isempty(ind_a1)
                            ind_a1=1;
                            if warning_polar==0;
                            warning_polar=1;
%                             warning('Polares insuficientes: o c�digo est� realizando extrapola��o de alpha')
                            end
						end
						ind_a2 = ind_a1+1;
						
						a1 = AirfoilData_inner.pol(ReIndex).alpha(ind_a1);
						a2 = AirfoilData_inner.pol(ReIndex).alpha(ind_a2);
						
						
						if ~isempty([AirfoilData_inner.pol.cd])
							cd1 = AirfoilData_inner.pol(ReIndex).cd(ind_a1);
							cd2 = AirfoilData_inner.pol(ReIndex).cd(ind_a2);
						
							cd(i) = interp1([a1 a2], [cd1 cd2], alpha_eff(i),'linear','extrap');
						end
						if ~isempty([AirfoilData_inner.pol.cm])
							cm1 = AirfoilData_inner.pol(ReIndex).cm(ind_a1);
							cm2 = AirfoilData_inner.pol(ReIndex).cm(ind_a2);
						
							cm(i) = interp1([a1 a2], [cm1 cm2], alpha_eff(i),'linear','extrap');
						end
						
				end
				
				
				
				
				
				
			% Interpolate airfoil data linearly (Between inner and outer stations)
			case 1
				switch mode
					
					% Return only cl (used in NLVLM)
					case 1
						
						clInner		= AirfoilData_inner.cl(alpha_eff(i),Re_pan(i),interp);
						clOuter		= AirfoilData_outer.cl(alpha_eff(i),Re_pan(i),interp);
						
						perc   = plane.LiftingSurfaces(LSn).Aero.Mesh.SpanPercent(pann);
						cl(i)  = clInner*(1-perc) + clOuter*perc;
						
						
					% Return cd, cm 
					case 2
						if isempty([AirfoilData_inner.pol.Re])
							ReIndex_inner = 1;
						else
							[~,ReIndex_inner]=min(abs([AirfoilData_inner.pol.Re]-Re_pan(i)));
						end
						
						ind_a1_inner = find(AirfoilData_inner.pol(ReIndex_inner).alpha<=alpha_eff(i),1,'last');
						if ind_a1_inner == length(AirfoilData_inner.pol(ReIndex_inner).alpha)
							ind_a1_inner = ind_a1_inner -1;
						elseif isempty(ind_a1_inner)
							ind_a1_inner = 1;
                            if warning_polar==0;
                            warning_polar=1;
%                             warning('Polares insuficientes: o c�digo est� realizando extrapola��o de alpha')
                            end
						end
						ind_a2_inner = ind_a1_inner+1;
						
						a1_inner = AirfoilData_inner.pol(ReIndex_inner).alpha(ind_a1_inner);
						a2_inner = AirfoilData_inner.pol(ReIndex_inner).alpha(ind_a2_inner);
						
						
						if isempty([AirfoilData_outer.pol.Re])
							ReIndex_outer = 1;
						else
							[~,ReIndex_outer]=min(abs([AirfoilData_outer.pol.Re]-Re_pan(i)));
						end
						
						ind_a1_outer = find(AirfoilData_outer.pol(ReIndex_outer).alpha<=alpha_eff(i),1,'last');
						if ind_a1_outer == length(AirfoilData_outer.pol(ReIndex_outer).alpha)
							ind_a1_outer = ind_a1_outer -1;
						elseif isempty(ind_a1_outer)
							ind_a1_outer = 1;
						end
						ind_a2_outer = ind_a1_outer+1;                      
						
						a1_outer = AirfoilData_outer.pol(ReIndex_outer).alpha(ind_a1_outer);
						a2_outer = AirfoilData_outer.pol(ReIndex_outer).alpha(ind_a2_outer);
						
						
						if ~all([isempty(AirfoilData_inner.pol(ReIndex_inner).cd), isempty(AirfoilData_outer.pol(ReIndex_outer).cd)])
							cd1_inner = AirfoilData_inner.pol(ReIndex_inner).cd(ind_a1_inner);
							cd2_inner = AirfoilData_inner.pol(ReIndex_inner).cd(ind_a2_inner);
							cdInner = interp1([a1_inner a2_inner], [cd1_inner cd2_inner], alpha_eff(i),'linear','extrap');

							cd1_outer = AirfoilData_outer.pol(ReIndex_outer).cd(ind_a1_outer);
							cd2_outer = AirfoilData_outer.pol(ReIndex_outer).cd(ind_a2_outer);
							cdOuter = interp1([a1_outer a2_outer], [cd1_outer cd2_outer], alpha_eff(i),'linear','extrap');
							
							perc   = plane.LiftingSurfaces(LSn).Aero.Mesh.SpanPercent(pann);
							cd(i)  = cdInner*(1-perc) + cdOuter*perc;
							
						end
						if ~all([isempty(AirfoilData_inner.pol(ReIndex_inner).cm) isempty(AirfoilData_outer.pol(ReIndex_outer).cm)])
							cm1_inner = AirfoilData_inner.pol(ReIndex_inner).cm(ind_a1_inner);
							cm2_inner = AirfoilData_inner.pol(ReIndex_inner).cm(ind_a2_inner);
							cmInner = interp1([a1_inner a2_inner], [cm1_inner cm2_inner], alpha_eff(i),'linear','extrap');
							
							cm1_outer = AirfoilData_outer.pol(ReIndex_outer).cm(ind_a1_outer);
							cm2_outer = AirfoilData_outer.pol(ReIndex_outer).cm(ind_a2_outer);
							cmOuter = interp1([a1_outer a2_outer], [cm1_outer cm2_outer], alpha_eff(i),'linear','extrap');
							
							perc   = plane.LiftingSurfaces(LSn).Aero.Mesh.SpanPercent(pann);
							cm(i)  = cmInner*(1-perc) + cmOuter*perc;
							
						end
						
						
				end
		end
		
	end 
	
end		


% ======================================================================= %
%							     OUTPUT									  %
% ======================================================================= %




switch mode
	case 1
		
		out = cl';
		
		plane.Aero.Loads(polar_n).cl = cl;
		
		for LSn=1:nLS
			plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cl = cl(plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : ...
				                                            	  plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2));
		end
		
	case 2
		
		out = [cd' cm'];
		
		if ~isempty([AirfoilData_inner.pol.cd])
			plane.Aero.Loads(polar_n).cd0 = cd;
			for LSn=1:nLS
				plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cd0 = cd(plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : ...
																	   plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2));
			end
		end

		if ~isempty([AirfoilData_inner.pol.cm])
			plane.Aero.Loads(polar_n).cm25 = cm;
			for LSn=1:nLS
				plane.LiftingSurfaces(LSn).Aero.Loads(polar_n).cm25 = cm(plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : ...
																   plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2));
			end
		end
		
		
end

