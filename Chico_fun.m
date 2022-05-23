function [penal] = Chico_fun(abrir_dat_input,qual_input,Re_input,par)
%% INPUTS
qual = qual_input;
Re = Re_input;                            
aoa = [-6.5:0.5:7.5 8:0.25:19];
%aoa = [-15:0.5:17];
abrir_dat = abrir_dat_input;
salvar_mat = ['Perfil_' num2str(qual)];

parametrizar = 0;
if parametrizar 
    esp_vertical    = par(1);
    esp_horizontal  = par(2);
    camb_vertical   = par(3);
    camb_horizontal = par(4);
end

paineis = 150;
iteracoes = 100;

%% OPCOES
from_middle = 1;
middle = 0;

plotar_xfoil = 0;
%% 
global limites_linear
limites_linear = [1 5.5];
if from_middle
    initial_aoa_pos = find(aoa == middle);
    ordem_aoa = aoa(initial_aoa_pos:end);
    ordem_aoa(end+1:length(aoa)) = aoa(initial_aoa_pos-1:-1:1);
else
    ordem_aoa = aoa;
end
perfil = Airfoil;
perfil.name = erase(abrir_dat,'.dat');
cd Perfis_dat
perfil.xy = load(abrir_dat);
cd ..
for n = 1:length(Re)
    nome_ordem = ['X' num2str(qual) '/ordens' num2str(qual) '.txt'];
    comando = fopen(nome_ordem,'w');
    fprintf(comando,'\n');
    fprintf(comando,'load ../Perfis_dat/%s\n',abrir_dat);
    fprintf(comando,'%s\n',erase(abrir_dat,'.dat'));
    if ~plotar_xfoil
        fprintf(comando,'plop\n');
        fprintf(comando,'g\n');
        fprintf(comando,'\n');
    end
    if parametrizar
    fprintf(comando,'gdes\n');
    fprintf(comando,'tset\n');
    fprintf(comando,'%f\n',esp_vertical);
    fprintf(comando,'%f\n',camb_vertical);
    fprintf(comando,'high\n');
    fprintf(comando,'%f\n',esp_horizontal);
    fprintf(comando,'%f\n',camb_horizontal);
    fprintf(comando,'x\n');
    fprintf(comando,'\n');
    end
    fprintf(comando,'ppar\n');
    fprintf(comando,'n %d\n',paineis);
    fprintf(comando,'\n');
    fprintf(comando,'\n');

    fprintf(comando,'oper\n');
    fprintf(comando,'v\n');
    fprintf(comando,'%d\n',Re(n));
    fprintf(comando,'iter %d\n',iteracoes);
    fprintf(comando,'p\n');
    fprintf(comando,'provisorio%d.nfo\n',qual);
    fprintf(comando,'\n');
    for i = 1:length(ordem_aoa)
        fprintf(comando,'a %g\n',ordem_aoa(i));
    end
    fprintf(comando,'p\n');
    fprintf(comando,'\n');
    fprintf(comando,'quit\n');
    
    switch qual
        case 1
            cd X1
            delete provisorio1.nfo
            system('start /min mataxfoil1.bat'); 
            !runner1.bat >NUL
            cd ..
        case 2
            cd X2
            delete provisorio2.nfo
            system('start /min mataxfoil2.bat'); 
            !runner2.bat >NUL
            cd ..
        case 3
            cd X3
            delete provisorio3.nfo
            system('start /min mataxfoil3.bat'); 
            !runner3.bat >NUL
            cd ..
        case 4
            cd X4
            delete provisorio4.nfo
            system('start /min mataxfoil4.bat');
            !runner4.bat >NUL
            cd ..
        case 5
            cd X5
            delete provisorio5.nfo
            system('start /min mataxfoil5.bat'); 
            !runner5.bat >NUL
            cd ..
        case 6
            cd X6
            delete provisorio6.nfo
            system('start /min mataxfoil6.bat'); 
            !runner6.bat >NUL
            cd ..
        case 7
            cd X7
            delete provisorio7.nfo
            system('start /min mataxfoil7.bat'); 
            !runner7.bat >NUL
            cd ..
        case 8
            cd X8
            delete provisorio8.nfo
            system('start /min mataxfoil8.bat'); 
            !runner8.bat >NUL
            cd ..       
    end

    
    perfil.pol(n) = Airfoil_Polar;
    
    nome_provisorio = ['X' num2str(qual) '/provisorio' num2str(qual) '.nfo'];
    identidade = fopen(nome_provisorio);

    for i=1:7
        [~] = fgetl(identidade);
    end

    line = fgetl(identidade);
    info = strsplit(line);
    perfil.pol(n).conf.xtrf_top = info(4);
    perfil.pol(n).conf.xtrf_bot = info(6);

    line = fgetl(identidade);
    info = strsplit(line);
    perfil.pol(n).Re = str2double([info{7:9}]);
    perfil.pol(n).conf.mach = info(4);
    perfil.pol(n).conf.ncrit = info(12);

    perfil.pol(n).conf.xhinge = [];
    perfil.pol(n).conf.yhinge = [];
    perfil.pol(n).conf.defex_hinge = [];

    for i=10:12
        [~] = fgetl(identidade);
    end
    
    j=1;
    line    = fgetl(identidade);
    
    while line~=-1
        [data,~,~,~] = sscanf(line, '%f');

        reorg.alpha(j)	= data(1);
        reorg.cl(j)		= data(2);
        reorg.cd(j)		= data(3);
        reorg.cdp(j)	= data(4);
        reorg.cm(j)		= data(5);
        reorg.Top_Xtr(j)= data(6);
        reorg.Bot_Xtr(j)= data(7);

        j=j+1;
        line    = fgetl(identidade);
    end
    where_slip = find(reorg.alpha < reorg.alpha(1),1);
    
    perfil.pol(n).alpha	= [reorg.alpha(end:-1:where_slip) reorg.alpha(1:where_slip-1)];
    perfil.pol(n).cl		= [reorg.cl(end:-1:where_slip) reorg.cl(1:where_slip-1)];
    perfil.pol(n).cd		= [reorg.cd(end:-1:where_slip) reorg.cd(1:where_slip-1)];
    perfil.pol(n).cdp	= [reorg.cdp(end:-1:where_slip) reorg.cdp(1:where_slip-1)];
    perfil.pol(n).cm		= [reorg.cm(end:-1:where_slip) reorg.cm(1:where_slip-1)];
    perfil.pol(n).Top_Xtr= [reorg.Top_Xtr(end:-1:where_slip) reorg.Top_Xtr(1:where_slip-1)];
    perfil.pol(n).Bot_Xtr= [reorg.Bot_Xtr(end:-1:where_slip) reorg.Bot_Xtr(1:where_slip-1)];
    
    clear reorg
    
    fclose all;
    if length(perfil.pol(n).cl) < 0.85*length(aoa)
        penal = 1;
    else 
        penal = 0;
        perfil.UpdateCoeff;
    end
end

mat_name_aux = matlab.lang.makeValidName(salvar_mat);
eval([mat_name_aux  ' = perfil;'])
save(['Perfis_salvos/' matlab.lang.makeValidName(salvar_mat)],mat_name_aux);
end