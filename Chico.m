clear all; close all; clc; fclose all;
%% INPUTS
qual = 2;
Re = [4e5];                            
aoa = -8:0.5:15;
abrir_dat = 'WTU_01.dat';
salvar_mat = ['Perfil_' num2str(qual)];

camb_vertical = 0.04;
camb_horizontal = 0.32;
esp_vertical = 0.13;
esp_horizontal = 0.25;

paineis = 120;
iteracoes = 80;
%% OPCOES
from_middle = 1;
middle = 0;

%% 
global limites_linear
limites_linear = [0 4];
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
    fprintf(comando,'gdes\n');
    fprintf(comando,'tset\n');
    fprintf(comando,'%f\n',esp_vertical);
    fprintf(comando,'%f\n',camb_vertical);
    fprintf(comando,'high\n');
    fprintf(comando,'%f\n',esp_horizontal);
    fprintf(comando,'%f\n',camb_horizontal);
    fprintf(comando,'x\n');
    fprintf(comando,'\n');
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
    
    switch qual
        case 1
            cd X1
            delete provisorio1.nfo
            system('start /min mataxfoil1.bat') 
            !runner1.bat >NUL
            cd ..
        case 2
            cd X2
            delete provisorio2.nfo
            system('start /min mataxfoil2.bat') 
            !runner2.bat 
            cd ..
        case 3
            cd X3
            delete provisorio3.nfo
            system('start /min mataxfoil3.bat') 
            !runner3.bat >NUL
            cd ..
        case 4
            cd X4
            delete provisorio4.nfo
            system('start /min mataxfoil4.bat') 
            !runner4.bat >NUL
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
    perfil.UpdateCoeff;
    
    fclose all;
end

mat_name_aux = matlab.lang.makeValidName(salvar_mat);
eval([mat_name_aux  ' = perfil']);
handles.mat_name.String = salvar_mat;
save(['Perfis_salvos/' matlab.lang.makeValidName(salvar_mat)],mat_name_aux);
