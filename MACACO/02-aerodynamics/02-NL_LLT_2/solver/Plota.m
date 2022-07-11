if plota_gerais
	figure(1); clf
	
	set(gcf,'Name',['gerais: alpha = ',num2str(a_atk(a_atk_n)*180/pi),'°'])
	subplot(2,3,1)
	plot(y,Gama_old); title('Gama\_old vs Gama\_new'); hold on
	plot(y,Gama_new); legend('old','new','Location','SouthEast')
	xlabel('Envergadura [m]'); ylabel('\Gamma')
	grid minor
	graph_format(plota_cor)
	
	subplot(2,3,2)
	plot(y,dGama_dy); title('dGamma\_dy')
	xlabel('Envergadura [m]');ylabel('^{d\Gamma}/_{dy}')
	grid minor
	graph_format(plota_cor)
	
	subplot(2,3,3)
	plot(y,alpha_i*180/pi,'r');   hold on
	plot(y,alpha*180/pi,'g');
	plot(y,alpha_eff*180/pi,'b');
	title('ângulos de ataque')
	ylabel('ângulo [°]')
	xlabel('Envergadura [m]');
	legend('ind','geo','eff','Location','SouthWest')
	axis([y(1) y(end) min(a_atk)*180/pi-5 max(a_atk)*180/pi+5])
	grid minor
	graph_format(plota_cor)
	
	subplot(2,3,4)
	plot(y,w); title('Downwash')
	xlabel('Envergadura [m]');
	ylabel('w')
	grid minor
	graph_format(plota_cor)
	
	subplot(2,3,5)
	plot(y,cl); title('cl')
	xlabel('Envergadura [m]');
	ylabel('C_l')
	grid minor
	axis([y(1) y(end) 0 2.5])
	graph_format(plota_cor)
	

	
	subplot(2,3,6)
	semilogy(erro_CL); title('erro absoluto do CL ');grid on; grid minor
	xlabel('iterações');
	line([iters,iters],[min(erro_CL) max(erro_CL)],'Color','r')
	line([1 iters],[conv_CL conv_CL],'Color','r')
	graph_format(plota_cor)
end
%-----------------------------------------------------------------------------------------------

if plota_curvaCL
	figure(2); hold off
	set(gcf,'Name','Curva CL')
	set(gcf,'color',[1 1 1])
	
	
	p3d = plot(a_atk(1:a_atk_n)*180/pi,CL(1:a_atk_n),'-o','LineWidth',1);
	xlabel('Ângulo de ataque \alpha [°]'); ylabel('C_L')
	grid minor; grid on
	hold on
	
	if cl_polar
		hold on
		for i=1:size(aerodados)
			p2d = plot(aerodados(i).alpha,aerodados(i).cl,'.');hold on
		end
	end
	hl = legend([p2d p3d],{'Curva Bidimensional','Curva tridimensinal'},'Location','SouthEast');
	if plota_curvaCL_ae
		cor = colormap(copper(round(n/2)));
		cor = [cor; flipud(cor)];
		for ii=1:n
			lin(ii) = line([alpha_eff(ii), alpha_eff(ii)]*180/pi, [min(aerodados.cl) max(aerodados.cl)], 'Color',cor(ii,:));
		end
		hl = legend([p2d p3d lin(1) lin(ii/2)],{'Curva Bidimensional','Curva tridimensinal','\alpha_{eff} local da extremidade','\alpha_{eff} local do centro'},'Location','SouthEast');
	end
	graph_format(plota_cor)
	
	
	
	
end

%-----------------------------------------------------------------------------------------------
if plota_conv
	figure(3)
	set(gcf,'Name',['Convergências: alpha = ',num2str(a_atk(a_atk_n)*180/pi),'°'])
	set(gcf,'color',[1 1 1])
	set(gcf,'Name','Convergência')
	
	
	subplot(1,2,1)
	semilogy(erro_Gama);grid on; grid minor
	xlabel('iterações');
	ylabel('max(|\Gamma_{new}-\Gamma_{old}|)')
	line([iters,iters],[min(erro_Gama) max(erro_Gama)],'Color','r')
	line([1 iters],[conv_Gama conv_Gama],'Color','r')
	title(['erro \Gamma final: ',num2str(erro_Gama(end))])
	graph_format(plota_cor)
	
	
	subplot(1,2,2)
	semilogy(erro_CL);grid on; grid minor
	xlabel('iterações');
	ylabel('|CL_{new}-CL_{old}|')
	line([iters,iters],[min(erro_CL) max(erro_CL)],'Color','r')
	line([1 iters],[conv_CL conv_CL],'Color','r')
	title(['erro C_L final: ',num2str(erro_CL(end))])
	text(iter,erro_CL(end),['Iterações: ',num2str(iter)])
	graph_format(plota_cor)
% 	
% 	subplot(2,2,3); hold on
% 	semilogy(a_atk_n,erro_Gama(end),'ow');grid on; grid minor
% 	xlabel('iterações');
% 	ylabel('max(|\Gamma_{new}-\Gamma_{old}|)')
% 	title(['erro \Gamma final: ',num2str(erro_Gama(end))])
% 	graph_format(plota_cor)
% 	
% 	subplot(2,2,4); hold on
% 	semilogy(a_atk_n,erro_CL(end),'ow');grid on; grid minor
% 	xlabel('iterações');
% 	ylabel('max(|\Gamma_{new}-\Gamma_{old}|)')
% 	title(['erro \Gamma final: ',num2str(erro_Gama(end))])
% 	graph_format(plota_cor)
end

%-----------------------------------------------------------------------------------------------
if plota_asa3D
	figure(4); clf
	set(gcf,'Name','Asa3D')
	
	p = load(plota_asa3D_perf);
	p(1:3,:)=[];
	p(end-2:end,:)=[];

	x = p(:,1)'-.25; 
	z1 = p(:,2)'*1;
	
