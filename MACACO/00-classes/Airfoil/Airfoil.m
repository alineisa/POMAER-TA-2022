classdef Airfoil < handle
%--------------------------------------------%
%     _    _ _____ ____ _____ ____ _____     %
%    | \  / |  _  |  __|  _  |  __|  _  |    %
%    |  \/  | [_] | (__| [_] | (__| (_) |    %
%    |_|  |_|_/ \_|____|_/ \_|____|_____|    %
% Multi-Analysis  Code for Airplane COncepts %
%                                            %
%--------------------------------------------%
%				AIRFOIL CLASS				 %
%--------------------------------------------%
%
% This class ...
%
%
% PROPERTIES
% -------------
% ID:				ID unica do perfil
% dir:				Diretorio dos dados do perfil
% nome:				Nome dado ao perfil
% xy:				Coordenadas do perfil
% tc:				Espessura máxima relativa do perfil
% pol:				Polares do perfil
%	pol.Re:			Reynolds da polar
%	pol.alpha:		Angulos de ataque
%	pol.cl:			Coeficiente de sustentação 2D
%	pol.cd:			Coeficiente de arrasto 2D
%	pol.cm:			Coefiente de momento 2D
% coef:				Coeficientes lineares e nao lineares ajustados
%	coef.Re:		Reynolds
%	coef.cla:		lift slope (linear)
%	coef.cl0:		cl para alpha=0°
%	coef.a0:		alpha para cl=0
%	coef.clmax:		cl máximo
%	coef.a_clmax:	alpha para cl máximo
%	coef.a_lin_i:	alpha onde começa a região linear
%	coef.a_lin_f:	alpha onde termina a região linear
%	coef.C0_NL:		Coeficiente C0 do ajuste nao linear
%	coef.C2_NL:		Coeficiente C2 do ajuste nao linear
%	coef.C3_NL:		Coeficiente C3 do ajuste nao linear
%
%
% METHODS
% -------------
%
% Airfoil (Constructor method)
%	'-file',  'polar file'
%	'-alpha', Column with alpha values
%	'-cl', Column with cl values	   
%	'-cd' Column with cd values
%	'-cm' Column with cm values
%	'-SkipHead', Number of lines to skip in the beginning of the polar file
%	'-coord', 'file containing coordinates of the file'
%	'-linear' <cl(alpha=0)> <clalpha [rad]> 
%
%	Ex to read XFLR5 polar file:
% aerodata2D = Airfoil('-file','T1_Re1.000_M0.00_N9.0.txt','-SkipHead',11,...
%                      '-alpha',1,'-Cl',2,'-cd',3,'-cm',5,'-coord','coordinates.dat')
%	Ex to read Experimental CLxalpha
% aerodata2D = Airfoil('-file','experimental.dat','-alpha',1'-Cl',2)
%
%
%
% cl(alpha,Re)
%
% cd(alpha,Re)
%
% cm(alpha,Re)
%
% check_adjustment
%
	
	properties
		ID						% ID unica
		dir						% Diretorio que contem todos os dados do perfil
		name					% Nome do perfil
		xy						% Coordenadas do perfil
		hinge
		tc						% Espessura maxima do perfil
		pol@Airfoil_Polar		% Polares originais dos perfil
		coef					% Coeficientes ajustados a partir das polares originais
	end
	
	
	methods
		
		%% ================== FUNCAO INICIALIZADORA =======================
		% =================================================================
		function obj = Airfoil(varargin)
			
			len = length(varargin);
			if len>0
				
				file_pol	= [];
				col_alpha	= 1;
				col_cl		= 2;
				col_cd		= 3;
				col_cm		= 4;
				coord_file  = [];
				SkipHead = 1;
				
				for i=1:2:len
					switch varargin{i}
						case '-file'
							file_pol = varargin{i+1};
						case '-alpha'
							col_alpha = varargin{i+1};
						case '-cl'
							col_cl = varargin{i+1};
						case '-cd'
							col_cd = varargin{i+1};
						case '-cm'
							col_cm = varargin{i+1};
						case '-SkipHead'
							SkipHead = varargin{i+1};
						case '-coord'
							coord_file = varargin{i+1};
					end
				end
			
				if isempty(file_pol)
					error('must specifie polar file');
				end
				
				obj.dir = file_pol;
				obj.ImportPolar(file_pol, col_alpha,col_cl,col_cd,col_cm,SkipHead);
				obj.UpdateCoeff;
				
				if ~isempty(coord_file)
					[x,y,name] = load_airfoil(coord_file);
					obj.xy = [x,y];
					obj.tc = tc_perfil(coord_file);
					if isempty(obj.nome)
						obj.nome = name;
					end
				end
			end
			
		end
		
		function obj = ImportPolar(obj,file_pol,col_alpha,col_cl,col_cd,col_cm,SkipHead)
			
			try
				data = load(file_pol);
			catch err
				if ~isempty(err)
					data = importdata(file_pol,' ',SkipHead);
					data = data.data;
				end
			end
			
			obj.pol(1).alpha = data(:,col_alpha);
			obj.pol(1).cl = data(:,col_cl);

			if size(data,2)>=col_cd
				obj.pol(1).cd = data(:,col_cd);
			end
			if size(data,2)>=col_cm
				obj.pol(1).cm = data(:,col_cm);
			end
			
		end
		
		
		%% =======================  UPDATE  ===============================
		%		Funcao que importa e calcula todos os dados do perfil
		% =================================================================
		function obj = UpdateCoeff(obj)
			aux=length(obj.pol);
            auxiliar=0;
            global naorodou naorodourey contadornaorodou limites_linear
            naorodou=0;
            for vealpha=1:length(obj.pol(aux).alpha)
                if obj.pol(aux).alpha(vealpha)>=-10 && obj.pol(aux).alpha(vealpha)<=0
                    auxiliar=auxiliar+1;
                    positivo=false;
                elseif obj.pol(aux).alpha(vealpha)>0 && obj.pol(aux).alpha(vealpha)<=10
                    auxiliar=auxiliar+1;
                    positivo=true;                    
                end
            end
            if auxiliar>15 && positivo==true
                contadornaorodou=0;
            
			% Calcula coeficientes para cada valor de Reynolds
			% --------------------------------------------------
            for i=1:length(obj.pol)
				
				obj.coef(i).Re = obj.pol(i).Re;
				
				% Coeficientes lineares
				% ----------------------------------------------
				a_i   = limites_linear(1);									% alpha onde começa  a regiao linear (chute inicial) [deg]
%                 a_i   = 1;
                a_f   = limites_linear(2);									% alpha onde termina a regiao linear (chute inicial) [deg]
%                 a_f   = 4;
                lin_i = find(obj.pol(i).alpha >= a_i, 1,'first');			% indice do alpha onde comeca  a regiao linear (mais proximo de a_i)
				lin_f = find(obj.pol(i).alpha <= a_f, 1,'last');			% indice do alpha onde termina a regiao linear (mais proximo de a_f)
				eps_i = 10;													% inicializacao do erro de a_i
				eps_f = 10;													% inicializacao do erro de a_f
				tol   = 0.01;												% tolerancia erro de a_i e a_f
				it    = 0;					
				while eps_f>tol && eps_i>tol	% -> Looping para encontrar a regiao linear e seus coeficientes

					coefs_lin = polyfit(obj.pol(i).alpha(lin_i:lin_f), obj.pol(i).cl(lin_i:lin_f),1);

					cla    = coefs_lin(1)*180/pi;							
					cl0    = coefs_lin(2);									
					a0     = -cl0/(cla*pi/180);								
					
% Calculando Clmax e alpha_estol para alpha positivo por variação do sinal da derivada 
                    len  = length(obj.pol(i).alpha);
                    tan  = zeros(1,len);
                    tan2 = zeros(1,len);
                    tan4 = zeros(1,len);
                    % Calculo das tangentes
                    for ii = floor(0.6*len):len-1
                        tan(ii) = (obj.pol(i).cl(ii+1)-obj.pol(i).cl(ii))./(obj.pol(i).alpha(ii+1)-obj.pol(i).alpha(ii));
                    end
                    for ii = floor(0.6*len):len-2
                        tan2(ii) = (obj.pol(i).cl(ii+2)-obj.pol(i).cl(ii))./(obj.pol(i).alpha(ii+2)-obj.pol(i).alpha(ii));
                    end
                    for ii = floor(0.6*len):len-4
                        tan4(ii) = (obj.pol(i).cl(ii+4)-obj.pol(i).cl(ii))./(obj.pol(i).alpha(ii+4)-obj.pol(i).alpha(ii));
                    end
                    % Encontra as tangentes
                    for ii = floor(0.6*len):len-1
                        if tan(ii) < 0 && tan2(ii) <= 0 && (tan4(ii) <= 0 || tan4(ii) > 0.07)
                            clmax = obj.pol(i).cl(ii);
                            a_clmax = obj.pol(i).alpha(ii);
                            break
                        else
                            clmax = obj.pol(i).cl(ii+1);
                            a_clmax = obj.pol(i).alpha(ii+1);
                        end
                    end
                    
% Calculando Clmin e alpha_estol_min para alpha negativo por variação do sinal da derivada  
                    % Calculo das tangentes
                    for ii = floor(0.4*len):-1:1
                        tan(ii) = (obj.pol(i).cl(ii+1)-obj.pol(i).cl(ii))./(obj.pol(i).alpha(ii+1)-obj.pol(i).alpha(ii));
                    end
                    for ii = floor(0.4*len):-1:2
                        tan2(ii) = (obj.pol(i).cl(ii+1)-obj.pol(i).cl(ii-1))./(obj.pol(i).alpha(ii+1)-obj.pol(i).alpha(ii-1));
                    end
                    for ii = floor(0.4*len):-1:4
                        tan4(ii) = (obj.pol(i).cl(ii+1)-obj.pol(i).cl(ii-3))./(obj.pol(i).alpha(ii+1)-obj.pol(i).alpha(ii-3));
                    end
                    for ii = floor(0.4*len):-1:1
                        if tan(ii) < 0 && tan2(ii) <= 0 && (tan4(ii) <= 0 || tan4(ii) > 0.07)
                            clmin = obj.pol(i).cl(ii+1);
                            a_clmin = obj.pol(i).alpha(ii+1);
                            break
                        else
                            clmin = obj.pol(i).cl(ii);
                            a_clmin = obj.pol(i).alpha(ii);
                        end
                    end
					
					% -> delta entre cl da regressao e cl da polar
					cl_lin_f = cl0 + cla*obj.pol(i).alpha(lin_f)*pi/180;
					cl_lin_i = cl0 + cla*obj.pol(i).alpha(lin_i)*pi/180;
					eps_f = abs(cl_lin_f - obj.pol(i).cl(lin_f));
					eps_i = abs(cl_lin_i - obj.pol(i).cl(lin_i));
					
					% -> compressão da regiao linear
					if eps_f > tol
						lin_f = lin_f-1;
					else
					end
					if eps_i > tol
						lin_i = lin_i+1;
					end
					
					it=it+1;
				end
				
				obj.coef(i).cla			= cla;								% d_cl/d_alpha	[rad^-1]
				obj.coef(i).cl0			= cl0;								% cl para alpha==0
				obj.coef(i).a0			= a0;								% alpha para cl==0	[deg]
				obj.coef(i).clmax		= clmax;							% cl_max
				obj.coef(i).a_clmax		= a_clmax;							% alpha para cl==cl_max [deg]
				obj.coef(i).clmin		= clmin;							% cl_max
				obj.coef(i).a_clmin		= a_clmin;							% alpha para cl==cl_max [deg
				obj.coef(i).ind_a_lin_i = lin_i;							% indice da curva de clxa onde comeca  a regiao linear
				obj.coef(i).ind_a_lin_f = lin_f;							% indice da curva de clxa onde termina a regiao linear
				obj.coef(i).a_lin_i		= obj.pol(i).alpha(lin_i);			% alpha onde começa  a regiao linear [deg]
				obj.coef(i).a_lin_f		= obj.pol(i).alpha(lin_f);			% alpha onde termina a regiao linear [deg]
				
				
				% Coeficientes não lineares positivos
				% ----------------------------------------------
				
				% -> Método e nomenclatura de "UM ESTUDO SOBRE A OTIMIZACAO DE TRAJETORIA DE VOO DE PLANODORES DE COMPETICAO", Iscold P.H., Tese 2004
				M		= clmax;
				m		= a_clmax;
				P		= cl0 +cla*obj.pol(i).alpha(lin_f)*pi/180;
				p		= obj.pol(i).alpha(lin_f);

				delta	= m-p;
				a  = P/(p-a0);
				D  = a;

				% Coeficientes do polinomio cl = C3*(alpha-a_clmax)^3 + C2*(alpha-a_clmax)^2 + C0
				obj.coef(i).C0_NL_p		=  M;
				obj.coef(i).C2_NL_p		= (3*(P-M)+delta*D)/delta^2;
				obj.coef(i).C3_NL_p		= (2*(P-M)+delta*D)/delta^3;
				
				
				
				% Coeficientes não lineares negativos
				% ----------------------------------------------
				M		= clmin;
				m		= a_clmin;
				P		= cl0 +cla*obj.pol(i).alpha(lin_i)*pi/180;
				p		= obj.pol(i).alpha(lin_i);

				delta	= m-p;
				a  = P/(p-a0);
				D  = a;

				% Coeficientes do polinomio cl = C3*(alpha-a_clmax)^3 + C2*(alpha-a_clmax)^2 + C0
				obj.coef(i).C0_NL_n		=  M;
				obj.coef(i).C2_NL_n		= (3*(P-M)+delta*D)/delta^2;
				obj.coef(i).C3_NL_n		= (2*(P-M)+delta*D)/delta^3;
            end
		
          
            else
                naorodou=1;naorodourey=obj.pol(aux).Re;contadornaorodou=contadornaorodou+1;
                obj.pol(aux)=[];
            end

			
		end
		
		

		
		%% =========================== cl =================================
		%		Função que retorna o valor de cl(Re,alpha)
		% =================================================================
		function [cl] = cl(obj,alpha,Re,varargin)
			
			interp = false;
			for i=1:1:nargin-3
				if strcmp(varargin{i},'interp')
					interp = true;
				end
			end
			
			
			ind_Re = find([obj.coef.Re]>=Re,1,'first');
			if isempty(ind_Re)
				ind_Re = length([obj.coef.Re]);
% 				warning('Painel Reynolds out of range. Painel Reynolds is higher than the maximum Reynolds available in airfoil polars.')
			elseif ind_Re == 1
% 				warning('Painel Reynolds out of range. Painel Reynolds is lower than the maximum Reynolds available in airfoil polars.')
			end
			
			if interp
				if alpha>max(obj.pol(ind_Re).alpha) || alpha <min(obj.pol(ind_Re).alpha)
					cl = 0;
				else
					ind_alpha = find(obj.pol(ind_Re).alpha<=alpha,1,'last');
					alpha_1   = obj.pol(ind_Re).alpha(ind_alpha);
					alpha_2   = obj.pol(ind_Re).alpha(ind_alpha+1);
					cl_1	  = obj.pol(ind_Re).cl(ind_alpha);
					cl_2	  = obj.pol(ind_Re).cl(ind_alpha+1);

					cl = interp1([alpha_1 alpha_2], [cl_1, cl_2],alpha);
				end
				
			else
				if		alpha<obj.coef(ind_Re).a_lin_i 
						m  = obj.coef(ind_Re).a_clmin;
						C3 = obj.coef(ind_Re).C3_NL_n;
						C2 = obj.coef(ind_Re).C2_NL_n;
						C0 = obj.coef(ind_Re).C0_NL_n;
						cl = C3*(alpha-m)^3 + C2*(alpha-m)^2 + C0;
				elseif	alpha>obj.coef(ind_Re).a_lin_f
						m  = obj.coef(ind_Re).a_clmax;
						C3 = obj.coef(ind_Re).C3_NL_p;
						C2 = obj.coef(ind_Re).C2_NL_p;
						C0 = obj.coef(ind_Re).C0_NL_p;
						cl = C3*(alpha-m)^3 + C2*(alpha-m)^2 + C0;
				else
						cla = obj.coef(ind_Re).cla;
						cl0 = obj.coef(ind_Re).cl0;
						cl = cla*alpha*(pi/180) + cl0;
				end
			end
			
			
		end
		
		%% ==================== CHECK ADJUSTMENT ==========================
		%		Funcao para conferir se os ajustes estao coerentes
		% =================================================================
		function CheckAdjustment(obj)

			h = figure; 
				
			for i=1:length(obj.pol)
				
				alpha_l = obj.coef(i).a_lin_i:obj.coef(i).a_lin_f;
				alpha_nlp = obj.coef(i).a_lin_f:40;
				alpha_nln = -40:obj.coef(i).a_lin_i;
				
				cl_l = obj.coef(i).cla*pi/180.*alpha_l+obj.coef(i).cl0;
								
				C3 = obj.coef(i).C3_NL_p;
				C2 = obj.coef(i).C2_NL_p;
				C0 = obj.coef(i).C0_NL_p;
				m  = obj.coef(i).a_clmax;
				cl_nlp = C3*(alpha_nlp-m).^3 + C2*(alpha_nlp-m).^2 + C0;
				
				C3 = obj.coef(i).C3_NL_n;
				C2 = obj.coef(i).C2_NL_n;
				C0 = obj.coef(i).C0_NL_n;
				m  = obj.coef(i).a_clmin;
				cl_nln = C3*(alpha_nln-m).^3 + C2*(alpha_nln-m).^2 + C0;
				
				delta = (2*C2-6*C3*m)^2 - 12*C3*(3*C3*m^2-2*C2*m);
				roots_1 = (-2*C2+6*C3*m + sqrt(delta))/(6*C3);
				roots_2 = (-2*C2+6*C3*m - sqrt(delta))/(6*C3);
				
				br = max([roots_1,roots_2]);
				d2_cl_nl = 6*C3*(br-m)+2*C2;

				p1 = plot(obj.pol(i).alpha,obj.pol(i).cl,'-ok'); hold on
				p2 = plot(alpha_l,cl_l,'r');
				p3 = plot(alpha_nlp, cl_nlp,'b');
				p4 = plot(alpha_nln,cl_nln,'b');
				
				p4 = line([obj.coef(i).a_lin_i obj.coef(i).a_lin_i],[0 1.5],'Color','y');
				p5 = line([obj.coef(i).a_lin_f obj.coef(i).a_lin_f],[0 1.5],'Color','y');
				p6 = plot(obj.coef(i).a_clmax,obj.coef(i).clmax,'*r');
                p7 = plot(obj.coef(i).a_clmin,obj.coef(i).clmin,'*g');
				leg=legend([p1,p2,p3],{'xfoil', 'ajuste linear', 'ajuste nao linear'});
				
				
				set(leg,'Location','SouthEast')
% 				axis([-10 40 -1 1.5]);
				xlim([-5+min(obj.pol(i).alpha) max(obj.pol(i).alpha)+5])
				ylim([-.5+min(obj.pol(i).cl)    max(obj.pol(i).cl)+.5])
				grid on
				if d2_cl_nl > 0
					title(['Reynolds: ', num2str(obj.coef(i).Re), ' tendendo a infinito'])
				else
					title(['Reynolds: ', num2str(obj.coef(i).Re)])
				end
				pause
				hold off

				  
			end
			

		end
	end
	
	end



