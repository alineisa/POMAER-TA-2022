% INPUT SECTION
% ---------------------------------------------------------------------
clear; clc; close all
u = symunit;
alphas = linspace(0,17,18);
for alpha_n=1:18
	
	n		= 20;
	Vinf	= 90;
	rho		= 1;
	
	b		= 2*2.286;
	cr		= 0.725678;
	ct		= 0.290322;
	
	S		= .5*b*(cr+ct);
	AR		= b^2/S;
	lambda	= ct/cr;
	
	theta0	= linspace(0,pi,n); 
	y0=-b/2*cos(theta0);
	c		= interp1([-b/2,0,b/2],[ct,cr,ct],y0)';
	
	
	
	
	Clalpha = 0.1038*180/pi*ones(n,1);												% in rad^-1
	Cl0		= 0.1795;
	alpha0	= -Cl0/(Clalpha(1)*pi/180);										% alpha_zero_lift  (in degrees)
	alpha0	= alpha0*ones(n,1)/180*pi;
	
	alphar	= alphas(alpha_n);												% alpha della radice (di riferimento, in gradi)
	e		= [linspace(-2,0,n/2) linspace(0, -2, n/2)]';												% twist of each wing section, in degrees
	
	alpha=(alphar+e)/180*pi;												% angle of attack of each section (in rad)

	[CL_inv,Cl] = LLT (n,alpha,Clalpha,alpha0,c,AR,b,S,Vinf,rho,theta0);

	figure(1); clf;hold on;
	plot(y0,Cl,'b'); clear Cl
	
	% --------------------------------------------------------------------
	
	
	
	
	% BEGGINING OF NON-LINEAR CORRECTION
	
	aerodata	= load('NACA_64_210_abbott.dat');
	data.alpha  = aerodata(:,1);
	data.Cl		= aerodata(:,2);
	
	% Etapa 1
	del = 0*ones(n,1);
	dCl = 0*ones(n,1);
	
	% Etapa 2
	Clalpha = 2*pi*ones(n,1);												% in rad^-1
	Cl0		= 0;
	alpha0	= -Cl0/(Clalpha(1)*pi/180);										% alpha_zero_lift  (in degrees)
	alpha0	= alpha0*ones(n,1)/180*pi;
	
	[~,Cl_inv] = LLT (n,alpha,Clalpha,alpha0,c,AR,b,S,Vinf,rho,theta0);

	Cl = Cl_inv;
	

	for i=1:50
		
		% Etapa 3
		alphae = Cl/(2*pi)-del; %rad
		
		% Etpa 4
		Cl_visc = interp1(data.alpha,data.Cl,alphae*180/pi);
		dCl = Cl_visc - Cl;
		
		% Etapa 5
		del = del + dCl/(2*pi);
% 		alphae = alphae+del; %rad
	
		Cl = Cl_visc;
		CLvisc = 1/(rho*S)*trapz(y0,(c.*Cl));
		
	end
	
	
	plot(y0,Cl_visc,'r');hold on
	pause (.2)
	fprintf('\nalpha %9.1f: CLinv = %9.4f | CLvisc = %9.4f | visc-inv %9.4f \n', alphar, CL_inv, CLvisc, CLvisc-CL_inv)

	ccc=1;
% --------------------------------------------------------------------
end

