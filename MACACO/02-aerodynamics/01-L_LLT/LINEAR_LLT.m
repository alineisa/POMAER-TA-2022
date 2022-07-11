function [ aerodados3D ] = LINEAR_LLT( gg,flt,varargin )
global aerodados2D

% Modificação da entrada

% varargin é uma variável de opções. Colocar nela o que se deseja modificar no gg ou na flt.
% Ex: LINEAR_LLT( gg,flt, 'flt.Voo',10,'gg.perfiln',1 )

for i=1:2:length(varargin)
	modif_var = [varargin{i},'=',num2str(varargin{i+1}),';'];
	eval(modif_var);	
end


	
	
%% ========================================================================
%  =================== LINHA SUSTENTADORA LINEAR ==========================
%  ========================================================================

Re = flt.atm_rho*flt.Voo*gg.cma/flt.atm_mi;
for Re_i = 1:length(aerodados2D(gg.perfiln).Re)
	if aerodados2D(gg.perfiln).Re(Re_i).Re >= Re
		break
	end
end
if Re_i~=1
	Re_i = Re_i-1;
end
		
% Número de estações
n=40;


% Vetor de distribuição de estações
theta0=linspace(0,pi,n);


% Propriedades do perfil
Clalpha = aerodados2D(gg.perfiln).Re(Re_i).Clalpha     *  ones(n,1) *(180/pi) ;		% rad^-1
alpha0	= aerodados2D(gg.perfiln).Re(Re_i).alpha0_lin  *  ones(n,1)/180*pi;			% rad
clmax2D = aerodados2D(gg.perfiln).Re(Re_i).Clmax;


% Torção geométrica de cada seção [graus]
e=[linspace(gg.i+gg.alfatwist,  gg.i              ,  n/2),...
   linspace(gg.i             ,  gg.i+gg.alfatwist ,  n/2)]';  

% Vetor de estações
y0=-gg.b/2*cos(theta0);

% Vetor de cordas
if gg.tipo==5 || gg.tipo==6
	c = wing_bezier(y0,gg.b,gg.bt,gg.cr,gg.ct,n);	
else
	if gg.bt ==0
		c=interp1([-gg.b/2, 0, gg.b/2],[gg.ct, gg.cr, gg.ct], y0)';
	elseif gg.bt==1 || gg.cr==gg.ct
		c=gg.cr*ones(n,1);
	else
		c=interp1([-gg.b/2, -gg.bt*(gg.b/2) 0 gg.bt*(gg.b/2) gg.b/2],[gg.ct, gg.cr, gg.cr, gg.cr, gg.ct], y0)';
	end
end



for alphann = 1:3 % Variando o ângulo de ataque de delta_alpha=0 a delta_alpha=1 para calcular o CLalpha
	% Angulo de ataque
	alpha=flt.alpha*pi/180 + e*pi/180  + (alphann-1)*pi/180; 

	% --- Solução do sistema linear ---
	Anoto=(alpha(2:n-1)-alpha0(2:n-1));
	for i=2:n-1
		for j=2:n-1
	 A(i-1,j-1)=4*gg.b*sin((j-1)*theta0(i))/(Clalpha(i)*c(i))+(j-1)*sin((j-1)*theta0(i))/sin(theta0(i));
		end
	end
	An=A\Anoto;
	% --------------------------------

	% Distribuição de sustentação
	Gamma=zeros(1,n);
	for i=2:n-1
		Gamma(i)=2*gg.b*flt.Voo*sum(An(:).*sin((1:n-2)*theta0(i))');
	end
	Cl=2*Gamma./(c'*flt.Voo);

	% Integração dos coeficientes tridimensionais
	CL(alphann)=An(1)*pi*gg.AR;
	CDi(alphann)=pi*gg.AR*sum((1:n-2)'.*(An.^2));
	
	
	for alpha_n =1:length(aerodados2D(gg.perfiln).Re(Re_i).Cm)
		if aerodados2D(gg.perfiln).Re(Re_i).alpha(alpha_n) >= alpha*180/pi
			break
		end
	end
	
	alpha_vet(alphann)	= alpha(round(n/2));
	
	cd0	(alphann)		= aerodados2D(gg.perfiln).Re(Re_i).Cd(alpha_n);
	CD0(alphann)		= 1/gg.S * trapz(y0,cd0(alphann).*c);
	
	cmc4(alphann)		= aerodados2D(gg.perfiln).Re(Re_i).Cm(alpha_n);
	CMc4(alphann)		= 1/(gg.S*gg.cma)*trapz(y0, cmc4(alphann).*(c.^2));

end


aerodados3D.alpha				= flt.alpha;

aerodados3D.CL					= 0.95*CL(1);
aerodados3D.CLalpha				= 0.95*mean(diff(CL)/diff(alpha_vet));
aerodados3D.CL0					= (aerodados3D.CLalpha*(0-(flt.alpha+gg.i)*pi/180) + aerodados3D.CL);
aerodados3D.CLwmax				= (aerodados3D.CLalpha/Clalpha(1))*clmax2D;

aerodados3D.CDi					= 1.05*CDi(1);
%aerodados3D.CD0				= CD0(1);
%aerodados3D.CDtot				= CDi(1)+CD0(1);

aerodados3D.CMc4				= CMc4(1);
aerodados3D.CMc4_alpha			= mean(diff(CMc4)/diff(alpha_vet));
aerodados3D.CMc4_0				= (aerodados3D.CMc4_alpha*(0-(flt.alpha+gg.i)*pi/180) + aerodados3D.CMc4);

aerodados3D.perfil.Re			= Re;
aerodados3D.perfil.Re_i			= Re_i;
aerodados3D.perfil.alpha		= alpha_vet(1)*180/pi;
aerodados3D.perfil.clalpha		= Clalpha;
aerodados3D.perfil.alpha0		= alpha0;
aerodados3D.perfil.clmax		= clmax2D;
aerodados3D.perfil.cd0			= cd0(1);
aerodados3D.perfil.cmc4			= cmc4(1);

aerodados3D.perfil.curva_alpha	= aerodados2D(gg.perfiln).Re(Re_i).alpha;
aerodados3D.perfil.curva_cl		= aerodados2D(gg.perfiln).Re(Re_i).Cl;
aerodados3D.perfil.curva_cd0	= aerodados2D(gg.perfiln).Re(Re_i).Cd;
aerodados3D.perfil.curva_cmc4	= aerodados2D(gg.perfiln).Re(Re_i).Cm;


end

