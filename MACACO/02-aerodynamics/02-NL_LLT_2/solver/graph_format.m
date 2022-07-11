function [ ] = graph_format( cor)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%							FORMATADOR DE GRÁFICOS						  %
	%						   André Rezende  Dessimoni						  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% Obs.: Se o intepretador dos textos for 'latex', deve-se obedecer às regras
	%	de formatação dessa linguagem, isso inclui cifrão(math mode) quando for
	%	usar letras	gregas, epeciais, ou '_' .
	%	ex.: xlabel('Coeficiente de sustentação (C_L)'), deve ficar:
	%		 xlabel('Coeficiente de sustentação ($C_L$)')
	%		 graph_format()
	%	As vantagens desse intepretador são a tipografia e a possibilidade de
	%	escrever equações formatadas.
	
	
	g = gca;
	f = gcf;
	% Posicionamento automático
	% 	p41 = [685 32 681 283];
	% 	p32 = [2 32 681 290];
	% 	p43 = [2 408 681 276];
	% 	p44 = [685 401 681 283];
	% 	p4 = [p41; p32; p43; p44];
	% 	if length(fh)<=4
	% 		n = f.Number;
	% 		f.Position = p4(n,:);
	% 	end
	
	
	% Cor do fundo
	f.Color		= cor;
	g.Color		= cor;
	
	
	
	
	% Interpretador dos textos
	% 	g.XLabel.Interpreter	= 'latex';
	% 	g.YLabel.Interpreter	= 'latex';
	% 	g.ZLabel.Interpreter	= 'latex';
	% 	g.Title.Interpreter		= 'latex';
	% 	g.TickLabelInterpreter	= 'latex';
	
	% Tamanho das fontes
	g.XLabel.FontSize		= 14;
	g.YLabel.FontSize		= 14;
	g.ZLabel.FontSize		= 14;
	g.Title.FontSize		= 14;
	
	% Cor das fontes e grids
	if strcmp(cor,'k')
		g.XColor			= 'w';
		g.YColor			= 'w';
		g.ZColor			= 'w';
	end
	
	% Espessura das linhas
	espessura = 1;
	lin = findobj(gca,'Type','line');
	for ii=1:length(lin)
		lin(ii).LineWidth = espessura;
	end
	
	
	
	% Grid
	g.XGrid					= 'on';
	g.YGrid					= 'on';
	g.ZGrid					= 'on';
	
	g.XMinorGrid			= 'on';
	g.YMinorGrid			= 'on';
	g.ZMinorGrid			= 'on';
	
	% Grid alpha (Deixa a linha do grid mais escura para aparecer melhor quando passar pro word ou latex, o default é 0.15)
	g.GridAlpha				= 0.3;
	
	% MinorTicks
	g.XMinorTick			= 'on';
	g.YMinorTick			= 'on';
	g.ZMinorTick			= 'on';
	
	% Box
	g.Box					= 'on';
end