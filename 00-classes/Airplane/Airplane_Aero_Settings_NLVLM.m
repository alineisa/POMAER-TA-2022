classdef Airplane_Aero_Settings_NLVLM
	%
	%	Settings for the NonLinear VLM solver
	%
	% correct_2dclalpha:
	%	0:	When calculating del, use clalpha as 2*pi (default).
	%	1:  When calculating del, use clalpha as function of alpha. It is expected to change results only in non-linear region.
	%
	% Use_last_del_values:
	%	0:	Initialize del=0 on every simulation. More stable, but less efficient.
	%	1:	Use del from last converged simulation (default). It can affect results wether alpha is increasing or decreasing, as well as affect the non-linear region. (See: Mukherjee, AN ITERATIVE DECAMBERING APPROACH FOR POST-STALL PREDICTION OF WING CHARACTERISTICS USING KNOWN SECTION DATA) 
	%   2:	Use del as function of last converged simulation (It tries to estimate next del, but can become instable)
	%
	% Cl_from_adjusted_2DCurvesEq:
	%	0:	When capturing 2d cl, use interpolation between polars and alphas. (Slower but more precise)
	%	1:	When capturing 2d cl, use adjusted nonlinear equations. (Faster, but accuracy depends on the quality of the adjustent. In order to check the adjustment, type <Airfoil variable>.CheckAdjustment )
	%
	% Author: André Rezende Dessimoni Carvalho
	%
	
	properties
		correct_2dclalpha			= 0;
		Use_last_del_values			= 0; 
		Cl_from_adjusted_2DCurvesEq = 1;
	end
	
	methods
	end
	
end

