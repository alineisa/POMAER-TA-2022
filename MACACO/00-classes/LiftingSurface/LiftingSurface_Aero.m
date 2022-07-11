classdef LiftingSurface_Aero
	
	properties
		ID
		Airfoils@LiftingSurface_Aero_Airfoils
		Mesh@LiftingSurface_Aero_Mesh
		Wake@LiftingSurface_Aero_Wake 
		Loads@LiftingSurface_Aero_Loads 
		Coeffs@LiftingSurface_Aero_Coeffs
		Derivatives@LiftingSurface_Aero_Derivatives
	end
	
	
	
	
	methods
		% =========================================================================
		function obj = LiftingSurface_Aero(ID)
			obj.ID = ID;
			
			obj.Airfoils	= LiftingSurface_Aero_Airfoils;
			obj.Mesh		= LiftingSurface_Aero_Mesh;
			obj.Wake		= LiftingSurface_Aero_Wake;
			obj.Loads		= LiftingSurface_Aero_Loads;
			obj.Coeffs		= LiftingSurface_Aero_Coeffs;
			obj.Derivatives	= LiftingSurface_Aero_Derivatives;
			
		end
		
		function obj = ScaleCoeffs(obj, Sref_new)
			% Scale coefficients to a new reference area
			
			
		end
		
	end
		
		

	
end

