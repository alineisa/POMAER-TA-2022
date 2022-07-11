function [alpha_i] = calc_alpha_i(n,dgama_dy,Voo,b,y)
	
	% Função responsável pelo cálculo da integral do ângulo de atque induzido (Eq. 5.75, Anderson - Fundamentals of Aerodynamics 5ed)
	% autor: André Rezende Dessimoni
	
	
	k=n+1;
	alpha_i=ones(k,1)*0;
	
	% Termos do somatório da equação da solução pela regra de Simpson (Eq 5.76)
	for nn=1:1:n
		
		yn = y(nn);
		
		for j=2:2:k 
			t1(nn,j) = dgama_dy(j-1)/(yn-y(j-1));
			t2(nn,j) = dgama_dy(j)  /(yn-y(j));
			t3(nn,j) = dgama_dy(j+1)/(yn-y(j+1));
		end
		
	end
	
	
	% Verifica onde ocorream as singularidades e as substitui pela média dos valores das seçoes adjacentes
	for nn=1:n

		for j=2:2:k
			
			% Singularidades do primeiro termo
			if nn==1 && (abs(t1(nn,j))==Inf || isnan(t1(nn,j)))
				t1(nn,j) = t1(nn+1,j)/2;
			end
			if nn>2 && nn<n && (abs(t1(nn,j))==Inf || isnan(t1(nn,j)))
				t1(nn,j) = (t1(nn+1,j)+t1(nn-1,j))/2;
			end
			if nn==n && (abs(t1(nn,j))==Inf || isnan(t1(nn,j)))
				t1(nn,j) = t1(nn-1,j)/2;
			end
			
			
			% Singularidades do segundo termo
			if nn==2 && (abs(t2(nn,j))==Inf || isnan(t2(nn,j)))
				t2(nn,j) = t2(nn+1,j)/2;
			end
			if nn>2 && nn<n && abs(t2(nn,j))==Inf || isnan(t2(nn,j))
				t2(nn,j) = (t2(nn+1,j)+t2(nn-1,j))/2;
			end
			if nn==n && abs(t2(nn,j))==Inf || isnan(t2(nn,j))
				t2(nn,j) = t2(nn-1,j)/2;
			end
			
			
			% Singularidades do terceiro termo
			if nn==1 && (abs(t3(nn,j))==Inf || isnan(t3(nn,j)))
				t3(nn,j) = t3(nn+1,j)/2;
			end
			if nn>2 && nn<n && abs(t3(nn,j))==Inf || isnan(t3(nn,j))
				t3(nn,j) = (t3(nn+1,j)+t3(nn-1,j))/2;
			end
			if nn==n && abs(t3(nn,j))==Inf || isnan(t3(nn,j))
				t3(nn,j) = t3(nn-1,j)/2;
			end
			
		end
	end
	
	
	
	% Realiza o somatório
	aux=(1/(4*pi*Voo)) * ((b/(n+1))/3);
	for nn=1:n
		somatorio = 0;
		for j=2:2:k
			somatorio = somatorio + t1(nn,j) + 4*t2(nn,j) + t3(nn,j);
		end
		alpha_i(nn) = aux * somatorio;
	end
	
	alpha_i(end) = alpha_i(1);

end