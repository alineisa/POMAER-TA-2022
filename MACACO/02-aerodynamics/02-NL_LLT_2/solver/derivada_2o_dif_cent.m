function d = derivada_2o_dif_cent(x, dt)
	
	% Derivada de segunda ordem por diferenças centradas
	% Utilizada para evitar a perda de um elemento do vetor no método diff()./diff(),
	% Além de aproximar da derivada analítica
	
	% autor: André Rezende Dessimoni
	
	
	d(1) = (x(2) - x(1)) / dt;
	d(length(x)) = ( x(end) - x(end-1) ) / dt;
	
	ndx = 2:(length(x)-1);
	d(ndx) = (x( ndx+1) - x(ndx-1)) / (2 * dt);
	
end