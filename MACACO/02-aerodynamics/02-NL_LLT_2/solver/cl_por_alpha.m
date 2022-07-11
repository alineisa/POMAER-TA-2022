function cl = cl_por_alpha(alpha)
	% alpha em [rad]
	
% 	cl0 = 0;
% 	cla = 2*pi;
% 	cl	= cl0 + cla*alpha;
	alpha=alpha*180/pi;
	a  = [-4 -2   0     2     4     6    8    10    12    14   16  ];
	cln = [0  0.18 0.36  0.55  0.73  0.9  1.1  1.21  1.34  1.41 1.34];
	
	if alpha>16
		cl = 1.39+(1.39-1.41)/(16-14)*(alpha-16);
	elseif alpha<-4
		cl = 0+(0.18-0)/(-2-(-4))*(alpha-(-4));
	else
		cl = interp1(a,cln,alpha);
	end
	
	
% alpha_vet=linspace(-10,40,41)
% for i=1:41
% alpha=alpha_vet(i)
%     if alpha>16
% 		cln(i) = 1.34+(1.34-1.41)/(16-14)*(alpha-16);
% 	elseif alpha<-4
% 		cln(i) = 0+(0.18-0)/(-2-(-4))*(alpha-(-4));
% 	else
% 		cln(i) = interp1(a,cl,alpha);
% 	end
% end

end