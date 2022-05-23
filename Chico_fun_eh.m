function Chico_fun_eh(abrir_dat_input,salvar_mat_input,Re_input)
%% INPUTS
qual = 1;
Re = Re_input;                            
aoa = -14:0.5:9;
abrir_dat = abrir_dat_input;
salvar_mat = salvar_mat_input;

% parametrizar = 1;
% if parametrizar 
%     esp_vertical    = par(1);
%     esp_horizontal  = par(2);
%     camb_vertical   = par(3);
%     camb_horizontal = par(4);
% end

paineis = 150;
iteracoes = 100;

%% OPCOES
from_middle = 1;
middle = 0;

plotar_xfoil = 0;
%% 
global limites_linear
limites_linear = [-5 0];

if from_middle
    initial_aoa_pos = find(aoa == middle);
    ordem_aoa = aoa(initial_aoa_pos:-1:1);
    ordem_aoa(end+1:length(aoa)) = aoa(initial_aoa_pos+1:end);
else
    ordem_aoa = aoa;
end

caso_nao = [2e3 4e3 6e3];
perfil = Airfoil;
perfil.name = erase(abrir_dat,'.dat');
cd Perfis_dat
perfil.xy = load(abrir_dat);
cd ..
n = 1;
penal = 0;
naofoi = 0;
while n <= length(Re)
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
%     if parametrizar
%     fprintf(comando,'gdes\n');
%     fprintf(comando,'tset\n');
%     fprintf(comando,'%f\n',esp_vertical);
%     fprintf(comando,'%f\n',camb_vertical);
%     fprintf(comando,'high\n');
%     fprintf(comando,'%f\n',esp_horizontal);
%     fprintf(comando,'%f\n',camb_horizontal);
%     fprintf(comando,'x\n');
%     fprintf(comando,'\n');
%     end
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
    end

    perfil.pol(n-naofoi) = Airfoil_Polar;
    
    nome_provisorio = ['X' num2str(qual) '/provisorio' num2str(qual) '.nfo'];
    identidade = fopen(nome_provisorio);

    for i=1:7
        [~] = fgetl(identidade);
    end

    line = fgetl(identidade);
    info = strsplit(line);
    perfil.pol(n-naofoi).conf.xtrf_top = info(4);
    perfil.pol(n-naofoi).conf.xtrf_bot = info(6);

    line = fgetl(identidade);
    info = strsplit(line);
    perfil.pol(n-naofoi).Re = str2double([info{7:9}]);
    perfil.pol(n-naofoi).conf.mach = info(4);
    perfil.pol(n-naofoi).conf.ncrit = info(12);

    perfil.pol(n-naofoi).conf.xhinge = [];
    perfil.pol(n-naofoi).conf.yhinge = [];
    perfil.pol(n-naofoi).conf.defex_hinge = [];

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
    where_slip = find(reorg.alpha > reorg.alpha(1),1);
    
    perfil.pol(n-naofoi).alpha	    = [reorg.alpha(where_slip-1:-1:1) reorg.alpha(where_slip:end)];
    perfil.pol(n-naofoi).cl		= [reorg.cl(where_slip-1:-1:1) reorg.cl(where_slip:end)];
    perfil.pol(n-naofoi).cd		= [reorg.cd(where_slip-1:-1:1) reorg.cd(where_slip:end)];
    perfil.pol(n-naofoi).cdp	    = [reorg.cdp(where_slip-1:-1:1) reorg.cdp(where_slip:end)];
    perfil.pol(n-naofoi).cm		= [reorg.cm(where_slip-1:-1:1) reorg.cm(where_slip:end)];
    perfil.pol(n-naofoi).Top_Xtr   = [reorg.Top_Xtr(where_slip-1:-1:1) reorg.Top_Xtr(where_slip:end)];
    perfil.pol(n-naofoi).Bot_Xtr   = [reorg.Bot_Xtr(where_slip-1:-1:1) reorg.Bot_Xtr(where_slip:end)];
    
    clear reorg
    
    fclose all;
    if length(perfil.pol(n-naofoi).cl) < 0.86*length(aoa)
        penal = penal + 1;
        if penal <= 3
            Re(n) = Re(n) + caso_nao(penal);
        else
            penal = 0;
            n = n+1; 
            naofoi = naofoi+1;
        end
    else 
        penal = 0;
        perfil.UpdateCoeff;
        n = n+1;
    end
end

mat_name_aux = matlab.lang.makeValidName(salvar_mat);
eval([mat_name_aux  ' = perfil;'])
save(['Perfis_salvos/' matlab.lang.makeValidName(salvar_mat)],mat_name_aux);
end