function [ ] = plotformat(varargin)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%							FORMATADOR DE GRÁFICOS						  %
	%						   André Rezende  Dessimoni						  %
	%					        andre.rdc@hotmail.com						  %
	%					UFU - UNIVERSIDADE FEDERAL DE UBERLÂNDIA			  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% Formatador de gráficos. Facilita a formatação e padronização de gráficos.
	% Uso:
	% 1) Formata a figura ativa
	% plotformat -opção_1 valor_1 -opção2 valor_2 -opção3 valor_3 ...
	%
	% 2) Formata a figura <fig>, onde <fig> é o número da figura.
	% plotformat <fig> -opção_1 valor_1 -opção2 valor_2 -opção3 valor_3 ...
	%
	% Obs.: Algumas opções não necessitam da declaração de um valor
	%
	% Opções				Descrição						Possíveis Valores					Valor padrão
	% ---------				-----------------------------	-----------------------------		-------------
	% -bgc					Background color				[r g b] ou 'w', 'k', 'g',...		w
	% -k					Background preto				-
	% -w					Background branco				-
	% -latex				Texto intepretado como latex	-									Desativado
	% -fontsize (-fsz)		Tamanho da fonte dos texto		Tamanho da fonte					14
	% -gridon				Ativa o grid principal			-									Desativado
	% -mgridon				Ativa o grid secundário			-									Desativado
	% -allgridon			Ativa os dois grids				-									Desativado
	% -ticks				Ativa os ticks secundários		-									Desativado
	% -boxoff				Desativa o box					-									Ativado
	% -axis					Muda o formato dos eixos		auto, equal, image, square, tight	
	% -axisgap				Gap entre as linhas e o eixo	0<=axisgap<=oo						0.05
	% -axisoff				Apaga eixos						-									Desativado
	% -nochangelines (-ncl)	Impede a formartação das linhas -									Desativado
	% -formatinorder (-fio)	Formata as linhas na ordem		cem, cme, * (Ver Obs. 2)			cem
	% -linstyles (-ls)		Formata os estilos de linha		-, --, -., etc (ver exemplo b)	
	% -linmarkers (-lm)		Formata os marcadores de linha  o, *, ^, etc (ver exemplo b)
	% -lincolors (-lc)		Formata as cores das linhas     k,w,r, etc (ver exemplo b)
	% -linwidth (-lw)		Formata a espessura das linhas										1
	% -render				Seleciona o render da figura    opengl, painters, zbuffer			painters (Ver http://matlab.izmiran.ru/help/techdoc/creating_plots/chprin22.html)
	%
	% Obs. 1: Se o intepretador dos textos for 'latex', deve-se obedecer às regras
	%	de formatação dessa linguagem, isso inclui cifrão(math mode) quando for
	%	usar letras	gregas, epeciais, ou '_'.
	%	ex.: >> xlabel('Coeficiente de sustentação (C_L)'), deve ficar:
	%		 >> xlabel('Coeficiente de sustentação ($C_L$)')
	%		 >> plotformat
	%	As vantagens desse intepretador são a tipografia e a possibilidade de
	%	escrever equações formatadas.
	%
	% Obs. 2 (opções do -formatinorder): 
	%	cem	 : cor -> estilo -> marcadores (varia todas as cores, depois varia novamente as cores com o próximo estilo, e por último varia os marcadores)
	%	cme	 :	cor -> marcadores -> estilo
	%   *	 : (cor 1, marcador 1, estilo 1) -> (cor 2, marcador 2, estilo 2) ->...-> (cor n, marcador n, estilo n)   (útil quando quer formatar cada linha separadamente)
	%         Ver Obs. b.3, nos exemplos abaixo!
	%
	% Exemplos
	% a) Formatar figura atual com todos os valores padrões:
	%	>> plotformat
	%
	% b) Formata as 3 linhas da figura atual, todas com a cor preta:
	%	>> plotformat -fio fio -ls '- -- none' -lm 'none none o' -lc 'k'
	%	Obs. b.1: A ordem dos valores inseridos formata as linhas na ordem em que foram plotadas.
	%	Obs. b.2: Caso exista mais de uma especificação, os argumentos devem estar entre aspas simples e separadas por espaço.
	%	Obs. b.3: Caso o número de argumentos seja menor que o número de linhas, as fortações começarão a se repetir. 
	%			  Então caso seja especificado apenas 1 argumento, todas as linhas serão formatadas com esse argumento,
	%			  como no caso do -lc acima.
	%
	% c) Formatar figura 3 com interpretador latex, gap de 10% dos limites máximos dos eixos, e evitando que sejam 
	%    feitas modificações nas linhas existentes:
	%	>> plotformat 3 -nochangelines -latex -axisgap 0.1
	% 


	
