cl = zeros(1,n);

if cl_polar || cl_curvas2global
	% -------------------------------------------------------
	% Obtém o cl por meio da polar fornecida manualmente
% 	if size(cl_polar_file)==1
		for nn=3:length(y)-2
			if alpha_eff(nn)*180/pi>min(aerodados(1).alpha) && alpha_eff(nn)*180/pi<max(aerodados(1).alpha)
				cl(nn) = interp1(aerodados(1).alpha,aerodados(1).cl,alpha_eff(nn)*180/pi);
			elseif alpha_eff(nn)*180/pi<=min(aerodados(1).alpha)
				cl(nn) = aerodados(1).cl(1);
				warning_cl_out = true;
			elseif alpha_eff(nn)*180/pi>=max(aerodados(1).alpha)
				cl(nn) = aerodados(1).cl(end);
				warning_cl_out = true;
			end
		end
% 	else
% 		interpolate_aerodynamic_twist
		
% 	end
	
	
elseif cl_eq
	% -------------------------------------------------------
	% Obtém o cl por meio de uma equação descrita manualmente
	
	for nn=3:length(y)-2
		cl(nn) = eval([cl_eq_func,'(alpha_eff(nn))']);
	end
end



% Superfícies de controle
% if isempty(n_ini)==0
% 	
% 	if deflex_linear
% 		for ii=1:length(n_ini)
% 			cl(n_ini(ii):n_fim(ii)) = cl(n_ini(ii):n_fim(ii)) + dcl_da(ii)*da(ii);
% 		end
% 	end
% 	
% 	if deflex_polar
% 		for ii=1:length(n_ini)
% 			for nn=n_ini(ii):n_fim(ii)
% 				if alpha_eff(nn)*180/pi>min(aerodados(ii+1).alpha) && alpha_eff(nn)*180/pi<max(aerodados(ii+1).alpha)
% 					cl(nn) = interp1(aerodados(ii+1).alpha,aerodados(ii+1).cl,alpha_eff(nn)*180/pi);
% 				elseif alpha_eff(nn)*180/pi<=min(aerodados(ii+1).alpha)
% 					cl(nn) = aerodados(ii+1).cl(1);
% 					warning_cl_out = true;
% 				elseif alpha_eff(nn)*180/pi>=max(aerodados(ii+1).alpha)
% 					cl(nn) = aerodados(ii+1).cl(end);
% 					warning_cl_out = true;
% 				end
% 			end
% 		end
% 	end
% 	
% end





