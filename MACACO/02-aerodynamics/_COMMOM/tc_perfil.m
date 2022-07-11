function [tc] = tc_perfil (perfil)
% Essa fun��o calcula a porcentagem da espessura do perfil em rela��o �
% corda (Vari�vel t/c ou thickness dos livros)

% A entrada da fun��o deve ser uma string como o nome do arquivo das
% coordenadas do perfil, sem colocar a extens�o ".dat".

%OBS1: O arquivo com as coordenadas do perfil n�o pode conter o nome do 
%perfil na primeira linha

%OBS2: Como padr�o do xfoil e do xflr5, o arquivo de coordenadas cont�m
%duas colunas. A primeira (coluna das abscissas) come�a em 1, decresce at� 
%um valor muito pr�ximo de zero, e volta a crescer at� se tornar 1 novamente.
%Essa estrutura deve ser mantida para o correto funcionamento do c�digo

%autor: Andr� Rezende

perfil = [perfil,'.dat'];
perf   = load(perfil);						% Carrega o arquivo do perfil

ind=1;										% Encontra onde come�a o intradorso e onde come�a o extradorso
while perf(ind,1)>perf(ind+1,1)
	ind=ind+1;
end

extra = flipud( perf(1:ind,:) );			% Define a matriz com as coordenadas do extradorso e do intradorso
intra = perf(ind+1:end,:);
extra(1,1) = 0; intra(1,1)=0;


% Para o c�lculo da espessura deve-se calcular a dist�ncia dos pontos do
% extradorso aos do intradorso, mas para isso, eles devem possuir as mesmas
% abscissas.

extra2=zeros(length(perf(:,1))-ind,2);		% A matriz extra2 s�o as coordenadas do extradorso utilizando a as abscissas do intradorso
for i=2:length(perf(:,1))-ind
	xe = find(extra(:,1)>=intra(i,1),1,'first');	% Encontra o �ndice da primeira abscissa de extradorso maior do que a do intradorso
	extra2(i,1) = intra(i,1);
	
	% Equa��o da reta para encontrar a ordenada de extra2
	m = ( extra(xe,2)-extra(xe-1,2) )/( extra(xe,1)-extra(xe-1,1)); 
	extra2(i,2) = m*( intra(i,1)-extra(xe-1,1) ) + extra(xe-1,2);
end

tc=max(extra2(:,2)-intra(:,2));				% Espessura do perfil

end

	