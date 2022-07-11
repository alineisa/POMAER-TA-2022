function [ ] = CalcCoeffs( plane, polar_n )

% ======================================================================= %
%						PREPARATIONS									  %		
% ======================================================================= %
nLS		= plane.Geo.nLS;

Voo		= plane.Aero.Loads(polar_n).Voo;
Yb		= plane.Aero.Mesh.Yb;
c		= plane.Aero.Mesh.Chord;
MAC		= plane.Geo.MAC;
S		= plane.Aero.Loads(polar_n).Sref;
b		= plane.Aero.Loads(polar_n).Bref;

G		= plane.Aero.Loads(polar_n).G;
cl		= plane.Aero.Loads(polar_n).cl';
cd0		= plane.Aero.Loads(polar_n).cd0';
cm		= plane.Aero.Loads(polar_n).cm25';
alpha_i = plane.Aero.Loads(polar_n).alpha_ind;


plane.Aero.Coeffs(polar_n).CL		= 0;
plane.Aero.Coeffs(polar_n).CDi		= 0;
plane.Aero.Coeffs(polar_n).CD0		= 0;
plane.Aero.Coeffs(polar_n).Cm25		= 0;
plane.Aero.Coeffs(polar_n).Cl_rol	= 0;
plane.Aero.Coeffs(polar_n).Cni		= 0;
plane.Aero.Coeffs(polar_n).Cn0		= 0;

plane.Aero.Coeffs(polar_n).CD		= 0;
plane.Aero.Coeffs(polar_n).Cn		= 0;



% Appending flight conditions and reference dimensions to the global polar
plane.Aero.Coeffs(polar_n).Re		= plane.Aero.Loads(polar_n).Re;
plane.Aero.Coeffs(polar_n).Ma		= plane.Aero.Loads(polar_n).Ma;
plane.Aero.Coeffs(polar_n).alpha	= plane.Aero.Loads(polar_n).alpha;
plane.Aero.Coeffs(polar_n).beta		= plane.Aero.Loads(polar_n).beta;
plane.Aero.Coeffs(polar_n).p		= plane.Aero.Loads(polar_n).p;
plane.Aero.Coeffs(polar_n).q		= plane.Aero.Loads(polar_n).q;
plane.Aero.Coeffs(polar_n).r		= plane.Aero.Loads(polar_n).r;
plane.Aero.Coeffs(polar_n).rho		= plane.Aero.Loads(polar_n).rho;
plane.Aero.Coeffs(polar_n).mu		= plane.Aero.Loads(polar_n).mu;
plane.Aero.Coeffs(polar_n).H		= plane.Aero.Loads(polar_n).H;
plane.Aero.Coeffs(polar_n).Sref		= plane.Aero.Loads(polar_n).Sref;
plane.Aero.Coeffs(polar_n).Bref		= plane.Aero.Loads(polar_n).Bref;






