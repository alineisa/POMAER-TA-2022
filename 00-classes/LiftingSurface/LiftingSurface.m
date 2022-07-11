classdef LiftingSurface <handle
	% Lifting Surface Class
	
	properties
		ID		= 1						% Surface ID
		IsMain  = 0
		label							% Surface name
		Active  = 1						% Surface actived (used in computations)
		Geo@LiftingSurface_Geo			% Geometrical definitions
		Aero@LiftingSurface_Aero		% Aerodynamic analysis
		CG		= struct('M',[],...		% CG mass
						 'x',[],...		% Cg Position
						 'y',[],...
						 'z',[])
		
	end

	methods
		
		function [obj] = LiftingSurface(label)
			obj.label = label;
			obj.ID    = obj.set_ID;
			if obj.ID == 1
				obj.IsMain = 1;
			end
				
			obj.Geo   = LiftingSurface_Geo(obj.ID);
			obj.Aero  = LiftingSurface_Aero(obj.ID);
		end

	end
	
	methods (Static = true)
				
		function ID = set_ID()
			persistent ID_i
			if isempty(ID_i)
				ID_i=0;
			end
			ID_i=ID_i+1;
			ID = ID_i;
		end
		
		function PlotCpX ()
		end
		function PlotCpXY ()
		end
		function PlotCpSurf ()
		end
	end
	
end

