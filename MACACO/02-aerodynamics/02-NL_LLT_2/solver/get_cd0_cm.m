% -------------------------------------------------------
% Obtém o cd0 e o cm em cada estação por meio da polar fornecida manualmente

for nn=1:length(y)
	if alpha_eff(nn)*180/pi>min(aerodados(1).alpha) && alpha_eff(nn)*180/pi<max(aerodados(1).alpha)
		cd0(nn) = interp1(aerodados(1).alpha,aerodados(1).cd,alpha_eff(nn)*180/pi);
		cmc4(nn) = interp1(aerodados(1).alpha,aerodados(1).cm,alpha_eff(nn)*180/pi);
	elseif alpha_eff(nn)*180/pi<=min(aerodados(1).alpha)
		cd0(nn) = aerodados(1).cd(1);
		cmc4(nn) = aerodados(1).cm(1);
		warning_cl_out = true;
	elseif alpha_eff(nn)*180/pi>=max(aerodados(1).alpha)
		cd0(nn) = aerodados(1).cl(end);
		cmc4(nn) = aerodados(1).cm(end);
		warning_cl_out = true;
	end
end

% if isempty(n_ini)==0
% 	for ii=1:length(n_ini)
% 		cd0(n_ini(ii):n_fim(ii))  = cd0(n_ini(ii):n_fim(ii))  + dcd0_da(ii)*da(ii);
% 		cmc4(n_ini(ii):n_fim(ii)) = cmc4(n_ini(ii):n_fim(ii)) + dcmc4_da(ii)*da(ii);
% 	end
% end