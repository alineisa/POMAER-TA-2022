function [CL,Cl] = LLT (n,alpha,Clalpha,alpha0,c,AR,b,S,Vinf,rho,theta0)
	
	
	
	% impostazione del sistema di n-2 equazioni A*An=Anoto e risoluzione
	% I build the system A*An=Anoto of n-2 equation, and my PC solve it!
	Anoto=(alpha(2:n-1)-alpha0(2:n-1));
	
	for i=2:n-1
		for j=2:n-1
			A(i-1,j-1)=4*b*sin((j-1)*theta0(i))/(Clalpha(i)*c(i))+(j-1)*sin((j-1)*theta0(i))/sin(theta0(i));
		end
	end
	An=A\Anoto;
	
	% calcolo di Gamma (vorticità lungo l' ala
	% calculation of the vorticity Gamma on the wing
	for i=2:n-1
		Gamma(i)=2*b*Vinf*sum(An(:).*sin((1:n-2)*theta0(i))');
	end
	Gamma(n)=0;
	Gamma(1)=0;
	
	% calcolo altre caratteristiche aerodinamiche dell' ala
	% calculation of the aerodinamical characteristics of the wing
	Cl=2*Gamma./(c'*Vinf);
	l=rho*Vinf*Gamma;	% N/m
	
	CL=An(1)*pi*AR;
	for i=2:n-1
		alphai(i)=sum((1:n-2)'.*An.*sin((1:n-2)'*theta0(i))./sin(theta0(i)));
	end
	alphai(1)=sum((1:n-2)'.*An);
	alphai(n)=sum((1:n-2)'.*An);
	d=l.*alphai;
	Cdi=d./(.5*rho*Vinf^2*c');
	
	CDi=pi*AR*sum((1:n-2)'.*(An.^2));
	L=CL*.5*rho*Vinf^2*S;
	Di=CDi*.5*rho*Vinf^2*S;
	
	Cl = Cl';

	
	% plot(y0,Gamma); ylabel('c*Cl');
% plot(y0,c'.*Cdi,'x'); ylabel('c*C_d indotto');
% plot(y0,alphai*180/pi)
