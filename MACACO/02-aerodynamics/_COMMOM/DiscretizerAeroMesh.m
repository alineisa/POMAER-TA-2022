function [ plane ] = DiscretizerAeroMesh( plane )
%{
LS:   class LiftingSurface
geo:  class LiftingSurface_Geo
aero: class LiftingSurface_Aero

Vertex convention
1------2
| ---  |
|    | |
| <--  |
4------3

%}
nLS = plane.Geo.nLS;


for LSn = 1:nLS
	
	
	% Simplificação de Variáveis
	LS    = plane.LiftingSurfaces(LSn);
	geo   = LS.Geo;
	aero  = LS.Aero;
	Mesh  = LS.Aero.Mesh;
	coord = LS.Geo.XYZ;

	% Quantidade de seções e paineis
	nsec = length(geo.Yb);
	npan = nsec-1;

	% =========================================================================
	% VERTICES
	% =========================================================================

	pani=1;
	panf=0;

	for n=1:npan
		theta = zeros(Mesh.Ny(n),1);

		v_LE = coord.LE(n+1,:) - coord.LE(n,:);
		v_TE = coord.TE(n+1,:) - coord.TE(n,:);

		switch Mesh.TypeY(n)

			% LINEAR
			case 1

				theta(:,1) = linspace(0,1,Mesh.Ny(n));
				theta_aux = theta;
				yb_LE = theta*v_LE;
				yb_TE = theta*v_TE;


			% COSSENOIDAL		
			case 2

				theta(:,1) = cosspace(0,1,Mesh.Ny(n));
				theta_aux = theta;
				yb_LE = theta*v_LE;
				yb_TE = theta*v_TE;


			% DIREITA
			case 3

				theta(:,1) = cos(linspace(pi/2,0,Mesh.Ny(n)));
				theta_aux = theta;
				
				yb_LE = theta*v_LE;
				yb_TE = theta*v_TE;


			% ESQUERDA
			case 4

				theta(:,1) = sin(linspace(pi/2,0,Mesh.Ny(n)));
				theta_aux = theta;
				
				yb_LE = theta*v_LE;
				yb_TE = theta*v_TE;


		end

		dyb1_LE = [[0 0 0]; diff(yb_LE)];
		dyb2_LE = [diff(yb_LE); [0 0 0]];

		dyb1_TE = [[0 0 0]; diff(yb_TE)];
		dyb2_TE = [diff(yb_TE); [0 0 0]];

		
		panf = panf + Mesh.Ny(n);
		
		aero.Mesh.Verts.v1(pani:panf,:) = coord.LE(n,:) + yb_LE-dyb1_LE/2;
		aero.Mesh.Verts.v2(pani:panf,:) = coord.LE(n,:) + yb_LE+dyb2_LE/2;

		aero.Mesh.Verts.v4(pani:panf,:) = coord.TE(n,:) + yb_TE-dyb1_TE/2;
		aero.Mesh.Verts.v3(pani:panf,:) = coord.TE(n,:) + yb_TE+dyb2_TE/2;
		
		
		
		aero.Mesh.Yb0(pani:panf,1) = theta_aux*(plane.LiftingSurfaces(LSn).Geo.Yb(n+1)-plane.LiftingSurfaces(LSn).Geo.Yb(n))+ ...
													   plane.LiftingSurfaces(LSn).Geo.Yb(n) - ...
											           plane.LiftingSurfaces(LSn).Geo.pos.y;
		
		aero.Mesh.Yb(pani:panf,1)  = theta_aux*(plane.LiftingSurfaces(LSn).Geo.Yb(n+1)-plane.LiftingSurfaces(LSn).Geo.Yb(n))+ ...
										    	 plane.LiftingSurfaces(LSn).Geo.Yb(n) + ...
											     plane.LiftingSurfaces(LSn).Geo.pos.y;
											 
		
		aero.Mesh.dYb(pani:panf,1)  = gradient(aero.Mesh.Yb(pani:panf,1));
		
		aero.Mesh.SpanPercent(pani:panf,1) = theta;
		aero.Mesh.SpanInner_ind(pani:panf,1) = n;
		aero.Mesh.SpanOuter_ind(pani:panf,1) = n+1;
		
		pani = pani + Mesh.Ny(n);
	
		


	end

	pantot = sum(Mesh.Ny(:));


	
		

	% =========================================================================
	% NORMALS, CHORDS and AREAS
	% =========================================================================

	for i=1:pantot
		
		normal =  cross( (aero.Mesh.Verts.v4(i,:) - aero.Mesh.Verts.v2(i,:)), ...
						 (aero.Mesh.Verts.v3(i,:) - aero.Mesh.Verts.v1(i,:)) );
		normal_s = norm(normal);
		
		% Unitary normal vector
		aero.Mesh.Normal(i,:) = normal/normal_s;
		
		% Twist angle (refered to the y axis)
		aero.Mesh.Twist(i,1) = atand(normal(1)/normal(3));
		
		% Chord lenght
		aero.Mesh.Chord(i,1) = ( (aero.Mesh.Verts.v4(i,1)-aero.Mesh.Verts.v1(i,1)) + ...
								 (aero.Mesh.Verts.v3(i,1)-aero.Mesh.Verts.v2(i,1)) )/2;
							 
		% Area
		v1 = aero.Mesh.Verts.v1(i,:);
		v2 = aero.Mesh.Verts.v2(i,:);
		v3 = aero.Mesh.Verts.v3(i,:);
		v4 = aero.Mesh.Verts.v4(i,:);

		a1 = AreaTriangle3D( v1, v2, v4 );
		a2 = AreaTriangle3D( v4, v2, v3 );

		aero.Mesh.Area(i,1) = a1+a2;
		
	end

	% =========================================================================
	% COLOCATION POINTS
	% =========================================================================

	for i=1:pantot
		% Colocation points at 25% of the chord of the painel centre		
		aero.Mesh.PC25(i,:) = ( (aero.Mesh.Verts.v1(i,:) + 0.25*(aero.Mesh.Verts.v4(i,:) - aero.Mesh.Verts.v1(i,:))) + ...
								(aero.Mesh.Verts.v2(i,:) + 0.25*(aero.Mesh.Verts.v3(i,:) - aero.Mesh.Verts.v2(i,:))) )/2;

		% Colocation points at 3/4 of the chord of the painel centrel
		aero.Mesh.PC34(i,:) = ( (aero.Mesh.Verts.v1(i,:) + 0.75*(aero.Mesh.Verts.v4(i,:) - aero.Mesh.Verts.v1(i,:))) + ... 
								(aero.Mesh.Verts.v2(i,:) + 0.75*(aero.Mesh.Verts.v3(i,:) - aero.Mesh.Verts.v2(i,:))) )/2;

	end


	


	% =========================================================================
	% SIMETRIA
	% =========================================================================
	IsSym = 1;
	if geo.YSymmetry
		IsSym = 2;

		% CONCATENA VARIAVEIS
		v1 = aero.Mesh.Verts.v1;
		v2 = aero.Mesh.Verts.v2;
		v3 = aero.Mesh.Verts.v3;
		v4 = aero.Mesh.Verts.v4;
		aero.Mesh.Verts.v1 = cat(1,  flipud(v2), v1);
		aero.Mesh.Verts.v2 = cat(1,  flipud(v1), v2);
		aero.Mesh.Verts.v3 = cat(1,  flipud(v4), v3);
		aero.Mesh.Verts.v4 = cat(1,  flipud(v3), v4);
		
		aero.Mesh.Area = cat(1, flipud(aero.Mesh.Area),   aero.Mesh.Area);
		
		aero.Mesh.Yb  = cat(1, -flipud(aero.Mesh.Yb),  aero.Mesh.Yb);
		aero.Mesh.Yb0 = cat(1, -flipud(aero.Mesh.Yb0), aero.Mesh.Yb0);
		aero.Mesh.dYb  = cat(1, flipud(aero.Mesh.dYb), aero.Mesh.dYb);
		
		aero.Mesh.SpanPercent   = cat(1, flipud(aero.Mesh.SpanPercent),   aero.Mesh.SpanPercent);
		aero.Mesh.SpanInner_ind = cat(1, flipud(aero.Mesh.SpanInner_ind), aero.Mesh.SpanInner_ind);
		aero.Mesh.SpanOuter_ind = cat(1, flipud(aero.Mesh.SpanOuter_ind), aero.Mesh.SpanOuter_ind);
		
		aero.Mesh.Chord = cat(1,flipud(aero.Mesh.Chord), aero.Mesh.Chord);

		aero.Mesh.PC25(1:2*pantot,1) = cat(1,  flipud(aero.Mesh.PC25(1:pantot,1)),  aero.Mesh.PC25(1:pantot,1));
		aero.Mesh.PC25(1:2*pantot,2) = cat(1, -flipud(aero.Mesh.PC25(1:pantot,2)),  aero.Mesh.PC25(1:pantot,2));
		aero.Mesh.PC25(1:2*pantot,3) = cat(1,  flipud(aero.Mesh.PC25(1:pantot,3)),  aero.Mesh.PC25(1:pantot,3));

		aero.Mesh.PC34(1:2*pantot,1) = cat(1,  flipud(aero.Mesh.PC34(1:pantot,1)),  aero.Mesh.PC34(1:pantot,1));
		aero.Mesh.PC34(1:2*pantot,2) = cat(1, -flipud(aero.Mesh.PC34(1:pantot,2)),  aero.Mesh.PC34(1:pantot,2));
		aero.Mesh.PC34(1:2*pantot,3) = cat(1,  flipud(aero.Mesh.PC34(1:pantot,3)),  aero.Mesh.PC34(1:pantot,3));


		
		
		aero.Mesh.Normal(1:2*pantot,1)    = cat(1,  flipud(aero.Mesh.Normal(1:pantot,1)),     aero.Mesh.Normal(1:pantot,1));
		aero.Mesh.Normal(1:2*pantot,2)    = cat(1, -flipud(aero.Mesh.Normal(1:pantot,2)),     aero.Mesh.Normal(1:pantot,2));
		aero.Mesh.Normal(1:2*pantot,3)    = cat(1,  flipud(aero.Mesh.Normal(1:pantot,3)),     aero.Mesh.Normal(1:pantot,3));

		aero.Mesh.Twist(1:2*pantot,1)    = cat(1,  flipud(aero.Mesh.Twist(1:pantot,1)),     aero.Mesh.Twist(1:pantot,1));
		
		% INVERTE EIXO Y DOS VERTICES
		aero.Mesh.Verts.v2(1:end/2,2) = -aero.Mesh.Verts.v2(1:end/2,2);
		aero.Mesh.Verts.v1(1:end/2,2) = -aero.Mesh.Verts.v1(1:end/2,2);
		aero.Mesh.Verts.v3(1:end/2,2) = -aero.Mesh.Verts.v3(1:end/2,2);
		aero.Mesh.Verts.v4(1:end/2,2) = -aero.Mesh.Verts.v4(1:end/2,2);

	end

	aero.Mesh.Ny_tot = IsSym*pantot;

	LS.Aero = aero;