%% ===================================================================== %%
	
	% INICIO
	% ---------------------------------------------
	% Obtém o eixo e a figura
	if ~isempty(varargin)
		if isnumeric(str2double(num2str(varargin{1}))) && ~isnan(str2double(num2str(varargin{1}))) 
			fig = str2double(num2str(varargin{1}));
			f =findobj('Type','Figure', 'Number',fig);
		else
			f = gcf;
		end
	else
		f = gcf;	
	end
	figure(f)
	g = gca;

	
	% Define valores padrões
	cor					= 'w';
	latex_interpreter	= 0;
	font_size			= 14;
	grid_major			= 0;
	grid_minor			= 0;
	axis_format			= [];
	MinorTicks			= 0;
	box					= 1;
	changelines			= 1;
	axis_gap_fac		= 0.05;
	axisoff				= 0;
	lin_format_order	= 'cem';
	linstyles			= [];
	linmarkers			= [];
	lincolors			= [];
	linwidth			= 1;
	renderer			= 'painters';
	
	% Configura as opções
    i=1;
	while i<=length(varargin)
		switch varargin{i}
			case '-bgc'
				cor = varargin{i+1}; i=i+2;
			case '-k'
				cor = 'k'; i=i+1;
			case '-w'
				cor = 'w'; i=i+1;
			case '-latex'
				latex_interpreter = 1; i=i+1;
			case {'-formatinorder','-fio'}
				lin_format_order = varargin{i+1}; i = i+2;
			case '*'
				lin_format_order = '*'; i=i+1;
			case {'-fontsize', '-fsz'}
				font_size = str2double(num2str(varargin{i+1})); i=i+2;
			case {'-linwidth', '-lw'} 
				linwidth =  str2double(num2str(varargin{i+1})); i=i+2;
			case {'-linmarkers', '-lm'}
				linmarkers = strsplit(varargin{i+1}); i = i+2;
			case {'-linstyles', '-ls'}
				linstyles = strsplit(varargin{i+1}); i = i+2;
			case {'-lincolors', '-lc'}
				lincolors = strsplit(varargin{i+1}); i = i+2;
			case '-gridon'
				grid_major = 1; i=i+1;
			case '-mgridon'
				grid_minor = 1; i=i+1;
			case '-allgridon'
				grid_major = 1;
				grid_minor = 1; i=i+1;
			case '-ticks'
				MinorTicks = 1; i=i+1;
			case '-boxoff'
				box = 0; i=i+1;
			case '-axis'
				axis_format = varargin{i+1}; i = i+2;
			case '-axisoff'
				axisoff = 1; i=i+1;
			case '-axisgap'
				axis_gap_fac = str2double(num2str(varargin{i+1})); i=i+2;
			case {'-nochangelines', '-ncl'}
				changelines = 0; i=i+1;
			case '-render'
				renderer = varargin{i+1}; i = i+2;
			otherwise
				i=i+1;
		end
	end

	
	%% ===================================================================== %%

	% CORES
	% ---------------------------------------------
	% Cor do fundo
	f.Color		= cor;
	g.Color		= cor;
	
	
	% Cor das fontes e grids
	% Confere se a cor é escura (LightDark<123) ou clara
	LightDark = ((g.Color(1)*255 * 299) + (g.Color(2)*255 * 587) + (g.Color(3)*255 * 114)) /(1000);
	if LightDark<123
		g.XColor			= 'w';
		g.YColor			= 'w';
		g.ZColor			= 'w';
		g.Title.Color		= 'w';
	else
		g.XColor			= 'k';
		g.YColor			= 'k';
		g.ZColor			= 'k';
		g.Title.Color		= 'k';
	end
	
	% FONTES E TEXTOS
	% ---------------------------------------------
	% Interpretador dos textos
	if latex_interpreter 
		g.XLabel.Interpreter	= 'latex';
		g.YLabel.Interpreter	= 'latex';
		g.ZLabel.Interpreter	= 'latex';
		g.Title.Interpreter		= 'latex';
		g.TickLabelInterpreter	= 'latex';
	else
		g.XLabel.Interpreter	= 'none';
		g.YLabel.Interpreter	= 'none';
		g.ZLabel.Interpreter	= 'none';
		g.Title.Interpreter		= 'none';
		g.TickLabelInterpreter	= 'none';
	end
	
	
	% Tamanho das fontes
	g.XLabel.FontSize		= font_size;
	g.YLabel.FontSize		= font_size;
	g.ZLabel.FontSize		= font_size;
	g.Title.FontSize		= font_size;
	
	
	% FORMATAÇÃO DAS LINHAS
	% ---------------------------------------------
	if changelines
		lin = findobj(gca,'Type','line');
		lin = flipud(lin);
		nlins = length(lin);
		
		% Espessura das linhas
		espessura = linwidth;
		
		if isempty(lincolors)
			if LightDark<123 % Paleta clara
				cores = [	255, 255, 255 % branco
							203, 67, 53   % vermelho
							52, 152, 219  % azul
							40, 180, 99   % verde
							241, 196, 15  % amarelo
							108, 52, 131  % roxo
							]/255;
			else %Paleta escura
				cores = [	0,   0,  0    % preto
							231, 76, 60   % vermelho
							93, 173,  226 % azul
							88, 214,  141 % verde
							241, 196, 15  % amarelo
							125, 60, 152  % roxo
							]/255;
			end
			ncores = size(cores,1);
			N = fix(nlins/ncores);
			cores = repmat(cores,N+1,1);
		else
			cores = lincolors;
			ncores = size(cores,2);
			N = fix(nlins/ncores);
			cores = repmat(cores,1,N+1);
		end
		
		if isempty(linmarkers)
 			markers = {'none','o','+','*','.','x','s','d','^','v','>','<','p','h'};
		else
			markers = linmarkers;
		end
		nmarkers = size(markers,2);
		N = fix(nlins/nmarkers);
		markers = repmat(markers,1,N+1);
			
		if isempty(linstyles)
			styles = {'-', '--', ':', '-.'};
		else
			styles = linstyles;
		end
		nstyles = size(styles,2);
		N = fix(nlins/nstyles);
		styles = repmat(styles,1,N+1);
		
		
		
		
		cor_n	 = 0;
		style_n  = 1;
		marker_n = 1;
		for ii=1:length(lin)
			switch lin_format_order
				case 'cem' % cor -> estilo -> marcador
					cor_n = cor_n+1;
					if cor_n>ncores
						cor_n = 1;
						style_n = style_n+1;
					end
					if style_n>nstyles
						style_n = 1;
						marker_n = marker_n + 1;
					end
					if marker_n> nmarkers
						marker_n = 1;
					end
				case 'cme' % cor -> marcador -> estilo 
					cor_n = cor_n+1;
					if cor_n>ncores
						cor_n = 1;
						marker_n = marker_n + 1;
					end
					if marker_n> nmarkers
						marker_n = 1;
						style_n = style_n+1;
					end
					if style_n>nstyles
						style_n = 1;
					end
				case '*'
					cor_n	 = ii;
					style_n  = ii;
					marker_n = ii;	
			end
				
				lin(ii).LineWidth = espessura;
				if size(cores,2) == 3 && size(cores,1)>1 % se tiver sido especificado código rgb
					lin(ii).Color	= cores(cor_n,:);
				else
					lin(ii).Color	= cores{cor_n};
				end
				lin(ii).LineStyle	= styles{style_n};
				lin(ii).Marker		= markers{marker_n};
			end

		end
		
		
	
	
		
	
	% EIXOS, GRID, TICKS e BOX
	% ---------------------------------------------
	% Formato do eixo
	axis image
	if axis_gap_fac~=0
		xl = xlim;
		yl = ylim;
		xl(1) = xl(1) - axis_gap_fac*abs(xl(2)-xl(1));
		xl(2) = xl(2) + axis_gap_fac*abs(xl(2)-xl(1));
		yl(1) = yl(1) - axis_gap_fac*abs(yl(2)-yl(1));
		yl(2) = yl(2) + axis_gap_fac*abs(yl(2)-yl(1));
	end
	axis square
	axis([xl yl])
	
	if ~isempty(axis_format)
		axis(axis_format)
	end
	
	% Grid
	if grid_major
		g.XGrid	= 'on';
		g.YGrid	= 'on';
		g.ZGrid	= 'on';
	else
		g.XGrid	= 'off';
		g.YGrid	= 'off';
		g.ZGrid	= 'off';
	end
	if grid_minor
		g.XMinorGrid = 'on';
		g.YMinorGrid = 'on';
		g.ZMinorGrid = 'on';
	else
		g.XMinorGrid = 'off';
		g.YMinorGrid = 'off';
		g.ZMinorGrid = 'off';
	end
	
	
	% Grid alpha (Deixa a linha do grid mais escura para aparecer melhor quando passar pro word ou latex, o default é 0.15)
	g.GridAlpha	= 0.3;
	
	% MinorTicks
	if MinorTicks
		g.XMinorTick = 'on';
		g.YMinorTick = 'on';
		g.ZMinorTick = 'on';
	else
		g.XMinorTick = 'off';
		g.YMinorTick = 'off';
		g.ZMinorTick = 'off';
	end
	
	% Box
	if box
		g.Box = 'on';
	else
		g.Box = 'off';
	end
	
	% Esconde eixos
	if axisoff
		axis off
	else
		axis on
	end
	
	% Troca o renderizador
	f.Renderer = renderer;
	
end