classdef Airplane_Aero_Settings
	
	properties
		NLVLM@Airplane_Aero_Settings_NLVLM
		FreeWake@Airplane_Aero_Settings_FreeWake
		WakeInitialized = 0;	% 0: Wake not computed; 1: Wake computed. Avoid recomputing aligned wakes in Non-Linear VLM or fixed wake in general solvers
		WakeType		= 2;	% 1: Fixed Wake; 2: Aligned Wake; 3: FreeWake
		FreeWake_nLeg	= 5;
		FreeWake_dt		= 1;

		
	end
	
	methods
		function [obj] = Airplane_Aero_Settings(obj)
			obj.NLVLM		= Airplane_Aero_Settings_NLVLM;
			obj.FreeWake	= Airplane_Aero_Settings_FreeWake;
		end
	end
	
end

