function DiscretizerWake( plane, fltcond )

%{
Vertex convention

BVerts:
1------2
| ---  |
|    | |
| <--  |
4      3

Leg Verts:
1	   1
|	   |
|	   |
|	   |
2      2
|	   |
|	   |
|	   |
3      3

Global Verts:
3 ---- 4
|	   |
|	   |
|	   |
2      5
|	   |
|	   |
|	   |
1      6

%}


switch plane.Aero.Settings.WakeType
	case 1
		nBound = 2;				% Number of bound vertex
		nLeg = 1;				% Number of points on the Leg Vortex 
		INF = 30*plane.Geo.b;	% Infinite X coordinate
	case 2
		nBound = 4;		
		nLeg = 2;
		INF = 30*plane.Geo.b;
	case 3
		nBound = 4;		
		nLeg = 10;
		INF = 10;		
end

if ~plane.Aero.Settings.WakeInitialized

	nLS		 = plane.Geo.nLS;
	nmesh_LS = plane.Aero.nmeshLS;
	nmesh	 = plane.Aero.nmesh;
	
	Vort	 = zeros(nmesh,2*(nLeg-1)+4,3);
	
	pani=0;
	for LSn=1:nLS
	

		w = plane.LiftingSurfaces(LSn).Aero.Wake;
		m = plane.LiftingSurfaces(LSn).Aero.Mesh;


		w.BVerts  = zeros(m.Ny_tot, nBound, 3);
		w.LLVerts = zeros(m.Ny_tot, nLeg,	3);
		w.RLVerts = zeros(m.Ny_tot, nLeg,	3);



		for i=1:m.Ny_tot

			switch plane.Aero.Settings.WakeType

				% FIXED WAKE
				% ----------------------
				case 1		

					% BOUND VORTEX - Vertex 1
						w.BVerts(i,1,1) = m.Verts.v1(i,1)+0.25*(m.Verts.v4(i,1)-m.Verts.v1(i,1));
						w.BVerts(i,1,2) = m.Verts.v1(i,2);
						w.BVerts(i,1,3) = m.Verts.v1(i,3);
					% BOUND VORTEX - Vertex 2
						w.BVerts(i,2,1) = m.Verts.v2(i,1)+0.25*(m.Verts.v3(i,1)-m.Verts.v2(i,1));
						w.BVerts(i,2,2) = m.Verts.v2(i,2);
						w.BVerts(i,2,3) = m.Verts.v2(i,3);

					% Left vertex nLeg
						w.LLVerts(i,1,1) = INF;
						w.LLVerts(i,1,2) = w.LLVerts(i,1,2);
						w.LLVerts(i,1,3) = w.LLVerts(i,1,3);
					% Right vertex nLeg
						w.RLVerts(i,1,1) = INF;
						w.RLVerts(i,1,2) = w.RLVerts(i,1,2);
						w.RLVerts(i,1,3) = w.RLVerts(i,1,3);


				% ALIGNED WAKE
				% ----------------------
				case 2

					% BOUND VORTEX - Vertex 1
						w.BVerts(i,1,1) = m.Verts.v1(i,1)+0.25*(m.Verts.v4(i,1)-m.Verts.v1(i,1));
						w.BVerts(i,1,2) = m.Verts.v1(i,2);
						w.BVerts(i,1,3) = m.Verts.v1(i,3);
					% BOUND VORTEX - Vertex 2
						w.BVerts(i,2,1) = m.Verts.v2(i,1)+0.25*(m.Verts.v3(i,1)-m.Verts.v2(i,1));
						w.BVerts(i,2,2) = m.Verts.v2(i,2);
						w.BVerts(i,2,3) = m.Verts.v2(i,3);
					% BOUND VORTEX - Vertex 3
						w.BVerts(i,3,1) = m.Verts.v3(i,1);
						w.BVerts(i,3,2) = m.Verts.v3(i,2);
						w.BVerts(i,3,3) = m.Verts.v3(i,3);
					% BOUND VORTEX - Vertex 4
						w.BVerts(i,4,1) = m.Verts.v4(i,1);
						w.BVerts(i,4,2) = m.Verts.v4(i,2);
						w.BVerts(i,4,3) = m.Verts.v4(i,3);

					% LEG VORTEX - Left vertex 1
						w.LLVerts(i,1,1) = m.Verts.v4(i,1);
						w.LLVerts(i,1,2) = m.Verts.v4(i,2);
						w.LLVerts(i,1,3) = m.Verts.v4(i,3);
					% LEG VORTEX - Right vertex 1
						w.RLVerts(i,1,1) = m.Verts.v3(i,1);
						w.RLVerts(i,1,2) = m.Verts.v3(i,2);
						w.RLVerts(i,1,3) = m.Verts.v3(i,3);

					% LEG VORTEX - Left vertex 2
						w.LLVerts(i,2,1) = INF;
						w.LLVerts(i,2,2) = w.LLVerts(i,1,2) - w.LLVerts(i,nLeg,1) * tand(fltcond.beta);
						w.LLVerts(i,2,3) = w.LLVerts(i,1,3) + w.LLVerts(i,nLeg,1) * tand(fltcond.alpha);
					% LEG VORTEX - Right vertex 2
						w.RLVerts(i,2,1) = INF;
						w.RLVerts(i,2,2) = w.RLVerts(i,1,2) - w.RLVerts(i,nLeg,1) * tand(fltcond.beta);
						w.RLVerts(i,2,3) = w.RLVerts(i,1,3) + w.RLVerts(i,nLeg,1) * tand(fltcond.alpha);


				% FREE WAKE
				% ----------------------
				case 3

					% BOUND VORTEX - Vertex 1
						w.BVerts(i,1,1) = m.Verts.v1(i,1)+0.25*(m.Verts.v4(i,1)-m.Verts.v1(i,1));
						w.BVerts(i,1,2) = m.Verts.v1(i,2);
						w.BVerts(i,1,3) = m.Verts.v1(i,3);
					% BOUND VORTEX - Vertex 2
						w.BVerts(i,2,1) = m.Verts.v2(i,1)+0.25*(m.Verts.v3(i,1)-m.Verts.v2(i,1));
						w.BVerts(i,2,2) = m.Verts.v2(i,2);
						w.BVerts(i,2,3) = m.Verts.v2(i,3);
					% BOUND VORTEX - Vertex 3
						w.BVerts(i,3,1) = m.Verts.v3(i,1);
						w.BVerts(i,3,2) = m.Verts.v3(i,2);
						w.BVerts(i,3,3) = m.Verts.v3(i,3);
					% BOUND VORTEX - Vertex 4
						w.BVerts(i,4,1) = m.Verts.v4(i,1);
						w.BVerts(i,4,2) = m.Verts.v4(i,2);
						w.BVerts(i,4,3) = m.Verts.v4(i,3);

					% Deltas
						dx = INF/nLeg;
						dy = (w.LLVerts(i,1,2) + w.LLVerts(i,nLeg,1) * tand(fltcond.beta) )/nLeg;
						dz = (w.LLVerts(i,1,3) + w.LLVerts(i,nLeg,1) * tand(fltcond.alpha))/nLeg;
					% LEG VORTEX - Left vertex 1
						w.LLVerts(i,1,1) = m.Verts.v4(i,1);
						w.LLVerts(i,1,2) = m.Verts.v4(i,2);
						w.LLVerts(i,1,3) = m.Verts.v4(i,3);
					% LEG VORTEX - Right vertex 1
						w.RLVerts(i,1,1) = m.Verts.v3(i,1);
						w.RLVerts(i,1,2) = m.Verts.v3(i,2);
						w.RLVerts(i,1,3) = m.Verts.v3(i,3);
					for nn=2:nLeg
						% LEG VORTEX - Left vertex n
							w.LLVerts(i,nn,1) = w.LLVerts(i,nn-1,1)+dx;
							w.LLVerts(i,nn,2) = w.LLVerts(i,nn-1,2)+dy;
							w.LLVerts(i,nn,3) = w.LLVerts(i,nn-1,3)+dz;
						% LEG VORTEX - Right vertex n
							w.RLVerts(i,nn,1) = w.RLVerts(i,nn-1,1)+dx;
							w.RLVerts(i,nn,2) = w.RLVerts(i,nn-1,2)+dy;
							w.RLVerts(i,nn,3) = w.RLVerts(i,nn-1,3)+dz;						
					end

			end


		end


		
		plane.LiftingSurfaces(LSn).Aero.Wake = w;

		
		
		BVerts  = plane.LiftingSurfaces(LSn).Aero.Wake.BVerts;		
		LLVerts = plane.LiftingSurfaces(LSn).Aero.Wake.LLVerts;
		RLVerts = plane.LiftingSurfaces(LSn).Aero.Wake.RLVerts;
		
		for pann=1:nmesh_LS(LSn)
			pani=pani+1;
			switch plane.Aero.Settings.WakeType
				
				% FIXED WAKE
				% ----------------------
				case 1
					Vort(pani,:,:)= [	LLVerts(pann,1,1) LLVerts(pann,1,2) LLVerts(pann,1,3)
										 BVerts(pann,1,1)  BVerts(pann,1,2)  BVerts(pann,1,3)
										 BVerts(pann,2,1)  BVerts(pann,2,2)  BVerts(pann,2,3)
										RLVerts(pann,1,1) RLVerts(pann,1,2) RLVerts(pann,1,3) ];
									
				% ALIGNED WAKE
				% ----------------------
				case 2
					Vort(pani,:,:)= [	LLVerts(pann,2,1) LLVerts(pann,2,2) LLVerts(pann,2,3)
										 BVerts(pann,4,1)  BVerts(pann,4,2)  BVerts(pann,4,3)
										 BVerts(pann,1,1)  BVerts(pann,1,2)  BVerts(pann,1,3)
										 BVerts(pann,2,1)  BVerts(pann,2,2)  BVerts(pann,2,3)
										 BVerts(pann,3,1)  BVerts(pann,3,2)  BVerts(pann,3,3)
										RLVerts(pann,2,1) RLVerts(pann,2,2) RLVerts(pann,2,3) ];
									
				% FREE WAKE
				% ----------------------
				case 3
					Vort(pani,:,:)= [	LLVerts(pann,2:end,1)'	LLVerts(pann,2:end,2)'	LLVerts(pann,2:end,3)'
										 BVerts(pann,4,1)		 BVerts(pann,4,2)		 BVerts(pann,4,3)
										 BVerts(pann,1,1)		 BVerts(pann,1,2)		 BVerts(pann,1,3)
										 BVerts(pann,2,1)		 BVerts(pann,2,2)		 BVerts(pann,2,3)
										 BVerts(pann,3,1)		 BVerts(pann,3,2)		 BVerts(pann,3,3)
										RLVerts(pann,2:end,1)'	RLVerts(pann,2:end,2)'	RLVerts(pann,2:end,3)' ];
					
			end

			
			
		end
	end
	
	plane.Aero.Wake.Vortices  = Vort;


end







