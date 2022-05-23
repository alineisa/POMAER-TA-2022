function [ard,geo] = estolp(geo, flc, sim)
%% Cálculo do estol por meio do método da seção crítica
%ESTOL Summary of this function goes here
%   Calculo do alha estol (ard.alpha_estol), a deflexao maxima do profundor
%   (ard.deltae) e alguns parametros aerodinamicos da geometria
%    Autor: Vitor José Meyer Maffei & Thales Feitosa Ferreira 


%% INICIALIZACAO
deflexao0 = geo.LiftingSurface.incidence(2);

sim.dist = 1;
results = VLManda(geo, flc, sim, 0, '-LiftingSurfaces');

%% ESTOL EH
correcao = -0.03;        % Valor de Cl como margem de segurança (associado a incerteza do XFOIL)
superficies = [1 2];     % Quais as Lifting Surfaces analisadas no estol
n_super = length(superficies);


caso = 'min';           % Encontrar o 'max' ou o 'min'
                        % Caso max, passo e correcao deve ser positivo
                        % Caso min, passo e correcao deve ser negativo
                        
 AoA.inicial = -10;      % Deflexão inicial 
 AoA.final   = -20;
 AoA.passo   = -1;
 AoA.fila = AoA.inicial:AoA.passo:AoA.final;

%% CONDIÇÕES DE VOO
cond = flc;

%% Cl_max de cada perfil
n_Re = zeros(n_super,1);
Re   = zeros(n_super,3);
pos_Re = zeros(n_super,3);
clmax  = zeros(n_super,3);
clmin  = zeros(n_super,3);
n_limite =  zeros(n_super,3);
limite = zeros(n_super,60);

for i = 1:n_super 
    n_Re(i) = (geo.LiftingSurface.section_num(i) + 1);
    Re(i,1:n_Re(i)) = (cond.Voo.*cond.rho.*geo.LiftingSurface.c(i,1:n_Re(i)))./cond.visc;
    for j = 1:n_Re(i)
        
        perfil = ImportObj(seleciona_perfil(geo.LiftingSurface(1).perfil(i,j)));
        
        pos_Re(i,j) = find([perfil.coef.Re]>=Re(i,j),1,'first');
        clmax(i,j)  = perfil.coef(pos_Re(i,j)).clmax;
        clmax(i,j)  = clmax(i,j) - correcao;

        clmin(i,j)  = perfil.coef(pos_Re(i,j)).clmin;
        clmin(i,j)  = clmin(i,j) - correcao;      

    end    
    n_limite(i) = length(results(i).Yb);
    switch caso
        case 'max'
            limite(i,.5*n_limite(i)+1:n_limite(i)) = interp1(geo.LiftingSurface.b(i,1:n_Re(i)),clmax(i,1:n_Re(i)),results(i).Yb(0.5*end+1:end));
        case 'min'
            limite(i,.5*n_limite(i)+1:n_limite(i)) = interp1(geo.LiftingSurface.b(i,1:n_Re(i)),clmin(i,1:n_Re(i)),results(i).Yb(0.5*end+1:end));
    end
    limite(i,1:.5*n_limite(i)) = flip(limite(i,.5*n_limite(i)+1:n_limite(i)));
    
%     subplot(n_super,1,i)
%     plot(results(i).Yb,limite(i,1:n_limite(i)));
%     grid on; hold on;
end

%% LOOP
estolou(1:n_super) = false;
alfa_estol(1:n_super) = AoA.final;

continuar = true; k = 1;
while continuar 
   geo.LiftingSurface.incidence(2) = AoA.fila(k);
  
   results = VLManda(geo, cond, sim, 0, '-LiftingSurfaces');

    
    for i = 1:n_super
        diff = limite(i,1:n_limite(i)) - results(i).Loads.cl;
        switch caso
            case 'max'
                if min(diff)<=0 && ~estolou(i)
                    estolou(i) = true; 
                    alfa_estol(i) = cond.aoa;
                    fprintf('Estol na asa %d com %4.1f\n',i,AoA.fila(k))

                    % Caso queira parar no primeiro estol, não continuar
                    % continuar = false
                    
                    % PLOT
                    %subplot(n_super,1,i)                    
                    %plot(results(i).Yb,results(i).Loads.cl);
                end  
                
            case 'min'
                if max(diff)>=0 && ~estolou(2)
                    estolou(i) = true; 
                    alfa_estol(i) = AoA.fila(k);
                    fprintf('Estol na asa %d com %4.1f\n',i,AoA.fila(k))
                    
                    % Caso queira parar no primeiro estol, não continuar
                    continuar = false;
                    
                    % PLOT
%                     subplot(n_super,1,i)
%                     plot(results(i).Yb,results(i).Loads.cl);
                end  
        end
        clearvars diff
    end
    
    k = k+1;
    
    if isempty(find(estolou == 0,1)) || k > length(AoA.fila) 
        continuar = false;
    end