% ======================================================================= %
%								CALCULATIONS							  %		
% ======================================================================= %
for LSn=1:nLS
	
	% LIFTING SURFACES COEFFICIENTS
	% ---------------------------------------------------
	
	% Appending flight conditions and reference dimensions to the LS polar
	
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Re		= plane.Aero.Coeffs(polar_n).Re;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Ma		= plane.Aero.Coeffs(polar_n).Ma;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).alpha	= plane.Aero.Coeffs(polar_n).alpha;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).beta	= plane.Aero.Coeffs(polar_n).beta;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).p		= plane.Aero.Coeffs(polar_n).p;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).q		= plane.Aero.Coeffs(polar_n).q;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).r		= plane.Aero.Coeffs(polar_n).r;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).rho		= plane.Aero.Coeffs(polar_n).rho;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).mu		= plane.Aero.Coeffs(polar_n).mu;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).H		= plane.Aero.Coeffs(polar_n).H;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Sref	= plane.Aero.Coeffs(polar_n).Sref;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Bref	= plane.Aero.Coeffs(polar_n).Bref;

	% Index on the global mesh for integrating
	meshIndex		= (plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(1) : plane.LiftingSurfaces(LSn).Aero.Mesh.IndexOnMergedMesh(2))';

	meshIndexLeft	= meshIndex(			    1 : floor(end/2) );
	meshIndexRight	= meshIndex( floor(end/2) + 1 : end		     );
	
	
	% All of the bellow coefficients are based on (execpt when explictly indicated):
	% Method for calculating wing characteristics by lifting-line theory using non-linear section data, NACA Technical Note n° 1269
	
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CL		=  1/S		* ( trapz(Yb(meshIndexLeft),   c(meshIndexLeft)   .*cl(meshIndexLeft))  + ...
																		    trapz(Yb(meshIndexRight),  c(meshIndexRight)  .*cl(meshIndexRight)) );
	
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CDi		=  abs(2/(Voo*S)* ( trapz(Yb(meshIndexLeft),   G(meshIndexLeft)   .*alpha_i(meshIndexLeft) *pi/180) + ...		% Anderson Fundamentals of Aerodynamics
																			trapz(Yb(meshIndexRight),  G(meshIndexRight)  .*alpha_i(meshIndexRight)*pi/180) ));
         %%% ATENTION: 'abs' (module) in CDi is being used because sometimes this coeff is being
         %calculed as negative. Mainly with wing-tail configs.
                                     
                                                                        
	if ~isempty(cd0)
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD0		=  1/S		* ( trapz(Yb(meshIndexLeft),   cd0(meshIndexLeft) .*c(meshIndexLeft))  +...						% Eq. 17
																			trapz(Yb(meshIndexRight),  cd0(meshIndexRight).*c(meshIndexRight)) );
	else
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD0		= 0;
	end
	if ~isempty(cm)
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cm25	=  1/(S*MAC)* ( trapz(Yb(meshIndexLeft),   cm(meshIndexLeft)  .*c(meshIndexLeft) .^2)  + ...				% Eq. 18 considering reference line at c/4
																			trapz(Yb(meshIndexRight),  cm(meshIndexRight) .*c(meshIndexRight).^2) );
	else
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cm25	= 0;
	end
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cl_rol	= -1/(S*b)	* ( trapz(Yb(meshIndexLeft) ,  cl(meshIndexLeft)  .*c(meshIndexLeft) .*Yb(meshIndexLeft)) + ...	% Eq. 20
																			trapz(Yb(meshIndexRight) , cl(meshIndexRight) .*c(meshIndexRight).*Yb(meshIndexRight)) );
	
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cni		=  1/(S*b)	* ( trapz(Yb(meshIndexLeft) ,  cl(meshIndexLeft)  .*c(meshIndexLeft)  .*alpha_i(meshIndexLeft) *pi/180 .*Yb(meshIndexLeft))   + ...  % Eq. 21
																			trapz(Yb(meshIndexRight) , cl(meshIndexRight) .*c(meshIndexRight) .*alpha_i(meshIndexRight)*pi/180 .*Yb(meshIndexRight)) );
	if ~isempty(cd0)
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn0		=  1/(S*b)	* ( trapz(Yb(meshIndexLeft) ,  cd0(meshIndexLeft) .*c(meshIndexLeft) .*Yb(meshIndexLeft)) + ...	% Eq. 22
																			trapz(Yb(meshIndexRight) , cd0(meshIndexRight).*c(meshIndexRight).*Yb(meshIndexRight)) );
	else
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn0		= 0;
	end
	
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD		=  plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CDi + plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD0;
	plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn		=  plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cni + plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn0;
	
	
	
	% GLOBAL COEFFICIENTS
	% ---------------------------------------------------
	
	plane.Aero.Coeffs(polar_n).CL		= plane.Aero.Coeffs(polar_n).CL		+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CL;
	plane.Aero.Coeffs(polar_n).CDi		= plane.Aero.Coeffs(polar_n).CDi	+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CDi;
	plane.Aero.Coeffs(polar_n).CD0		= plane.Aero.Coeffs(polar_n).CD0	+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD0;
	plane.Aero.Coeffs(polar_n).Cm25		= plane.Aero.Coeffs(polar_n).Cm25	+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cm25;
	plane.Aero.Coeffs(polar_n).Cl_rol	= plane.Aero.Coeffs(polar_n).Cl_rol + plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cl_rol;
	plane.Aero.Coeffs(polar_n).Cni		= plane.Aero.Coeffs(polar_n).Cni	+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cni;
	plane.Aero.Coeffs(polar_n).Cn0		= plane.Aero.Coeffs(polar_n).Cn0	+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn0;
	
	plane.Aero.Coeffs(polar_n).CD		= plane.Aero.Coeffs(polar_n).CD		+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).CD;
	plane.Aero.Coeffs(polar_n).Cn		= plane.Aero.Coeffs(polar_n).Cn		+ plane.LiftingSurfaces(LSn).Aero.Coeffs(polar_n).Cn;

end







return

