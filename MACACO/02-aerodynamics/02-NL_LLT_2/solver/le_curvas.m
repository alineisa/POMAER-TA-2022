function [cl_lin,cl_nl,cl0_lin,cl0_nl,cla,alpha0_lin,clmax,alpha_clmax,cdmin,cm]=le_curvas(perfil,Re,alpha,calccm, precisao)
% [cl_lin,cl_nl,cl0_lin,cl0_nl,cla,alpha0_lin,clmax,alpha_clmax,cdmin,cm]=le_curvas('s1223',313000,4.75,true)


%% ================================================================================================================================================
%  ======================================================== LE_CURVAS PRECIS�O ====================================================================
%  ================================================================================================================================================

switch precisao
	case true
		%% %%%%%%%%%% TRATAMENTO DA CURVA Cl por ALPHA %%%%%%%%%%%%%%%%%%%%%%%%%%%%
		pasta=[pwd,'\curvas_',perfil,'\'];				% Pasta com as polares
		arquivo=[pasta,perfil,'_Re',sprintf('%07d',Re),'.dat'];	% Arquivo da polar pro Reynolds dado
		
		
		% Se existe o arquivo da polar pro Reynolds dado, a curva cl x alpha vai ser a do pr�prio arquivo
		if exist(arquivo,'file')==2
			coefxalpha=load(arquivo);
			
			%---------------------------
			% Se n�o existir, o cl ser� interpolado entre as curvas com os Reynolds mais pr�ximos
		else
			lista=fopen([pasta,'/lista_Re.dat'],'r'); % Carrega o arquivo que lista todos os Reynolds dispon�veis
			Re_lista=cell2mat(textscan(lista,'%07.0f\n'));
			fclose(lista);
			
			%--------------------------- (Caso o Re seja maior do que o menor Reynolds dispon�vel)
			if Re>Re_lista(1)
				Re1 = Re_lista(find(Re_lista>Re,1,'first'));	% V� qual � o arquivo com o Reynolds imediantamente maior (Re1)
				try								% Tenta abrir o arquivo com a curva do Reynolds imediantamente maior
					arquivo1=[pasta,perfil,'_Re',sprintf('%07d',Re1),'.dat'];
					coefxalpha1=load(arquivo1);
				catch err							% Se n�o conseguir e falar que a vari�vel Re1 n�o existe ('MATLAB:UndefinedFunction') ...
					if (strcmp(err.identifier,'MATLAB:UndefinedFunction'))
						warning(['A curva com o maior Reynolds dispon�vel �: ',num2str(max(Re_lista))])
						error('N�o existe arquivo para Reynolds maior ou igual ao escolhido, rode o arquivo gera_curvas.m para uma faixa de Re maior')
					end							% ... ent�o solta o erro avisando que n�o existe o arquivo com um Reynolds superior ao ...
				end								% ... de entrada, e pede pra simular uma nova faixa
				
				Re2 = Re_lista(find(Re_lista<Re,1,'last'));	% V� qual � o arquivo com o Reynolds imediantamente menor (Re2)
				arquivo2=[pasta,perfil,'_Re',sprintf('%07d',Re2),'.dat'];	% Abre o arquivo com o Reynolds imendiatamente menor
				coefxalpha2=load(arquivo2);
				
				%------- Faz a interpola��o linear entre o Reynolds imediatamente menor e o imediatamente maior
				% No entanto, provavelmente os arquivos t�m tamanhos diferentes
				% e ainda, n�o apresentam o mesmo valor de alfa para no mesmo
				% �ndice da matriz. Ent�o � necess�rio corrig�-los para que
				% tenham o mesmo tamanho e o �ndice da matriz corresponda ao mesmo alfa
				
				if length(coefxalpha2(:,1))<length(coefxalpha1(:,2)) % Se a matriz com o menor clxalpha for menor do que a com o maior, ent�o mantem ela e cria um clxalpha
					%auxiliar,que contem os alphas do arquivo com menos pontos e o cl pra esses alfas do arquivo com mais pontos
					k=0;
					for i=1:length(coefxalpha2(:,1))
						k=k+1;
						try
							coefxalphaaux(k,1)=coefxalpha2(k,1); % os alfas da matriz auxiliar ser�o os mesmos da matriz com menos pontos
							coefxalphaaux(k,2)=coefxalpha1( coefxalpha2(k,1)==coefxalpha1(:,1),2 ); % ... e os cl's ser�o os da matriz com mais pontos, para aqueles alfas
							coefxalphaaux(k,3)=coefxalpha1( coefxalpha2(k,1)==coefxalpha1(:,1),3 ); % cd
							if strcmp(calccm,'calc_cm')==1
								coefxalphaaux(k,4)=coefxalpha1( coefxalpha2(k,1)==coefxalpha1(:,1),4 ); % cm
							end
							
						catch err	% ... Mas pode acontecer de que mesmo com menos pontos, ela tenha algum alfa que a matriz maior n�o tenha
							if (strcmp(err.identifier,'MATLAB:subsassigndimmismatch')) % Se isso acontecer, esse alfa � tirado da matriz menor ...
								coefxalphaaux(k,:)=[];
								coefxalpha2(k,:)=[];
								k=k-1; % E volta uma linha das matrizes, sen�o a matriz auxiliar fica com uma linha preenchida com zeros
							end
						end
					end
					
					% Agora � criado o clxalpha final com valores de cl interpolados entre os dois Reynolds adjacentes
					
					coefxalpha(:,1)=coefxalphaaux(:,1);								% Ele tem os alfas comuns aos dois adjacentes
					for k=1:length(coefxalphaaux(:,1))
						coefxalpha(k,2)=interp1([Re1 Re2],[coefxalphaaux(k,2),coefxalpha2(k,2)],Re); % e os Cls interpolados
						coefxalpha(k,3)=interp1([Re1 Re2],[coefxalphaaux(k,3),coefxalpha2(k,3)],Re);
						if strcmp(calccm,'calc_cm')==1
							coefxalpha(k,4)=interp1([Re1 Re2],[coefxalphaaux(k,4),coefxalpha2(k,4)],Re);
						end
					end
					
					% Mas...
				else  % Se a matriz com o menor clxalpha for maior do que a com o menor, ent�o s�o feitos os mesmo passos de interpola��o descritos acima,
					% Mas invertendo quem ser� fixado
					k=0;
					for i=1:length(coefxalpha1(:,1))
						k=k+1;
						try
							coefxalphaaux(k,1)=coefxalpha1(k,1);
							coefxalphaaux(k,2)=coefxalpha2( coefxalpha1(k,1)==coefxalpha2(:,1),2 );
							coefxalphaaux(k,3)=coefxalpha2( coefxalpha1(k,1)==coefxalpha2(:,1),3 );
							if strcmp(calccm,'calc_cm')==1
								coefxalphaaux(k,4)=coefxalpha2( coefxalpha1(k,1)==coefxalpha2(:,1),4 );
							end
						catch err
							if (strcmp(err.identifier,'MATLAB:subsassigndimmismatch'))
								coefxalphaaux(k,:)=[];
								coefxalpha1(k,:)=[];
								k=k-1;
							end
						end
					end
					
					coefxalpha(:,1)=coefxalphaaux(:,1);
					for k=1:length(coefxalphaaux(:,1))
						coefxalpha(k,2)=interp1([Re1 Re2],[coefxalpha1(k,2),coefxalphaaux(k,2)],Re);
						coefxalpha(k,3)=interp1([Re1 Re2],[coefxalpha1(k,3),coefxalphaaux(k,3)],Re);
						if strcmp(calccm,'calc_cm')==1
							coefxalpha(k,4)=interp1([Re1 Re2],[coefxalpha1(k,4),coefxalphaaux(k,4)],Re);
						end
					end
				end
				
				
			else
				%--------------------------- (Caso o Re seja menor que o menor dispon�vel)
				% Ao contr�rio de quando o Re � maior do que o maior dispon�vel, n�o
				% ocorre um erro caso seja menor do que o menor dispon�vel. Isso �
				% feito porque no come�o da corrida, o Re � extremamente baixo, o que
				% inviabiliza a converg�ncia do xfoil. Dessa forma, se o Re for menor
				% do que o menor dispon�vel, ent�o ele ser� igual ao menor dispon�vel
				
				arquivo=[pasta,perfil,'_Re',sprintf('%07d',Re_lista(1)),'.dat'];
				coefxalpha=load(arquivo);
			end
		end
		
		fclose all;
		
		
		
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%% %%%%%%%%%%%%%%%% C�LCULO DOS COEFICIENTES DO PERFIL %%%%%%%%%%%%%%%%%%%%
		
		
		
		% ------------ Coeficiente de sustenta��o segundo o ajuste linear:
		alpha_min = 0;							% Menor alpha considerado para fazer o ajuste da regi�o linear
		alpha_max = 8;							% Maior alpha considerado para fazer o ajuste da regi�o linear
		if Re<150000							% Para Reynolds menor que 150000 o perfil estola para �ngulos menores, ent�o ...
			alpha_min = 1;						% � necess�rio fazer essa corre��o, sen�o, o clapha e principalemente o cl0 podem dar  ...
			alpha_max = 5;						% valores absurdos .(� sempre bom usar a os plots para monitarar como est� sendo feito ajuste ...
		end									% linear e se o cl0 est� em aproximamente -11�)
		
		
		i = find(coefxalpha(:,1)<=alpha_min,1,'last');		% Define em qual indice est� o alpha mais pr�ximo do m�nimo
		k = find(coefxalpha(:,1)>=alpha_max,1,'first');		% e em qual est� o alpha mais pr�ximo do m�ximo
		
		[coef_cl]=polyfit(coefxalpha(i:k,1),coefxalpha(i:k,2),1); % Faz o ajuste linear do cl
		
		
		cla=coef_cl(1);							% Cl alpha do perfil [graus]
		cl0_lin=coef_cl(2);						% Cl para alpha=0 do perfil
		clxalpha_lin=@(alpha) cl0_lin + alpha*cla;		% Equa��o da regi�o linear
		cl_lin=clxalpha_lin(alpha);					% Cl para um dado alpha segundo o ajuste linear
		alpha0_lin = fzero(clxalpha_lin,0);				% Alpha para o qual o cl � zero segundo o ajuste linear
		
		
		% ------------ Coeficientes considerando a curva n�o linear:
		clmax       = max(coefxalpha(:,2));						% Cl m�ximo do perfil
		alpha_clmax = coefxalpha( coefxalpha(:,2)==max(coefxalpha(:,2)) ,1 );	% Alpha onde ocorre o Cl m�ximo
		
		
		% C�lculo de Cl0 n�o linear
		if 0>=min(coefxalpha(:,1))
			i = find(coefxalpha(:,1) <=0,1,'last');
			k = find(coefxalpha(:,1) >=0,1,'first');
			if i==k
				cl0_nl = coefxalpha(i,2);
			else
				cl0_nl=interp1([coefxalpha(i,1), coefxalpha(k,1)],[coefxalpha(i,2), coefxalpha(k,2)],0);
			end
		else
			cl0_nl=cl0_lin;
			warning('Cl0 n�o linear n�o dipon�vel, utilizando o Cl0 linear')
		end
		
		
		
		% C�lculo de Cl n�o linear
		if alpha>=min(coefxalpha(:,1)) && alpha<=max(coefxalpha(:,1))
			i = find(coefxalpha(:,1) <=alpha,1,'last');
			k = find(coefxalpha(:,1) >=alpha,1,'first');
			if i==k
				cl_nl = coefxalpha(i,2);
			else
				cl_nl=interp1([coefxalpha(i,1), coefxalpha(k,1)],[coefxalpha(i,2), coefxalpha(k,2)],alpha);
			end
		else
			cl_nl=cl_lin;
			warning('Cl n�o linear n�o dipon�vel, utilizando o Cl linear')
		end
		
		
		% C�lculo do Cd m�nimo
		cdmin=min(coefxalpha(:,3));
		if strcmp(calccm,'calc_cm')==1
			% C�lculo do Cm
			i = find(coefxalpha(:,1) <=alpha_min,1,'last');
			k = find(coefxalpha(:,1) >=alpha_max,1,'first');
			cm=mean(coefxalpha(i:k,4));
		else
			cm=[];
		end
		
		
		
		
		
		
		
%% ================================================================================================================================================
%  ======================================================== LE_CURVAS ACELERADO ===================================================================
%  ================================================================================================================================================
	case false
		
		
		
		%% %%%%%%%%%% TRATAMENTO DA CURVA Cl por ALPHA %%%%%%%%%%%%%%%%%%%%%%%%%%%%
		pasta=[pwd,'\curvas_',perfil,'\'];				% Pasta com as polares
		arquivo=[pasta,perfil,'_Re',sprintf('%07d',Re),'.dat'];	% Arquivo da polar pro Reynolds dado
		
		
		% Se existe o arquivo da polar pro Reynolds dado, a curva cl x alpha vai ser a do pr�prio arquivo
		if exist(arquivo,'file')==2
			coefxalpha=load(arquivo);
			
			%---------------------------
			% Se n�o existir, o cl ser� interpolado entre as curvas com os Reynolds mais pr�ximos
		else
			lista=fopen([pasta,'/lista_Re.dat'],'r'); % Carrega o arquivo que lista todos os Reynolds dispon�veis
			Re_lista=cell2mat(textscan(lista,'%07.0f\n'));
			fclose(lista);
			
			%--------------------------- (Caso o Re seja maior do que o menor Reynolds dispon�vel)
			if Re>Re_lista(1)
                try
				Re2 = Re_lista(find(Re_lista<Re,1,'last'));	% V� qual � o arquivo com o Reynolds imediantamente menor (Re2)
                catch err
                    keyboard
                end
				arquivo1=[pasta,perfil,'_Re',sprintf('%07d',Re2),'.dat'];
				coefxalpha=load(arquivo1);
			else
				arquivo1=[pasta,perfil,'_Re',sprintf('%07d',Re_lista(1)),'.dat'];
				coefxalpha=load(arquivo1);
			end
		end
		
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%% %%%%%%%%%%%%%%%% C�LCULO DOS COEFICIENTES DO PERFIL %%%%%%%%%%%%%%%%%%%%
		
		
		
		% ------------ Coeficiente de sustenta��o segundo o ajuste linear:
		alpha_min = 0;							% Menor alpha considerado para fazer o ajuste da regi�o linear
		alpha_max = 8;							% Maior alpha considerado para fazer o ajuste da regi�o linear
		if Re<150000							% Para Reynolds menor que 150000 o perfil estola para �ngulos menores, ent�o ...
			alpha_min = 1;						% � necess�rio fazer essa corre��o, sen�o, o clapha e principalemente o cl0 podem dar  ...
			alpha_max = 5;						% valores absurdos .(� sempre bom usar a os plots para monitarar como est� sendo feito ajuste ...
		end									% linear e se o cl0 est� em aproximamente -11�)
		
		i = find(coefxalpha(:,1)<=alpha_min,1,'last');		% Define em qual indice est� o alpha mais pr�ximo do m�nimo
		k = find(coefxalpha(:,1)>=alpha_max,1,'first');		% e em qual est� o alpha mais pr�ximo do m�ximo
		
		[coef_cl]=polyfit(coefxalpha(i:k,1),coefxalpha(i:k,2),1); % Faz o ajuste linear do cl
		
		
		cla=coef_cl(1);							% Cl alpha do perfil [graus]
		cl0_lin=coef_cl(2);						% Cl para alpha=0 do perfil
		clxalpha_lin=@(alpha) cl0_lin + alpha*cla;		% Equa��o da regi�o linear
		cl_lin=clxalpha_lin(alpha);					% Cl para um dado alpha segundo o ajuste linear
		alpha0_lin = fzero(clxalpha_lin,0);				% Alpha para o qual o cl � zero segundo o ajuste linear
		
		
		% ------------ Coeficientes considerando a curva n�o linear:
		clmax       = max(coefxalpha(:,2));						% Cl m�ximo do perfil
		alpha_clmax = coefxalpha( coefxalpha(:,2)==max(coefxalpha(:,2)) ,1 );	% Alpha onde ocorre o Cl m�ximo
		
		
		% C�lculo de Cl0 n�o linear
		if 0>=min(coefxalpha(:,1))
			i = find(coefxalpha(:,1) <=0,1,'last');
			k = find(coefxalpha(:,1) >=0,1,'first');
			if i==k
				cl0_nl = coefxalpha(i,2);
			else
				cl0_nl=interp1([coefxalpha(i,1), coefxalpha(k,1)],[coefxalpha(i,2), coefxalpha(k,2)],0);
			end
		else
			cl0_nl=cl0_lin;
			warning('Cl0 n�o linear n�o dipon�vel, utilizando o Cl0 linear')
		end
		
		
		
		% C�lculo de Cl n�o linear
		if alpha>=min(coefxalpha(:,1)) && alpha<=max(coefxalpha(:,1))
			i = find(coefxalpha(:,1) <=alpha,1,'last');
			k = find(coefxalpha(:,1) >=alpha,1,'first');
			if i==k
				cl_nl = coefxalpha(i,2);
			else
				cl_nl=interp1([coefxalpha(i,1), coefxalpha(k,1)],[coefxalpha(i,2), coefxalpha(k,2)],alpha);
			end
		else
% 			cl_nl=cl_lin;
			if alpha>max(coefxalpha(:,1))
				cl_nl=coefxalpha(end,2);
			else alpha<min(coefxalpha(:,1));
				cl_nl=coefxalpha(1,2);
			end
			warning('Cl n�o linear n�o dipon�vel, utilizando o Cl linear')
		end
		
		
		% C�lculo do Cd m�nimo
		cdmin=min(coefxalpha(:,3));
		if strcmp(calccm,'calc_cm')==1
			% C�lculo do Cm
			i = find(coefxalpha(:,1) <=alpha_min,1,'last');
			k = find(coefxalpha(:,1) >=alpha_max,1,'first');
			cm=mean(coefxalpha(i:k,4));
		else
			cm=[];
		end
end















%% ================== Plot ================================================
% ---------------------------------------Plots para a le_curvas de Precis�o
% close all
% if exist(arquivo,'file')==2
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',[-12:0.5:12],clxalpha_lin(-12:0.5:12)); legend('Curva C_l x \alpha','Ajuste linear'); title(['Cl vs \alpha Re: ',num2str(Re),' - ',perfil]);grid minor
% else
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',coefxalpha1(:,1),coefxalpha1(:,2),coefxalpha2(:,1),coefxalpha2(:,2), [-12:0.5:12],clxalpha_lin(-12:0.5:12)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,2)) max(coefxalpha(:,2))]);
% 	textsup=['C_l x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_l x \alpha inferior: ',num2str(Re2)];
% 	legend('C_l x \alpha interpolada',textsup, textinf, 'Ajuste linear','Location','SouthEast'); grid minor;title(['Re: ',num2str(Re)])

% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,3),'*-',coefxalpha1(:,1),coefxalpha1(:,3),coefxalpha2(:,1),coefxalpha2(:,3)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,3)) max(coefxalpha(:,3))]);
% 	textsup=['C_d x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_d x \alpha inferior: ',num2str(Re2)];
% 	legend('C_d x \alpha interpolada',textsup, textinf,'Location','Northwest'); grid minor;title(['Cd vs \alpha Re: ',num2str(Re)])
% 
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,4),'*-',coefxalpha1(:,1),coefxalpha1(:,4),coefxalpha2(:,1),coefxalpha2(:,4)); hold on
% 	line([alpha alpha],[min(coefxalpha(:,4)) max(coefxalpha(:,4))]);
% 	textsup=['C_m x \alpha superior: ',num2str(Re1)];
% 	textinf=['C_m x \alpha inferior: ',num2str(Re2)];
% 	legend('C_m x \alpha interpolada',textsup, textinf,'Location','Northwest'); grid minor;title(['Cm vs \alpha Re: ',num2str(Re)])

% ---------------------------------------  Plots para a le_curvas Acelerada
% close all
% 	figure
% 	plot(coefxalpha(:,1),coefxalpha(:,2),'*-',[-12:0.5:12],clxalpha_lin(-12:0.5:12)); legend('Curva C_l x \alpha','Ajuste linear'); title(['Cl vs \alpha Re: ',num2str(Re),' - ',perfil]);grid minor

end

% toc