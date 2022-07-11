function [ LS ] = DiscretizerGeo( LS )
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

% Simplificação de Variáveis
geo   = LS.Geo;
aero  = LS.Aero;
Mesh  = LS.Aero.Mesh;
coord = LS.Geo.XYZ;

% Quantidade de seções e paineis
nsec = length(geo.Yb);
npan = nsec-1;

pani=1;
panf=0;
for n=1:npan

	
	switch Mesh.TypeY(n)

		% LINEAR
		case 1
				
% 			dx_LE = (coord.LE(n+1,1) - coord.LE(n,1))/Mesh.Ny(n);
% 			dy_LE = (coord.LE(n+1,2) - coord.LE(n,2))/Mesh.Ny(n);
% 			dz_LE = (coord.LE(n+1,3) - coord.LE(n,3))/Mesh.Ny(n);
% 
% 			dx_TE = (coord.TE(n+1,1) - coord.TE(n,1))/Mesh.Ny(n);
% 			dy_TE = (coord.TE(n+1,2) - coord.TE(n,2))/Mesh.Ny(n);
% 			dz_TE = (coord.TE(n+1,3) - coord.TE(n,3))/Mesh.Ny(n);
% 
% 			Xvec1 = linspace(coord.LE(n,1),       coord.LE(n+1,1)-dx_LE, Mesh.Ny(n));
% 			Yvec1 = linspace(coord.LE(n,2),       coord.LE(n+1,2)-dy_LE, Mesh.Ny(n));
% 			Zvec1 = linspace(coord.LE(n,3),       coord.LE(n+1,3)-dz_LE, Mesh.Ny(n));
% 			
% 			Xvec2 = linspace(coord.LE(n,1)+dx_LE, coord.LE(n+1,1),       Mesh.Ny(n));
% 			Yvec2 = linspace(coord.LE(n,2)+dy_LE, coord.LE(n+1,2),       Mesh.Ny(n));
% 			Zvec2 = linspace(coord.LE(n,3)+dz_LE, coord.LE(n+1,3),       Mesh.Ny(n));
% 			
% 			Xvec3 = linspace(coord.TE(n,1)+dx_TE, coord.TE(n+1,1),       Mesh.Ny(n));
% 			Yvec3 = linspace(coord.TE(n,2)+dy_TE, coord.TE(n+1,2),       Mesh.Ny(n));
% 			Zvec3 = linspace(coord.TE(n,3)+dz_TE, coord.TE(n+1,3),       Mesh.Ny(n));
% 			
% 			Xvec4 = linspace(coord.TE(n,1),       coord.TE(n+1,1)-dx_TE, Mesh.Ny(n));
% 			Yvec4 = linspace(coord.TE(n,2),       coord.TE(n+1,2)-dy_TE, Mesh.Ny(n));
% 			Zvec4 = linspace(coord.TE(n,3),       coord.TE(n+1,3)-dz_TE, Mesh.Ny(n));
% 
% 			panf = panf + Mesh.Ny(n);
% 			
% 			aero.Mesh.Verts.v1(pani:panf,1) = Xvec1;
% 			aero.Mesh.Verts.v1(pani:panf,2) = Yvec1;
% 			aero.Mesh.Verts.v1(pani:panf,3) = Zvec1;
% 
% 			aero.Mesh.Verts.v4(pani:panf,1) = Xvec4;
% 			aero.Mesh.Verts.v4(pani:panf,2) = Yvec4;
% 			aero.Mesh.Verts.v4(pani:panf,3) = Zvec4;
% 
% 			aero.Mesh.Verts.v2(pani:panf,1) = Xvec2;
% 			aero.Mesh.Verts.v2(pani:panf,2) = Yvec2;
% 			aero.Mesh.Verts.v2(pani:panf,3) = Zvec2;
% 
% 			aero.Mesh.Verts.v3(pani:panf,1) = Xvec3;
% 			aero.Mesh.Verts.v3(pani:panf,2) = Yvec3;
% 			aero.Mesh.Verts.v3(pani:panf,3) = Zvec3;
% 			
% 			pani = pani + Mesh.Ny(n);
			
				
			v_LE = coord.LE(n+1,:) - coord.LE(n,:);
			v_TE = coord.TE(n+1,:) - coord.TE(n,:);
			
			theta(:,1) = linspace(0,1,Mesh.Ny(n));
			
			yb_LE = theta*v_LE;
			yb_TE = theta*v_TE;
			
		% COSSENOIDAL		
		case 2

			v_LE = coord.LE(n+1,:) - coord.LE(n,:);
			v_TE = coord.TE(n+1,:) - coord.TE(n,:);
			
			theta(:,1) = linspace(pi/2,0,Mesh.Ny(n));
			
			yb_LE = cos(theta)*v_LE;
			yb_TE = cos(theta)*v_TE;

		case 3

		case 4
	end
	
		dyb1_LE = [[0 0 0]; diff(yb_LE)];
		dyb2_LE = [diff(yb_LE); [0 0 0]];

		dyb1_TE = [[0 0 0]; diff(yb_TE)];
		dyb2_TE = [diff(yb_TE); [0 0 0]];

		panf = panf + Mesh.Ny(n);

		aero.Mesh.Verts.v2(pani:panf,:) = coord.LE(n,:) + yb_LE-dyb1_LE/2;
		aero.Mesh.Verts.v1(pani:panf,:) = coord.LE(n,:) + yb_LE+dyb2_LE/2;

		aero.Mesh.Verts.v3(pani:panf,:) = coord.TE(n,:) + yb_TE-dyb1_TE/2;
		aero.Mesh.Verts.v4(pani:panf,:) = coord.TE(n,:) + yb_TE+dyb2_TE/2;

		pani = pani + Mesh.Ny(n);
		
		
		
