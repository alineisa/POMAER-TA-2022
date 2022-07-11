function [] = curvas2global(analise,regiao_linear,perfis_path)
	global aerodados2D
	cd(perfis_path)
		Arquivos = ls;
		j=1;
		for ii=1:length(Arquivos(:,1))
			Arquivo = Arquivos(ii,:);
			if strcmp(Arquivo(1:7),'curvas_')
				curvas{j,1} = Arquivo;
				Perfil = curvas{j,1};
				perfis{j,1} = Perfil(8:end);
				j=j+1;
			end
		end
	
	
	
	
	for ii=1:length(curvas)
		
		pasta_curv = curvas{ii}
		cd(pasta_curv)
		
		Lista_Re = load('lista_Re.dat');
		
		
		
		for j=1:length(Lista_Re)
			dados = load([strtrim(perfis{ii}),'_Re',sprintf('%07d',Lista_Re(j)),'.dat']);
			
			aerodados2D(ii).perf		= strtrim(perfis{ii});
			aerodados2D(ii).Re(j).Re	= Lista_Re(j);
			aerodados2D(ii).Re(j).alpha = dados(:,1);
			aerodados2D(ii).Re(j).Cl	= dados(:,2);
			aerodados2D(ii).Re(j).Cd	= dados(:,3);
			aerodados2D(ii).Re(j).Cm	= dados(:,4);
			
			aerodados2D(ii).Re(j).Clmax = max(aerodados2D(ii).Re(j).Cl);
			ind_alpha_clmax = find(aerodados2D(ii).Re(j).Cl == aerodados2D(ii).Re(j).Clmax, 1, 'first');
			aerodados2D(ii).Re(j).alpha_Clmax = aerodados2D(ii).Re(j).alpha(ind_alpha_clmax);
			
			aerodados2D(ii).Re(j).Cdmin = min(aerodados2D(ii).Re(j).Cd);
			ind_alpha_cdmin = find(aerodados2D(ii).Re(j).Cd == aerodados2D(ii).Re(j).Cdmin, 1, 'first');
			aerodados2D(ii).Re(j).alpha_Cdmin = aerodados2D(ii).Re(j).alpha(ind_alpha_cdmin);
			
			
			if strcmp(analise,'linear')
				
				alpha_min = regiao_linear(1);										% Menor alpha considerado para fazer o ajuste da região linear
				alpha_max = regiao_linear(2);										% Maior alpha considerado para fazer o ajuste da região linear
				
				min_a = find(aerodados2D(ii).Re(j).alpha<=alpha_min,1,'last');		% Define em qual indice está o alpha mais próximo do mínimo
				max_a = find(aerodados2D(ii).Re(j).alpha>=alpha_max,1,'first');		% e em qual está o alpha mais próximo do máximo
				
				[coef_cl]=polyfit(aerodados2D(ii).Re(j).alpha(min_a:max_a),aerodados2D(ii).Re(j).Cl(min_a:max_a),1); % Faz o ajuste linear do cl
				aerodados2D(ii).Re(j).Clalpha=coef_cl(1);							% Cl alpha do perfil [graus]
				aerodados2D(ii).Re(j).Cl0_lin=coef_cl(2);							% Cl para alpha=0 do perfil
				
				clxalpha_lin=@(alpha) coef_cl(2) + alpha*coef_cl(1);				% Equação da região linear
				aerodados2D(ii).Re(j).alpha0_lin = fzero(clxalpha_lin,0);			% Alpha para o qual o cl é zero segundo o ajuste linear
				
				aerodados2D(ii).Re(j).Cm_medio_lin = mean(aerodados2D(ii).Re(j).Cm(min_a:max_a));
				
			end
			
			ind_Cl0_nl = find(aerodados2D(ii).Re(j).alpha>=0,1,'first');
			aerodados2D(ii).Re(j).Cl0_nl = find(ind_Cl0_nl);
			
			
        end
        cd ..		
		aerodados2D(ii).tc			= tc_perfil(aerodados2D(ii).perf);
		
		aerodados2D(ii).coord		= load([aerodados2D(ii).perf,'.dat']);
	end
cd ..

	
end