end
ard.estoleh = alfa_estol(2); 

%% INPUT ASA
geo.LiftingSurface.incidence(2) = ard.estoleh;
correcao = 0.1;        % Valor de Cl como margem de segurança (associado a incerteza do XFOIL)
superficies = 1;     % Quais as Lifting Surfaces analisadas no estol
n_super = length(superficies);


caso = 'max';           % Encontrar o 'max' ou o 'min'
                        % Caso max, passo e correcao deve ser positivo
                        % Caso min, passo e correcao deve ser negativo
                        
 AoA.inicial = 14;
 AoA.final   = 26;
 AoA.passo   = 1;
 AoA.fila = AoA.inicial:AoA.passo:AoA.final;

%% CONDIÇÕES DE VOO
cond = flc;
cond.Voo = 12;
%% Cl_max de cada perfil
n_Re = zeros(n_super,1);
Re   = zeros(n_super,3);
pos_Re = zeros(n_super,3);
clmax  = zeros(n_super,3);
clmin  = zeros(n_super,3);
n_limite =  zeros(n_super,3);
limite = zeros(n_super,60);

for i = 1:n_super 
    n_Re(i) = (geo.LiftingSurface.section_num(i) + 1);
    Re(i,1:n_Re(i)) = (cond.Voo.*cond.rho.*geo.LiftingSurface.c(i,1:n_Re(i)))./cond.visc;
    for j = 1:n_Re(i)
        
        perfil = ImportObj(seleciona_perfil(geo.LiftingSurface(1).perfil(i,j)));
        
        pos_Re(i,j) = find([perfil.coef.Re]>=Re(i,j),1,'first');
        clmax(i,j)  = perfil.coef(pos_Re(i,j)).clmax;
        clmax(i,j)  = clmax(i,j) - correcao;

        clmin(i,j)  = perfil.coef(pos_Re(i,j)).clmin;
        clmin(i,j)  = clmin(i,j) - correcao;      

    end    
    n_limite(i) = length(results(i).Yb);
    switch caso
        case 'max'
            limite(i,.5*n_limite(i)+1:n_limite(i)) = interp1(geo.LiftingSurface.b(i,1:n_Re(i)),clmax(i,1:n_Re(i)),results(i).Yb(0.5*end+1:end));
        case 'min'
            limite(i,.5*n_limite(i)+1:n_limite(i)) = interp1(geo.LiftingSurface.b(i,1:n_Re(i)),clmin(i,1:n_Re(i)),results(i).Yb(0.5*end+1:end));
    end
    limite(i,1:.5*n_limite(i)) = flip(limite(i,.5*n_limite(i)+1:n_limite(i)));
    
    %subplot(n_super,1,i)
    %plot(results(i).Yb,limite(i,1:n_limite(i)));
    %grid on; hold on;
end

%% LOOP
estolou(1:n_super) = false;
alfa_estol(1:n_super) = AoA.final;

continuar = true; k = 1:sim.npro;
while continuar 
     cond.aoa = AoA.fila(k);
    

   results = VLMandap(geo, cond, sim, 0, '-LiftingSurfaces');

  for aux_k = 1:sim.npro   
    for i = 1:n_super
        diff = limite(i,1:n_limite(i)) - results(i).Loads(aux_k).cl;
        switch caso
            case 'max'
                if min(diff)<=0 && ~estolou(i)
                    estolou(i) = true; 
                    alfa_estol(i) = AoA.fila(k(aux_k));
                    fprintf('Estol na asa %d com %4.1f\n',i,AoA.fila(k(aux_k)))

                    % Caso queira parar no primeiro estol, não continuar
                    % continuar = false
                    
                    % PLOT
                    %subplot(n_super,1,i)                    
                    %plot(results(i).Yb,results(i).Loads.cl);
                end  
                
            case 'min'
                if max(diff)>=0 && ~estolou(i)
                    estolou(i) = true; 
                    alfa_estol(i) = AoA.fila(k(aux_k));
                    fprintf('Estol na asa %d com %4.1f\n',i,AoA.fila(k(aux_k)))
                    
                    % Caso queira parar no primeiro estol, não continuar
                    % continuar = false
                    
                    % PLOT
                    %subplot(n_super,1,i)
                    %plot(results(i).Yb,results(i).Loads.cl);
                end  
        end
        clearvars diff
    end
  end
    
    k = k(end)+1:k(end)+sim.npro; 
    
    if isempty(find(estolou == 0,1)) || k(end) > length(AoA.fila) 
        continuar = false;
    end
end
%% outputs 
ard.alpha_estol = alfa_estol(1);
geo.MAC = results(1).MAC;
sim.dist = 0;

geo.LiftingSurface.incidence(2) = deflexao0;
%% teste para upar no git