end





% =========================================================================
% MONTAGEM DA MALHA GLOBAL
% =========================================================================

% Number of aerodynamic panels in each LS
for LSn=1:nLS
		plane.Aero(1).nmeshLS(LSn) = plane.LiftingSurfaces(LSn).Aero.Mesh.Ny_tot;
end

% Number of total aerodynamic panels
plane.Aero.nmesh = sum(plane.Aero.nmeshLS);

% Normais aos paineis
plane.Aero.Mesh.Normal	= zeros(plane.Aero.nmesh,3);

% Pontos de controle em 3/4 e 25% da corda
plane.Aero.Mesh.PC34		= zeros(plane.Aero.nmesh,3);
plane.Aero.Mesh.PC25		= zeros(plane.Aero.nmesh,3);
plane.Aero.Mesh.Normal		= zeros(plane.Aero.nmesh,3);
plane.Aero.Mesh.Chord		= zeros(plane.Aero.nmesh,1);
plane.Aero.Mesh.Yb			= zeros(plane.Aero.nmesh,1);
plane.Aero.Mesh.Yb0			= zeros(plane.Aero.nmesh,1);
plane.Aero.Mesh.dYb			= zeros(plane.Aero.nmesh,1);
plane.Aero.Mesh.Area		= zeros(plane.Aero.nmesh,1);


