classdef Airplane_Aero

	properties
		Settings@Airplane_Aero_Settings
		
		nmeshLS
		nmesh
		
		Mesh@Airplane_Aero_Mesh
		Wake@Airplane_Aero_Wake
		Loads@Airplane_Aero_Loads
		Coeffs@Airplane_Aero_Coeffs
		Deriv@Airplane_Aero_Derivatives
							
		
	end
	
	methods
		function [obj] = Airplane_Aero()
			obj.Settings = Airplane_Aero_Settings;
			obj.Mesh	 = Airplane_Aero_Mesh;
			obj.Wake	 = Airplane_Aero_Wake;
			obj.Deriv	 = Airplane_Aero_Derivatives;
		end
	end
	
end

