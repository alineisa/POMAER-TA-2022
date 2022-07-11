function [ beta ] = SweepTransfer( C1, C2, DY, p, q, alpha  )
%{

Funcao que transfere o enflechamento de uma linha de referencia para outra

C1: Corda no inicio do painel
C2: Corda no final do painel
DY: Envergadura do painel
p:  Porcentagem da corda de referencia (0: LE; 1:TE)
q:	Porcentagem para onde o enflechamento vai ser transferido
alpha: Enflechamento de referência (linha p) [deg]
beta : Enflechamento na linha q [deg]

Exemplo:
Calcular enflechamento 25% das cordas de um painel com de dimensões  0.5 
   na raiz, 0.25 na ponta, 4 de envergadura, e 0° de enflechamento no bordo
   de fuga:

beta = SweepTransfer (0.50, ... % C1:    Corda na raiz  do painel
                      0.25, ... % C2:    Corda na ponta do painel
                      4.00, ... % DY:    Envergadura do painel
                      1.00, ... % p:     Porcentagem das cordas no enflechamento de referencia (1: TE)
                      0.25, ... % q:     Porcentagem das cordas onde sera calculado o novo enflechamento
                      0.00)     % alpha: Angulo de enflechamento na posicao p
%}

beta = atand( tand(alpha) + (p-q)*(C1-C2)/DY );



% Plot para validação
% close all
% figure(1); hold on
% t1 = -DY*tand(alpha) - p*C2;
% t2 = t1-C2;
% line([0 DY],[-C1*q t1-C2*q],[1 1],'Color','b','LineWidth',4)
% line([0 DY],[-C1*p t1-C2*p],[1 1],'Color','r','LineWidth',4)
% fill([0 DY DY 0],[0 t1 t2 -C1],'w')

end

