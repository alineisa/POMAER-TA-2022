function [ CDi, CDi2] = TreftzPlane(plane,fltcond, pol_n, x,y,z, ny,nz )

% x 
% y: [ymin ymax]
% z: [zmin zmax]

Y = linspace(y(1),y(2),ny);
Z = linspace(z(1),z(2),nz);


V = zeros(3,ny,nz);
VV = zeros(ny,nz);
i=1;
for j=1:ny
	for k=1:nz
		P = [x, Y(j), Z(k)];
		V(:,j,k) = WakeInduced(plane, P, pol_n);
		VV(j,k) = V(2,j,k);
		i=i+1;
	end
end

V_norm = zeros(ny,nz);
rho = fltcond.rho;
Voo = fltcond.Voo;
S = plane.Geo.Area.Sref;

for j=1:ny
	for k=1:nz
		V_norm(j,k) = V(2,j,k)^2+V(3,j,k)^2;
	end
end
Dind = .5*rho*trapz(Y,trapz(Z,V_norm));
CDi = 2*Dind/(rho*Voo^2*S);



W = plane.Aero.GlobalWake.Vortices;
G = plane.Aero.GlobalLoad(pol_n).G;
nW = size(W);

wind = zeros(nW(1),1);
dy = zeros(nW(1),1);
for j=1:nW(1)
	for i=1:nW(1)
		xi = (W(i,1,2)+W(i,6,2))/2;
		xj =  W(i,1,2);
		zi = (W(i,1,3)+W(i,6,3))/2;
		zj =  W(i,1,3);
		wind(j) = wind(j)+  (xj-xi)/((zj-zi)^2+(xj-xi)^2);
	end
	wind(j) = -1/(2*pi) * wind(j);
	dy(j) = W(j,1,2)-W(j,6,2);
end


Dind2 = -.5*rho*trapz(G.*wind,dy);
CDi2  = 2*Dind2/(rho*Voo^2*S);
 

keyboard

close all
plane.PlotMesh('-nimage',1)
f = hgtransform;
surf(Y,Z,zeros(ny,nz),V_norm,'Parent',f,'EdgeColor','none');
ry = makehgtform('yrotate',-90*pi/180);
tx = makehgtform('translate',[0 0 -x]);
f.Matrix = ry*tx;
axis image
colormap('jet')
colorbar
plane.PlotWake('-nimage',1)

keyboard
end

