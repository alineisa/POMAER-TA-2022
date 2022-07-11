	
	for nn=3:length(y)-2
		if alpha_eff(nn)*180/pi>min(aerodados(1).alpha) && alpha_eff(nn)*180/pi<max(aerodados(1).alpha)
			cl1 = interp1(aerodados(1).alpha,aerodados(1).cl,alpha_eff(nn)*180/pi);
			cl2 = interp1(aerodados(2).alpha,aerodados(2).cl,alpha_eff(nn)*180/pi);
			cl(nn)	= interp1([0, b/2],[cl1, cl2],abs(y(nn)));
		elseif alpha_eff(nn)*180/pi<=min(aerodados(1).alpha)
			cl1 = aerodados(1).cl(1);
			cl2 = aerodados(2).cl(1);
			cl(nn)	= interp1([0, b/2],[cl1, cl2],abs(y(nn)));
			warning_cl_out = true;
		elseif alpha_eff(nn)*180/pi>=max(aerodados(1).alpha)
			cl1 = aerodados(1).cl(end);
			cl2 = aerodados(2).cl(end);
			cl(nn)	= interp1([0, b/2],[cl1, cl2],abs(y(nn)));
			warning_cl_out = true;
		end
	end
