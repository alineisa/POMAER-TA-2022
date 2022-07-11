clear;
% clc; 
% close all
n=20;

Vinf= 100;
rho = 1;

bw		= 4;
croot	= 1;
ctip	= 1;

S = 2*(croot+ctip)*(bw/2)/2;
AR = bw^2/S;

alpha_inf	= 10;
alfatwist	= 0;

Clalpha=2*pi*ones(n,1);
alpha0=0*ones(n,1)*pi/180;


% ======================================================================= %
theta0	=linspace(0,pi,n);
y0		=-bw/2*cos(theta0);


c=interp1([-bw/2, 0, bw/2],[ctip, croot, ctip], y0)';

CL = 0.703076;

% alpha_inf = 1.9735; % para equivalente a 2°
alpha_inf = 9.8482;
e = ( sqrt(1-(2*y0'/bw).^2)./(pi*Vinf.*c) + 0*CL/(pi*AR) )*180/pi;



% e=[linspace(alfatwist,0,n/2), linspace(0,alfatwist,n/2)]';

% ======================================================================= %
alpha= (e+alpha_inf)/180*pi;

Anoto=(alpha(2:n-1)-alpha0(2:n-1));
for i=2:n-1
	for j=2:n-1
		A(i-1,j-1)=4*bw*sin((j-1)*theta0(i))/(Clalpha(i)*c(i))+(j-1)*sin((j-1)*theta0(i))/sin(theta0(i));
	end;
end;
An=A\Anoto;

CL_LLT=An(1)*pi*AR;
L	= .5*rho*Vinf^2*S*CL_LLT;

CDi_LLT=pi*AR*sum((1:n-2)'.*(An.^2));
Di = .5*rho*Vinf^2*S*CDi_LLT;

Gamma=zeros(1,n);
for i=2:n-1
	Gamma(i)=2*bw*Vinf*sum(An(:).*sin((1:n-2)*theta0(i))');
end;

Cl  = 2*Gamma./(c'*Vinf);
l   = rho*Vinf*Gamma;

figure(1); hold on
plot(y0,Cl); xlabel y0; ylabel cl

figure(2); hold on
plot(y0,l); xlabel y0; ylabel L

figure(3); hold on
plot(y0,e); xlabel y0; ylabel i_w
fprintf('CL:  %9.6f\n', CL_LLT)
fprintf('CDi: %9.6f\n', CDi_LLT)

% fprintf('L:  %9.6f\n', L)
% fprintf('Di: %9.6f\n', Di)