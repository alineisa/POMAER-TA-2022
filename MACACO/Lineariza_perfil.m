%% Codigo para lineariizar mais
clear; close all; clc;
nomes = {'e591' 'x2020' 'dae11'};

for aux_n = 1:length(nomes)
clearvars -except nomes aux_n
cd CURVAS    
    obj = ImportObj(nomes{aux_n});
cd ..

% obj.pol(1:4) = [];
% obj.coef(1:4) = [];

clmin = -0.5;
a_clmin = -22;
a_lin_i   = a_clmin+4;
lin_i = 1;

for i = 1:length(obj.pol)
    obj.pol(i).cl(1) = clmin;
    obj.pol(i).alpha(1) = a_clmin;
    
        % Coeficientes não lineares negativos
        % ----------------------------------------------
        
         cla = obj.coef(i).cla;								% d_cl/d_alpha	[rad^-1]
         cl0 = obj.coef(i).cl0;						% cl para alpha==0
         a0 = obj.coef(i).a0;								% alpha para cl==0	[deg]
%        obj.coef(i).clmax		= clmax;							% cl_max
%        obj.coef(i).a_clmax		= a_clmax;							% alpha para cl==cl_max [deg]
        obj.coef(i).clmin		= clmin;							% cl_max
        obj.coef(i).a_clmin		= a_clmin;							% alpha para cl==cl_max [deg
        obj.coef(i).ind_a_lin_i = lin_i;							% indice da curva de clxa onde comeca  a regiao linear
%        obj.coef(i).ind_a_lin_f = lin_f;							% indice da curva de clxa onde termina a regiao linear
        obj.coef(i).a_lin_i		= obj.pol(i).alpha(lin_i);			% alpha onde começa  a regiao linear [deg]
%        obj.coef(i).a_lin_f		= obj.pol(i).alpha(lin_f);			% alpha onde termina a regiao linear [deg]

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

salvar_mat = [nomes{aux_n} 'b'];
mat_name_aux = matlab.lang.makeValidName(salvar_mat);
eval([mat_name_aux  ' = obj;'])
save(['CURVAS/' matlab.lang.makeValidName(salvar_mat)],mat_name_aux);

end