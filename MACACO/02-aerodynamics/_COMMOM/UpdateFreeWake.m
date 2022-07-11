function [ ] = UpdateFreeWake( plane,fltcond )
Voo = fltcond.Voo;
p = fltcond.p;
q = fltcond.q;
r = fltcond.r;
alpha = fltcond.alpha;
beta = fltcond.beta;

dt = plane.Aero.Settings.FreeWake_dt;
dt = 0.01;


W = plane.Aero.GlobalWake.Vortices;
nVertex = size(W,2);
nMesh = size(W,1);

% pn n-ésimo painel
% vn n-ésimo vertice do vortice
for pn=1:nMesh
	for vn=1:nVertex
		if all(vn~=(nVertex/2-1:nVertex/2+2))
			P = [W(pn,vn,1) W(pn,vn,2) W(pn,vn,3)];

			Vind = WakeInduced( plane, P, 1 );
			Vind_tot = Vind + Voo*[0*cosd(alpha).*cosd(beta), -cosd(alpha).*sind(beta), sind(alpha)] + cross(P,[p q r]);

			W(pn,vn,1) = P(1)+Vind_tot(1)*dt;
			W(pn,vn,2) = P(2)+Vind_tot(2)*dt;
			W(pn,vn,3) = P(3)+Vind_tot(3)*dt;
		end

	end
end



plane.Aero.GlobalWake.Vortices = W;

figure(100); clf
plane.PlotMesh
for i=1:nMesh
	for j=1:nVertex-1
		line([W(i,j,1) W(i,j+1,1)],[W(i,j,2) W(i,j+1,2)],[W(i,j,3) W(i,j+1,3)],'Marker','^')
	end
end
pause(0.1)