% Para cada superficie sustentadora LSn
pani = 0;
for LSn=1:nLS
		plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) = pani+1;
		
		for nmesh=1:plane.Aero.nmeshLS(LSn)
			pani=pani+1;

			
			plane.Aero.Mesh.Normal(pani,:)	= plane.LiftingSurfaces(LSn).Aero.Mesh.Normal(nmesh,:);
			plane.Aero.Mesh.PC34(pani,:)	= plane.LiftingSurfaces(LSn).Aero.Mesh.PC34(nmesh,:);
			plane.Aero.Mesh.PC25(pani,:)	= plane.LiftingSurfaces(LSn).Aero.Mesh.PC25(nmesh,:);
			plane.Aero.Mesh.Chord(pani,1)	= plane.LiftingSurfaces(LSn).Aero.Mesh.Chord(nmesh);
			plane.Aero.Mesh.Yb(pani,1)		= plane.LiftingSurfaces(LSn).Aero.Mesh.Yb(nmesh);
			plane.Aero.Mesh.Yb0(pani,1)		= plane.LiftingSurfaces(LSn).Aero.Mesh.Yb0(nmesh);
			plane.Aero.Mesh.dYb(pani,1)		= plane.LiftingSurfaces(LSn).Aero.Mesh.dYb(nmesh);
			plane.Aero.Mesh.Area(pani,1)	= plane.LiftingSurfaces(LSn).Aero.Mesh.Area(nmesh);
			plane.Aero.Mesh.Twist(pani,1)	= plane.LiftingSurfaces(LSn).Aero.Mesh.Twist(nmesh,1);
			
		end
		
		plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2) = pani;
end
