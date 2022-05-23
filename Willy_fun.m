function [penalidade] = Willy_fun(perfil,geo,flc)
perfis = {'WTU_01.dat' 'WTU_01.dat' 'MH84.dat'};
mi			= 1.812e-5;
flc.Voo     = 11.1;

penalidade = 0;
for i = 1:length(perfis)
    Re =(((geo.LiftingSurface.c(2,i)+0.02)*flc.rho*flc.Voo))/mi;
    par = [perfil.tv(i) perfil.th(i) perfil.cv(i) perfil.ch(i)];
    penal(i) = Chico_fun(perfis{i},i,Re,par);
end
for i = 1:length(penal)
    if penal(i)
        penalidade = 1;
        break
    end
end
end