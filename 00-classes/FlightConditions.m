classdef FlightConditions
	
	
	properties
		
		H			= 0			% Flight altitude			[m]
		Voo						% Free-stream velocity		[m/s]
		cref					% Reference chord for reynolds calculation [m]
		Re_cref					% Reynolds based on cref
		Re_L					% Reynolds per unit length
		Ma						% Mach number
		alpha		= 0;		% Airplane angle of attack  [degrees]
		beta		= 0;		% Airplane slip angle		[degrees]
		
		p			= 0;		% Roll rate					[m/s]
		q			= 0;		% Pitch rate				[m/s]
		r			= 0;		% Yaw rate					[m/s]

		
		Too			= 288-273;	% Free-stream temperature	[°C]
		Poo			= 101325	% Free-stream s. pressure	[Pa]
		T_isa_plus	= 0;		% ISA+ temperature			[°C]
		rho			= 1.225		% Free-stream density		[kg/m3]
		mi			= 1.812e-5	% Dynamic viscosity			[kg/m.s]
		a_sound		= 340.2941	% Sound velocity			[m/s]
	end
	
	methods
		
		function obj = UpdateRe(obj)			
			obj.Re_cref = obj.rho*obj.Voo*obj.cref/obj.mi;
			obj.Re_L    = obj.rho*obj.Voo         /obj.mi;
		end
		
		
		function obj = airprop (obj)
			
			[obj.Too, obj.a_sound, obj.Poo, obj.rho] = atmosisa(obj.H);
			obj.Too = obj.Too+obj.T_isa_plus;
			
			C = 1.716e-5 * (273.15+110.4) / (273.15^1.5);
			obj.mi = C * obj.Too^1.5/(obj.Too+110.4);
			
		end
		
	end
	
end