end

pantot = sum(Mesh.Ny(:));

% for i=1:pantot
% 	figure(100); hold on
% 	axis([-.5 2 0 2])
% 	plot3(aero.Mesh.Verts.v1(i,1), aero.Mesh.Verts.v1(i,2), aero.Mesh.Verts.v1(i,3),'^')
% 	plot3(aero.Mesh.Verts.v2(i,1), aero.Mesh.Verts.v2(i,2), aero.Mesh.Verts.v2(i,3),'v')
% 	plot3(aero.Mesh.Verts.v3(i,1), aero.Mesh.Verts.v3(i,2), aero.Mesh.Verts.v3(i,3),'v')
% 	plot3(aero.Mesh.Verts.v4(i,1), aero.Mesh.Verts.v4(i,2), aero.Mesh.Verts.v4(i,3),'^')	
% 	pause(1)
% end
			
% =========================================================================
% NORMALS AND CHORDS
% =========================================================================

for i=1:pantot
	normal =  cross( (aero.Mesh.Verts.v4(i,:) - aero.Mesh.Verts.v2(i,:)), ...
					 (aero.Mesh.Verts.v3(i,:) - aero.Mesh.Verts.v1(i,:)) );
	normal_s = norm(normal);
	aero.Mesh.n(i,:) = normal/normal_s;
	
	aero.Mesh.Chord(i,1) = ( (aero.Mesh.Verts.v4(i,1)-aero.Mesh.Verts.v1(i,1)) + ...
				             (aero.Mesh.Verts.v3(i,1)-aero.Mesh.Verts.v2(i,1)) )/2;
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


						
	aero.Mesh.PCYb(i,1)   = sqrt(aero.Mesh.PC25(i,2)^2 + aero.Mesh.PC25(i,3)^2);
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

	aero.Mesh.Chord = cat(1,flipud(aero.Mesh.Chord), aero.Mesh.Chord);

	aero.Mesh.PC25(1:2*pantot,1) = cat(1,  flipud(aero.Mesh.PC25(1:pantot,1)),  aero.Mesh.PC25(1:pantot,1));
	aero.Mesh.PC25(1:2*pantot,2) = cat(1, -flipud(aero.Mesh.PC25(1:pantot,2)),  aero.Mesh.PC25(1:pantot,2));
	aero.Mesh.PC25(1:2*pantot,3) = cat(1,  flipud(aero.Mesh.PC25(1:pantot,3)),  aero.Mesh.PC25(1:pantot,3));

	aero.Mesh.PC34(1:2*pantot,1) = cat(1,  flipud(aero.Mesh.PC34(1:pantot,1)),  aero.Mesh.PC34(1:pantot,1));
	aero.Mesh.PC34(1:2*pantot,2) = cat(1, -flipud(aero.Mesh.PC34(1:pantot,2)),  aero.Mesh.PC34(1:pantot,2));
	aero.Mesh.PC34(1:2*pantot,3) = cat(1,  flipud(aero.Mesh.PC34(1:pantot,3)),  aero.Mesh.PC34(1:pantot,3));

	aero.Mesh.n(1:2*pantot,1)    = cat(1,  flipud(aero.Mesh.n(1:pantot,1)),     aero.Mesh.n(1:pantot,1));
	aero.Mesh.n(1:2*pantot,2)    = cat(1, -flipud(aero.Mesh.n(1:pantot,2)),     aero.Mesh.n(1:pantot,2));
	aero.Mesh.n(1:2*pantot,3)    = cat(1,  flipud(aero.Mesh.n(1:pantot,3)),     aero.Mesh.n(1:pantot,3));

	% INVERTE EIXO Y DOS VERTICES
	aero.Mesh.Verts.v2(1:end/2,2) = -aero.Mesh.Verts.v2(1:end/2,2);
	aero.Mesh.Verts.v1(1:end/2,2) = -aero.Mesh.Verts.v1(1:end/2,2);
	aero.Mesh.Verts.v3(1:end/2,2) = -aero.Mesh.Verts.v3(1:end/2,2);
	aero.Mesh.Verts.v4(1:end/2,2) = -aero.Mesh.Verts.v4(1:end/2,2);
	
	
	aero.Mesh.PCYb(1:2*pantot) = cat(1, -flipud(aero.Mesh.PCYb(1:pantot)),  aero.Mesh.PCYb(1:pantot));
