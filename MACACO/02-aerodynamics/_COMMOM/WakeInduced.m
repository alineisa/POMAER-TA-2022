function [ V ] = WakeInduced( plane, P, pol_n )

	W = plane.Aero.GlobalWake.Vortices;
	G = plane.Aero.GlobalLoad(pol_n).G;
	
	nW = size(W);
	
	V = zeros(1,3);
	for i=1:nW(1)
		V = V + VORTEX_INDUCED(P,W(i,:,:),G(i),1);
	end
	
	
end

