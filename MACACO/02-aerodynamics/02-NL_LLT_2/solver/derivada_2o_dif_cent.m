function d = derivada_2o_dif_cent(x, dt)
	
	% Derivada de segunda ordem por diferen�as centradas
	% Utilizada para evitar a perda de um elemento do vetor no m�todo diff()./diff(),
	% Al�m de aproximar da derivada anal�tica
	
	% autor: Andr� Rezende Dessimoni
	
	
	d(1) = (x(2) - x(1)) / dt;
	d(length(x)) = ( x(end) - x(end-1) ) / dt;
	
	ndx = 2:(length(x)-1);
	d(ndx) = (x( ndx+1) - x(ndx-1)) / (2 * dt);
	
end