classdef LiftingSurface_Aero_Mesh

	properties
		TypeY								% (INPUT)  Type of discretization in Yp direction (1: Contant, 2: cossine, 3: right, 4: left)
		TypeC								% (INPUT)  Type of discretization chord-wise (1: Contant, 2: cossine)
		
		Ny									% (INPUT)  Number of  span-wise panels
		Nc									% (INPUT)  Number of chord-wise panels
		Ny_tot								% (OUTPUT)  Total number of  span-wise panels
		Nc_tot								% (OUTPUT)  Total number of cchord-wise panels
		
		Verts = struct(	'v1',[],  ...		% (OUTPUT)  Corner vertex of each panel
						'v2',[],  ...
						'v3',[],  ...
						'v4',[])
		PC25								% (OUTPUT)  Control point at 25% of the local chord		
		PC34								% (OUTPUT)  Control point at 75% of the local chord
		Normal								% (OUTPUT)  Local unitary normal vectors
		Yb									% (OUTPUT)  Yb coordinates   - Useful for plotting loads
		Yb0									% (OUTPUT)  Yb starting at 0 - Useful for calculating coefficients
		dYb		
		Chord								% (OUTPUT)  Local chord lengths
		Area

		Twist								% (OUTPUT)  Local twist (degrees)
		IndexOnMergedMesh					%
	end
	
	properties (Hidden = true)
		SpanPercent							% (OUTPUT)  Percentage position of the current aero panel related to the inner and outer station geometric station (Yb). Used for span data interpolation (0: panel in inner station -> 1: panel in outer station)
		SpanInner_ind						% (OUTPUT)	Index of the inner geometric station (Yb). Used for informating where the panel is located in the LS.
		SpanOuter_ind						% (OUTPUT)  Index of the outer geometric station (Yb). Used for informating where the panel is located in the LS.
	end	
	
	
	methods
	end
	
end

