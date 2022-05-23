%Rotina responsável por plotar o perfil teste
%autor: André Rezende
global perfil_base coefs dadosdat;
figure(1);


%% --- PLOTA O PERFIL BASE --- %%
% p_baset=[perfil_base,'.dat'];
% % Verfica se existe o arquivo do perfil base (lembrando que o arquivo .dat  não pode conter o nome do perfil na primeira linha)
% if exist(p_baset,'file')~=2
% 	texto=['Não foi possível econtrar o arquivo "',p_baset,'" com as coordenadas do perfil na pasta \parametrização. Por favor, insira tal arquivo na pasta'];
% 	error(texto);
% end

% subplot(2,1,1)

plot(dadosdat(:,1),dadosdat(:,2),'b--');
hold on


%% --- PLOTA O PERFIL TESTE --- %%

%     hold on
    plot(pto_c_a(:,1),pto_c_a(:,2),'k.','MarkerSize',20);			%plota os pontos de controle da linha de cambra média
    plot(pto_c_f(:,1),pto_c_f(:,2),'m.','MarkerSize',20);			%plota os pontos de controle da linha de cambra média
    plot(pto_e_a(:,1),pto_e_a(:,2),'g.','MarkerSize',20);			%plota os pontos de controle da linha de espessura
    plot(pto_e_f(:,1),pto_e_f(:,2),'y.','MarkerSize',20);			%plota os pontos de controle da linha de espessura
%
%     %plot(lin_cambra(:,1),lin_cambra(:,2),'b*','LineWidth',0.5);	%plota a linha de cambra
%     plot(lin_cambra_a(:,1),lin_cambra_a(:,2),'k-.','LineWidth',2);    %plota a linha de cambra do bordo de ataque
%     plot(lin_cambra_f(:,1),lin_cambra_f(:,2),'m-.','LineWidth',2);    %plota a linha de cambra do bordo de fuga
    plot(lin_esp_a(:,1),lin_esp_a(:,2),'g-.','LineWidth',1);		%plota a linha de espessura de ataque
    plot(lin_esp_f(:,1),lin_esp_f(:,2),'y-.','LineWidth',1);		%plota a linha de espessura de fuga
    plot(Cx(:),Cy(:),'k--','LineWidth',1)					%plota a linha de cambra corrigida


plot(Pex,Pey,'r-','LineWidth',2); hold on						%plota o extradorso
plot(Pix,Piy,'r-','LineWidth',2)							%plota o intradorso

axis equal
axis([-0.05 1 min(dadosdat(:,2))-.05 max(dadosdat(:,2))+.05]);
grid on;grid minor;

%% --- PLOTA AS ESTATÍSTICAS --- %%

% subplot(2,1,2)
% plotyy(coefs(:,1),'r', coefs(:,2),'b'); legend('max(Cl)','mean(Cd)','Location','NorthWest'); grid on
%axis([1-eps length(coefs(:,1)) 1.5 2.6])