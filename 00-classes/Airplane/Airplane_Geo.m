classdef Airplane_Geo

	properties
		nLS	
		nstatLS
		npanLS
		nMainLS
        b
		MAC
		MAC_Pos
		Area = struct( 'Sref',[],...
					   'Swet',[]);
	end
	
	methods
		function [obj] = Airplane_Geo()
			obj.nLS		= 1;
			obj.nstatLS	= 2;
		end
	end
	
end