% plane.Aero.Coeffs(polar_n).CL			=  1/S			* trapz(Yb0,c.*cl);
% plane.Aero.Coeffs(polar_n).CDi		=  2/(Voo*S)	* trapz(Yb0,G.*alpha_i*pi/180);			% Anderson Fundamentals of Aerodynamics
% plane.Aero.Coeffs(polar_n).CD0		=  1/S			* trapz(Yb0,cd0.*c);					% Eq. 17
% plane.Aero.Coeffs(polar_n).Cm25		=  1/(S*MAC)	* trapz(Yb0,cm.*c.^2);					% Eq. 18 considering reference line at c/4
% plane.Aero.Coeffs(polar_n).Cl_rol		= -1/(S*b)		* trapz(Yb, cl.*c.*Yb);					% Eq. 20
% plane.Aero.Coeffs(polar_n).Cni		=  1/(S*b)		* trapz(Yb, cl.*c.*alpha_i*pi/180.*Yb);	% Eq. 21
% plane.Aero.Coeffs(polar_n).Cn0		=  1/(S*b)		* trapz(Yb, cd0.*c.*Yb);				% Eq. 22
% 
% plane.Aero.Coeffs(polar_n).CD			= plane.Aero.Coeffs(polar_n).CDi + plane.Aero.Coeffs(polar_n).CD0;
% plane.Aero.Coeffs(polar_n).Cn			= plane.Aero.Coeffs(polar_n).Cni + plane.Aero.Coeffs(polar_n).Cn0;

% CL = 1/S * trapz(y,c.*cl);
% 
% CDi = 2/(Voo*S) * trapz(y,G.*alpha_i);
% plane.Aero.GlobalCoeffs(polar_n).CDi = CDi;
% 
% CD0 = 1/S * trapz(y,cd0.*c);
% % Trocar c(1) pela corda média
% Cm  = 1/(S*c(1))*trapz(y,cm.*c.^2);
% 
% plane.Aero.GlobalCoeffs(polar_n).CD0 = CD0;
% plane.Aero.GlobalCoeffs(polar_n).CM  = Cm;  
% plane.Aero.GlobalCoeffs(polar_n).CD  = CDi+CD0;





% 
% CDi(a_atk_n)= 2/(Voo*S)*trapz(y,Gama_inp.*sin(alpha_i'));
% cdi = ;
% w = -Gama_new./(4*pi*(b/2+y)) - Gama_new./(4*pi*(b/2-y));	% Downwash Eq. 5.12
% 
% 
% % --->  Os cálculos abaixo são baseados em:
% % Method for calculating wing characteristics by lifting-line theory using non-linear section data, NACA Technical Note n° 1269
% % Conferir!!!
% get_cd0_cm	% Obtém os dados de distribuição de cd0 e cm(c/4) bidimensionais
% 
% % Cálculo de arrastos
% cdtot = cd0+cdi;
% CD0(a_atk_n) = 1/S * trapz(y,cd0.*c);				% Eq. 17
% CDtot(a_atk_n) = CDi(a_atk_n)+CD0(a_atk_n);
% 
% % Cálculo de Cm em c/4
% CMc4(a_atk_n)	= 1/(S*CMA)*trapz(y, cmc4.*(c.^2));	% Eq. 18 para considerando a referência na linha de c/4 da envergadura
% 
% 
% % Cálculo de Cm em uma referência dada
% p1 = cl'.*cos(alpha_eff) + cd0'.*sin(alpha_eff);
% p2 = cl'.*sin(alpha_eff) - cd0'.*cos(alpha_eff);
% cmref	= cmc4 - xref_m./c.*(p1') - zref_m./c.*(p2');
% CMref(a_atk_n)	= 1/(S*CMA)*trapz(y, cmref.*(c.^2));% Eq. 18 para a referência
% 
% % Cálculo do coeficiente do momento de rolagem
% Clr(a_atk_n) = -1/(S*b)*trapz(y, cl.*c.*y);			% Eq. 20
% 
% % Cálculo do coeficiente do momento de guinada induzida (devido à ditribuição de arrasto induzido)
% Cni(a_atk_n) = 1/(S*b)*trapz(y, cl.*c.*alpha_i'.*y);% Eq. 21 (foi retirado o pi/180 porque já está em rad (conferir se tá certo))
% 
% % Cálculo do coeficiente de momento de guinada (devido à distribuição do arrasto de perfil)
% Cn0(a_atk_n) = 1/(S*b)*trapz(y, cd0.*c.*y);			% Eq. 22


end

