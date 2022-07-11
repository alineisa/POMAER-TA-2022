classdef Airplane_Aero_Mesh

	properties
		npan
		Verts = struct(	'v1',[],  ...	% (OUTPUT)  Corner vertex of each panel
						'v2',[],  ...
						'v3',[],  ...
						'v4',[])
		PC25							% (OUTPUT)  Control point at 25% of the local chord
		PC34							% (OUTPUT)  Control point at 34% of the local chord
		Normal							% (OUTPUT)  Normal unitary vector
		Yb								% (OUTPUT)  Yb coordinates
		Yb0								% (OUTPUT)  Yb starting at 0
		dYb
		Chord							% (OUTPUT)  Chord length
		Area
		Twist
		InfluenceMatrix
	end
	
	methods
	end
	
end

