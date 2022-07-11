function [ cl_visc ] = InterpSpanData_bkp( plane, fltcond,alpha_eff )

%{
          perf_1    perf_2
           o--------o
  o--------o
perf_2   perf_1

1 2 1 2

%}
nLS = plane.Geo.nLS;
nstat = plane.Geo.nstatLS;

if plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq
	interp = '';
else
	interp = 'interp';
end






cl_visc		= zeros(nmesh,1);
Re_pan		= zeros(nmesh,1);

i=0;
for LSn=1:nLS
	IsSym = 1; if plane.LiftingSurfaces(LSn).Geo.YSymmetry; IsSym = 2; end
	
	for statn=1:nstat(LSn)-1
		for pann=1:plane.LiftingSurfaces(LSn).Aero.Mesh.Ny(statn)*IsSym
			
			i=i+1;
			
			Re_pan(i) = plane.LiftingSurfaces(LSn).Aero.Mesh.Chord(pann)*...
				fltcond.Voo*fltcond.rho/fltcond.mi;
			
			
			alpha_eff(i) = 0;
			
			switch plane.LiftingSurfaces(LSn).Aero.Airfoils.InterpType(statn)
				
				% Do not interpolate airfoil data (Use inner station data only)
				case 0
				
					cl_visc(i,1)	= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);
				
					
				% Interpolate airfoil data linearly (Between inner and outer stations)
				case 1
					
					y1 = plane.LiftingSurfaces(LSn).Geo.Yb(statn);
					y2 = plane.LiftingSurfaces(LSn).Geo.Yb(statn+1);
					if plane.LiftingSurfaces(LSn).Geo.YSymmetry
						if pann <= plane.LiftingSurfaces(LSn).Aero.Mesh.Ny*IsSym/2
							y1 = -y2;
							y2 = -y1;
						end
					end

					cl_visc_1	= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn  ).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);
					cl_visc_2	= plane.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn+1).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);

					if plane.LiftingSurfaces(LSn).Geo.YSymmetry
						if pann <= plane.LiftingSurfaces(LSn).Aero.Mesh.Ny*IsSym/2
							cl_visc_1 = cl_visc_2;
							cl_visc_2 = cl_visc_1;
						end
					end

					cl_visc(i,1)= interp1([y1,y2],[cl_visc_1,cl_visc_2],plane.LiftingSurfaces(LSn).Aero.Mesh.PCYb(pann));
					
			end
			
		end
	end
end



return








i=0;
for LSn=1:nLS
	
	if plane.LiftingSurfaces(LSn).Geo.YSymmetry
		IsSym_factor = 2;
		Yb			= [-fliplr(	plane.LiftingSurfaces(LSn).Geo.Yb) ...
								plane.LiftingSurfaces(LSn).Geo.Yb];
		InterpType	= [ fliplr(	plane.LiftingSurfaces(LSn).Aero.Airfoils.InterpType) ...
								plane.LiftingSurfaces(LSn).Aero.Airfoils.InterpType];
		AirfoilData = [ fliplr(	plane.LiftingSurfaces(LSn).Aero.Airfoils.Data) ...
								plane.LiftingSurfaces(LSn).Aero.Airfoils.Data];
	else
		IsSym_factor = 1;
		Yb			= plane.LiftingSurfaces(LSn).Geo.Yb;
		InterpType	= plane.LiftingSurfaces(LSn).Aero.Airfoils.InterpType;
		AirfoilData = plane.LiftingSurfaces(LSn).Aero.Airfoils.Data;
	end
	
	
	for ii=1:plane.LiftingSurfaces(LSn).Aero.Mesh.Ny_tot
		for jj=1:length(Yb)-1
			if plane.LiftingSurfaces(LSn).Aero.Mesh.PCYb(ii)>=Yb(jj)
				YE(LSn,ii) = Yb(jj);
			end
		end
		for jj=length(Yb)-1:-1:1
			if plane.LiftingSurfaces(LSn).Aero.Mesh.PCYb(ii)<Yb(jj+1)
				YD(LSn,ii) = Yb(jj+1);
			end
		end
	end
	
	
	for statn=1:length(Yb)-1
		for pann=1:plane.LiftingSurfaces(LSn).Aero.Mesh.Ny*IsSym_factor
			
			i=i+1;
			Re_pan(i) = plane.LiftingSurfaces(LSn).Aero.Mesh.Chord(pann)*...
				fltcond.Voo*fltcond.rho/fltcond.mi;
			
			
			switch InterpType
				
				% Do not interpolate between stations (use the inner station data)
				case 0
					cl_visc(i,1)	= AirfoilData(statn  ).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);
					
					
					% Interpolate linearly between inner and outer stations
				case 1
					
					alpha_eff(i)=0;
					cl_visc_1	= AirfoilData.Aero.Airfoils.Data(statn  ).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);
					cl_visc_2	= AirfoilData.Aero.Airfoils.Data(statn+1).Cl(alpha_eff(i)*180/pi,Re_pan(i),interp);
					
					cl_visc(i,1)= interp1([YE(LSn,pann),YD(LSn,pann)] , [cl_visc_1, cl_visc_2] , plane.LiftingSurfaces(LSn).Aero.Mesh.PCYb(pann));
					
				otherwise
					error('No valid type interpolation')
			end
			
			
		end
	end
end
%

end