end


aero.Mesh.Ny_tot = IsSym*pantot;


LS.Aero = aero;


% =========================================================================
% PLOT
% =========================================================================
return
figure(100);
hold on
for i=1:pantot*IsSym
		fill3([aero.Mesh.Verts.v1(i,1)  aero.Mesh.Verts.v2(i,1)  aero.Mesh.Verts.v3(i,1)  aero.Mesh.Verts.v4(i,1)],...
			  [aero.Mesh.Verts.v1(i,2)  aero.Mesh.Verts.v2(i,2)  aero.Mesh.Verts.v3(i,2)  aero.Mesh.Verts.v4(i,2)],...
			  [aero.Mesh.Verts.v1(i,3)  aero.Mesh.Verts.v2(i,3)  aero.Mesh.Verts.v3(i,3)  aero.Mesh.Verts.v4(i,3)],'w');
		
		plot3(aero.Mesh.PC25(:,1),aero.Mesh.PC25(:,2),aero.Mesh.PC25(:,3)+.01,'or')
		plot3(aero.Mesh.PC34(:,1),aero.Mesh.PC34(:,2),aero.Mesh.PC34(:,3)+.01,'ob')

		
		quiver3(aero.Mesh.PC34(i,1), aero.Mesh.PC34(i,2), aero.Mesh.PC34(i,3), ...
				aero.Mesh.n(i,1),    aero.Mesh.n(i,2),    aero.Mesh.n(i,3),1,'Color','k')
end
axis equal
axis image
grid minor
grid on
