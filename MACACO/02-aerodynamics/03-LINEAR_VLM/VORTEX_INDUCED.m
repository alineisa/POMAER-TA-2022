function [Vind] = VORTEX_INDUCED(P,Vortex,G,tipo)
%{

Função responsável por calcular a velocidade em um ponto P devido a um
Vortice de intensidade G.

Vortex(	1:k				,	1:3		)
		k-ésimo vértice		coordenadas
		do vortice			x,y,z



Exemplo de vórtice linear (tipo = 0)

-OO

k=2	o
	^
	^
	^
	^	P
	^	*
k=1	o
	
+OO


Exemplo de vórtice ferradura (tipo = 1)

k=3	o > > > o k=4
	^		v
	^		v
	^		v
	^	P	v
	^	*	v
k=2	o		o k=5
    ^		v
    ^		v
    ^		v
    ^		v
k=1	o       o k=6

+OO          +OO



Exemplo de vórtice anel (tipo = 2)

k=2	o > > > o k=3
	^		v
	^		v
	^	P	v
	^	*	v
	^		v
k=1	o < < < o k=4
        
%}

K = length(Vortex(1,:,1));
Vind_k = zeros(K,3);
switch tipo
	
	case 1
		V1 = zeros(1,3);
		V2 = zeros(1,3);
		
		% 		Vind_k = zeros(K,3);
		
		% Cálculo da velocidade induzida por cada segmento do vórtice
		for k=1:K-1
			
			V1(:) = Vortex(1,k  ,:);
			V2(:) = Vortex(1,k+1,:);
			
			
			
			if ~all(abs(cross(P-V1,P-V2))<1e-6)
				r0 = V2-V1;
				r1 = P-V1;
				r2 = P-V2;
				
				r0_s = norm(r0);
				r1_s = norm(r1);
				r2_s = norm(r2);
				
				% Diâmetro do núcleo do vórtice
				D = 1e-6;
				if any(abs([r0_s, r1_s, r2_s])<=D)
					Vind_k(k,:) = [0 0 0];
				else
					r1xr2   = cross(r1,r2);
					r1xr2_s = norm(r1xr2);
					Vind_k(k,:) = G/(4*pi) * (r1xr2)/(r1xr2_s^2) *  dot(r0, (r1/r1_s - r2/r2_s));
				end
			else
				Vind_k(k,:) = [0 0 0];
			end
			
			
		end
end
% Soma das velocidades induzidas por cada segmento
Vind = sum(Vind_k);