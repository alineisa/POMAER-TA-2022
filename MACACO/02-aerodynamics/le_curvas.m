function [cl_lin,cl0_lin,cl0_nl,cla,alpha0_lin,clmax,alpha_clmax,cdmin,cm]=le_curvas(perfil,Re,alpha)
	
	global aerodados2D
	analise = 'linear';
	regiao_linear = [0,8];
	
	
	for ind_perf = 1:length(aerodados2D)
		if strcmp(aerodados2D(ind_perf).perf,perfil)
			break
		end
	end
	
	for ind_Re = 1:length(aerodados2D(ind_perf).Re)
		if aerodados2D(ind_perf).Re(ind_Re).Re >= Re
			break
		end
	end
	if ind_Re~=1
		ind_Re = ind_Re-1;
	end
	
	
	cla			= aerodados2D(ind_perf).Re(ind_Re).Clalpha;
	cl0_lin		= aerodados2D(ind_perf).Re(ind_Re).Cl0_lin;
	cl_lin		= cl0_lin + cla*alpha;
	
	alpha0_lin	= aerodados2D(ind_perf).Re(ind_Re).alpha0_lin;
	cdmin		= aerodados2D(ind_perf).Re(ind_Re).Cdmin;
	cm			= aerodados2D(ind_perf).Re(ind_Re).Cm_medio_lin;
	
	
	alpha_clmax = aerodados2D(ind_perf).Re(ind_Re).alpha_Clmax;
	clmax		= aerodados2D(ind_perf).Re(ind_Re).Clmax;
	
	cl0_nl		= aerodados2D(ind_perf).Re(ind_Re).Cl0_nl;
	
	
	for ind_alpha = 1:length(aerodados2D(ind_perf).Re(ind_Re).alpha)
		if alpha == aerodados2D(ind_perf).Re(ind_Re).alpha(ind_alpha)
			igual = 1;
			break
		elseif alpha < aerodados2D(ind_perf).Re(ind_Re).alpha(ind_alpha)
			igual = 0;
			break
		end
	end
	
	if igual == 1
		cl_nl = aerodados2D(ind_perf).Re(ind_Re).Cl(ind_alpha);
	elseif igual == 0
		
		ind_alpha_ant	= ind_alpha-1;
		ind_alpha_seg	= ind_alpha;
		
		alpha_ant		= aerodados2D(ind_perf).Re(ind_Re).alpha(ind_alpha_ant);
		alpha_seg		= aerodados2D(ind_perf).Re(ind_Re).alpha(ind_alpha_seg);
		Cl_ant			= aerodados2D(ind_perf).Re(ind_Re).Cl(ind_alpha_ant);
		Cl_seg			= aerodados2D(ind_perf).Re(ind_Re).Cl(ind_alpha_seg);
		
	end
	
	
	
	
end















%% ================== Plot ================================================
% ---------------------------------------Plots para a le_curvas de Precisão
% close all
% if exist(arquivo,'file')==2
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',[-12:0.5:12],clxalpha_lin(-12:0.5:12)); legend('Curva C_l x \alpha','Ajuste linear'); title(['Cl vs \alpha Re: ',num2str(Re),' - ',perfil]);grid minor
% else
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',coefxalpha1(:,1),coefxalpha1(:,2),coefxalpha2(:,1),coefxalpha2(:,2), [-12:0.5:12],clxalpha_lin(-12:0.5:12)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,2)) max(coefxalpha(:,2))]);
% 	textsup=['C_l x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_l x \alpha inferior: ',num2str(Re2)];
% 	legend('C_l x \alpha interpolada',textsup, textinf, 'Ajuste linear','Location','SouthEast'); grid minor;title(['Re: ',num2str(Re)])

% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,3),'*-',coefxalpha1(:,1),coefxalpha1(:,3),coefxalpha2(:,1),coefxalpha2(:,3)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,3)) max(coefxalpha(:,3))]);
% 	textsup=['C_d x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_d x \alpha inferior: ',num2str(Re2)];
% 	legend('C_d x \alpha interpolada',textsup, textinf,'Location','Northwest'); grid minor;title(['Cd vs \alpha Re: ',num2str(Re)])
%
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,4),'*-',coefxalpha1(:,1),coefxalpha1(:,4),coefxalpha2(:,1),coefxalpha2(:,4)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,4)) max(coefxalpha(:,4))]);
% 	textsup=['C_m x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_m x \alpha inferior: ',num2str(Re2)];
% 	legend('C_m x \alpha interpolada',textsup, textinf,'Location','Northwest'); grid minor;title(['Cm vs \alpha Re: ',num2str(Re)])

% ---------------------------------------  Plots para a le_curvas Acelerada
% close all
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',[-12:0.5:12],clxalpha_lin(-12:0.5:12)); legend('Curva C_l x \alpha','Ajuste linear'); title(['Cl vs \alpha Re: ',num2str(Re),' - ',perfil]);grid minor

% toc