% 	enf1   = sweep;
% 	enf2   = sweep;
% 	
% 	died1  = 0;
% 	died2  = 0;
% 	
	torc   = (i_g(round(length(i_g)/2))-i_g(end))*180/pi;
	alfa   = 0;
% 	cr = c(1);
% 	bt = 0.5;
% 	b_t = b/2;
	
% 	keyboard
% 	Xwp = [cr*x*cosd(alfa)
% 		 cr*x*cosd(alfa)          + b_t*b/2*sind(enf1)
% 		 ct *x*cosd(alfa + torc)  + (1-b_t)*b/2*sind(enf2)];
% 	
% 	Zwp = [cr*z1 - sind(alfa)*x
% 		 cr*z1 - sind(alfa)*x + b_t*b/2*sind(died1)
% 		 ct*z1  - sind(alfa + torc)*x+ (1-b_t)*b/2*sind(died2)];
% 	
% 	Ywp = [zeros(1,length(x)); ones(1,length(x))*b/2*b_t; ones(1,length(x))*b/2];
	
		alfa(1) = 0;
		died(1) = 0;
		Xwp(1,:) = C(i)*x*cosd(alfa(1));
		Zwp(1,:) = C(i)*z1 - sind(alfa(1))*x;
		Ywp(1,:) = zeros(1,length(x));
	for i=2:length(C)
		alfa(i) = 0;
		died(i) = 0;
		Xwp(i,:) = C(i)*x*cosd(alfa(i)) + (Y(i)-Y(i-1))*sind(sweep);
		Zwp(i,:) = C(i)*z1 - sind(alfa(i))*x +(Y(i)-Y(i-1))*sind(died(i));
		Ywp(i,:) = ones(1,length(x))*Y(i);
	end
	
	
	
	
	
	if plota_asa3D_saveSTL
		if plota_asa3D_saveSTL_simmetry
			colormap('gray')
			S_wing = surf([Xwp; Xwp],[Ywp; -Ywp],[Zwp; Zwp],'EdgeColor','none');
			view(-35,20); axis equal; graph_format('w')
			fvc = surf2patch(S_wing,'triangle');
			stl_write(fvc,plota_asa3D_saveSTL_name)
		else
			colormap('gray')
			S_wing = surf(Xwp,Ywp,Zwp,'EdgeColor','none');
			view(-35,20); axis equal; graph_format('w')
			fvc = surf2patch(S_wing,'triangle');
			stl_write(fvc,plota_asa3D_saveSTL_name)
		end
	else
		colormap('gray')
		hold on
	 	surf(Xwp,Ywp,Zwp,'EdgeColor','none');
	 	surf(Xwp,-Ywp,Zwp,'EdgeColor','none');
		view(-35,20); axis equal; graph_format('w')
	end
	
% 	keyboard
end

%-----------------------------------------------------------------------------------------------
if plota_distCL
	figure(5);clf
	set(gcf,'Name',['Distribuição de C_l: alpha = ',num2str(a_atk(a_atk_n)*180/pi),'°'])
	plot(y,cl)
	title('Distribuição de C_l')
	xlabel('Envergadura [m]')
	ylabel('C_l')
	graph_format(plota_cor)
end

if plota_distCD
	figure(6);clf; hold on
	set(gcf,'Name',['Distribuição de C_d: alpha = ',num2str(a_atk(a_atk_n)*180/pi),'°'])
	plot(y,cdi)
	plot(y,cd0)
	plot(y,cdtot)
	legend('c_{di}','c_{d0}','c_{d tot}')
	title('Distribuição de C_d')
	xlabel('Envergadura [m]')
	ylabel('C_d')
	graph_format(plota_cor)
end

if plota_distCMc4
	figure(7); clf
	set(gcf,'Name',['Distribuição de Cm_c/4: alpha = ',num2str(a_atk(a_atk_n)*180/pi),'°'])
	plot(y,cmc4)
	title('Distribuição de Cm_{c/4}')
	xlabel('Envergadura [m]')
	ylabel('Cm_{c/4}')
	graph_format(plota_cor)
end


%-----------------------------------------------------------------------------------------------
if plota_estacoes
	figure(8); hold on
	dle = (c(round(n/2))-c)*0.25;
	for pp=1:n
		fill3([dle(pp) dle(pp) c(pp)+dle(pp) c(pp)+dle(pp)],...
			[y(pp) y(pp+1) y(pp+1) y(pp)],...
			[(dle(pp)+.25*c(pp))*sin(alpha(pp)) (dle(pp)+.25*c(pp))*sin(alpha(pp)) -(dle(pp)+.75*c(pp))*sin(alpha(pp)) -(dle(pp)+.75*c(pp))*sin(alpha(pp))]*5, 'w')
		line([dle(pp)+0.25*c(pp) dle(pp+1)+0.25*c(pp+1)],[y(pp) y(pp+1)],[0.01 0.01],'color','g');
	end
	axis image
	view(90,90)
	
		
	if plota_plota_estac_vortex
			sumz=0.01;
			corpp = colormap(autumn(round(n/2)));
		for pp=1:round(n/2)
			sumz = sumz+0.01;
			line([dle(pp) dle(pp)],[y(pp) y(end-pp)],[sumz sumz],'color',corpp(pp,:))
			line([dle(pp) 5*c(end)],[y(pp) y(pp)],[sumz sumz],'color',corpp(pp,:))
			line([dle(end-pp) 5*c(end)],[y(end-pp) y(end-pp)],[sumz sumz],'color',corpp(pp,:))
		end
		view(35,25)
	end
	graph_format('w')
end



%-----------------------------------------------------------------------------------------------
pause(1e-10)







