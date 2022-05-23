function [ard] = VLMandap(geo,flc,sim,plotar,varargin)

%--------------------------------------------%
%     _    _ _____ ____ _____ ____ _____     %
%    | \  / |  _  |  __|  _  |  __|  _  |    %
%    |  \/  | [_] | (__| [_] | (__| (_) |    %
%    |_|  |_|_/ \_|____|_/ \_|____|_____|    %
% Multi-Analysis  Code for Airplane COncepts %
%                                            %
%--------------------------------------------%
%    Funcao-ponte entre MACACO e POMAER      %
%--------------------------------------------%

%Input Geometrico, fligth conditions e desempenho.
%Flags
%   -wing                  - Roda asa
%   -EH                    - Roda EH
%   -EV                    - Roda EV
%   -plotpolar             - Plota a polar da curva
%   -beta                  - Roda o VLM com beta
%   -PlotPolar             - Plotar a PlotPolar
%   -PlotGeo               - Plotar o Geo para acompanhamento
% (nao recomenda rodar EV junto com wing ou EH).

clear plane.LiftingSurfaces;
clear plane;
clear fltcond; 

%% ============================== Flags ==============================
%Default Flags
LiftingSurfaces=false;
wings=false;
EH=false;
EV=false;
beta=false;
primeira=true;
PlotPolar=false;

i=1;
while i<=length(varargin)
    switch varargin{i}
        case '-LiftingSurfaces'
            LiftingSurfaces=true;
            i=i+1;
        case '-wings'
            wings=true;
            i=i+1;
        case '-EH'
            EH=true;
            i=i+1;
        case '-EV'
            EV=true;
            i=i+1;
        case '-beta'
            beta=true;
            i=i+1;
        case '-PlotPolar'
            PlotPolar = true;
            i=i+1;
    end
end


%% Inicia com Plane
    plane = Airplane;
   
%% ============================== ASAS ==============================
    if LiftingSurfaces || wings
        if wings && ~EH
            surfacenum = geo.LiftingSurface.surfacenum-1;
        else
            surfacenum = geo.LiftingSurface.surfacenum;
        end
        chordnum = geo.LiftingSurface.section_num+1;
        % ============ Geometrico ===============
        
        for i=1:surfacenum
            for j=1:chordnum  
                perfil = seleciona_perfil(geo.LiftingSurface.perfil(i,j));
                perf(i,j) = ImportObj(perfil);
            end
        end
              
        for i=1:surfacenum
            if i==1
                plane.LiftingSurfaces(i).ID = 1;
                plane.LiftingSurfaces(i).IsMain = 1;
                primeira=false;
            else
                plane.LiftingSurfaces(i) = LiftingSurface(strcat('wing',num2str(i)));
                plane.LiftingSurfaces(i).Geo.pos.x      = geo.LiftingSurface.pos(i,1);  %posicao das outras superficies em funcaoo do C/4 da asa principal
                plane.LiftingSurfaces(i).Geo.pos.z      = geo.LiftingSurface.pos(i,3);  %posicao das outras superficies em funcao do C/4 da asa principal
            end
            plane.LiftingSurfaces(i).Geo.C              = geo.LiftingSurface.c(i,1:chordnum(i));    %corda secoes [m]
            plane.LiftingSurfaces(i).Geo.Yb             = geo.LiftingSurface.b(i,1:chordnum(i));    %Span-Wise secoes [m]
            plane.LiftingSurfaces(i).Geo.Dihedral       = geo.LiftingSurface.d(i,1:chordnum(i)-1);    %Diedro das secoes [deg]
            plane.LiftingSurfaces(i).Geo.Sweep          = geo.LiftingSurface.e(i,1:chordnum(i)-1);    %Enflechamento [deg]
            plane.LiftingSurfaces(i).Geo.Incidence      = geo.LiftingSurface.incidence(i,1);        %Incidencia [deg]
            plane.LiftingSurfaces(i).Geo.TwistY         = geo.LiftingSurface.twist(i,1:chordnum(i));
            plane.LiftingSurfaces(i).Aero.Airfoils.Data = perf(i,:);                    %Perfis
%           plane.LiftingSurfaces(i).Aero.Airfoils.InterpType = [0 0 0 0];              %Interpolacao dos Perfis
        end

        % =============== Mesh ===============
        for i=1:surfacenum
            aux_TypeY=ones(1,chordnum(i)-1);
            aux_lengthaux=length(aux_TypeY);
            aux_TypeY(aux_lengthaux) = 3;
            plane.LiftingSurfaces(i).Aero.Mesh.TypeY    = aux_TypeY;                %Discretizacao da malha das secoes (1: Contant, 2: cossine, 3: right, 4: left)
            if geo.LiftingSurface.Mesh.Definido(i)
                for j=1:(chordnum(i)-1)
                    plane.LiftingSurfaces(i).Aero.Mesh.Ny(j) = geo.LiftingSurface.Mesh.Ny(i,j);
                end
            else
            for j=1:(chordnum(i)-1)
%               if plane.LiftingSurfaces(i).Aero.Mesh.TypeY(j)==3    % Para onde houver discretizacao "a direita"
                if j == chordnum-1 %PONTA
                    panel_dens = 1; %Densidade de Paineis
                    plane.LiftingSurfaces(i).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                elseif j == chordnum-2 %PENULTIMA SECAO
                    panel_dens = 1; 
                    plane.LiftingSurfaces(i).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                else %RESTANTE DAS SECOES
                    panel_dens = 1; 
                    plane.LiftingSurfaces(i).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                end
            end
            end
        end
    end

%% ============================== EHs ==============================
    % Para o caso de rodar somente a EH
    if EH               
        clear perf;
        % =============== Geometrico ===============
        EHnum = 1;
        surfacenum = geo.LiftingSurface.surfacenum;
        chordnum = geo.LiftingSurface.section_num+1;

        for i=1:EHnum
            for j=1:chordnum(surfacenum,:)
                perfil= seleciona_perfil(geo.LiftingSurface.perfil(surfacenum,j));
                perf(i,j) = ImportObj(strcat('CURVAS/',perfil));
            end
        end
        aux=length(plane.LiftingSurfaces); 
        repetir=true;
        for i=aux:(EHnum+aux-1)
            if i==1 && primeira==true
                j=1;
                k=1;
                plane.LiftingSurfaces(j).ID = 1;
                plane.LiftingSurfaces(j).IsMain = 1;
            else
                if repetir
                    j=aux+1;
                    k=1;
                end
                plane.LiftingSurfaces(j) = LiftingSurface(strcat('eh',k));
                plane.LiftingSurfaces(j).Geo.pos.x      = geo.LiftingSurface.pos(surfacenum,1);  %posicao das outras superficies em funcaoo do C/4 da asa principal
                plane.LiftingSurfaces(j).Geo.pos.z      = geo.LiftingSurface.pos(surfacenum,3);  %posicao das outras superficies em funcao do C/4 da asa principal
            end
            plane.LiftingSurfaces(i).Geo.C              = geo.LiftingSurface.c(surfacenum,1:chordnum(surfacenum));    %corda secoes [m]
            plane.LiftingSurfaces(i).Geo.Yb             = geo.LiftingSurface.b(surfacenum,1:chordnum(surfacenum));    %Span-Wise secoes [m]
            plane.LiftingSurfaces(i).Geo.Dihedral       = geo.LiftingSurface.d(surfacenum,1:chordnum(surfacenum)-1);    %Diedro das secoes [deg]
            plane.LiftingSurfaces(i).Geo.Sweep          = geo.LiftingSurface.e(surfacenum,1:chordnum(surfacenum)-1);    %Enflechamento [deg]
            plane.LiftingSurfaces(i).Geo.Incidence      = geo.LiftingSurface.incidence(surfacenum,1);        %Incidencia [deg]
            plane.LiftingSurfaces(i).Geo.TwistY         = geo.LiftingSurface.twist(surfacenum,1:chordnum(surfacenum));
            plane.LiftingSurfaces(i).Aero.Airfoils.Data = perf(k,:);                    %Perfis
%           plane.LiftingSurfaces(i).Aero.Airfoils.InterpType = [0 0 0 0];              %Interpolacao dos Perfis
            k=k+1;
            j=j+1;
            repetir=false;
        end
      
        % =============== Mesh ===============
        repetir=true;
        for i=aux:(EHnum+aux-1)
            if i==1 && primeira==true
                k=1;
                l=1;
            else
                if repetir
                    k=aux+1;
                    l=1;
                end
            end
            aux_TypeY=ones(1,chordnum(surfacenum)-1);
            aux_lengthaux=length(aux_TypeY);
            aux_TypeY(aux_lengthaux) =  3;
            plane.LiftingSurfaces(k).Aero.Mesh.TypeY    = aux_TypeY;       %Discretizacao da malha das secoes (1: Constant, 2: cossine, 3: right, 4: left)
            for j=1:(chordnum(surfacenum)-1)
                if j == chordnum(surfacenum)-1 %PONTA
                    panel_dens = 3; %Densidade de Paineis
                    plane.LiftingSurfaces(k).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                elseif j == chordnum(surfacenum)-2 %PENULTIMA SECAO
                    panel_dens = 2; 
                    plane.LiftingSurfaces(k).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                else %RESTANTE DAS SECOES
                    panel_dens = 1; 
                    plane.LiftingSurfaces(k).Aero.Mesh.Ny(j)	= panel_dens*sim.panel;        %Num. de paineis
                end
            end
            k=k+1;
            l=l+1;
            repetir=false;
        end
    end

%% ============================== EVs ==============================
    if EV
        clear perf
        % =============== Geometrico ===============
        [EVnum,chordEVnum]=size(geo.ev.c);
        for i=1:EVnum
            for j=1:chordEVnum
                perfil= seleciona_perfil(geo.ev.perfil(i,j));
                perf(i,j) = ImportObj(perfil);
            end
        end
        aux=length(plane.LiftingSurfaces); 
        repetir=true;
        for i=aux:(EVnum+aux-1)
            if i==1 && primeira==true
                j=1;
                k=1;
                plane.LiftingSurfaces(j).ID = 1;
                plane.LiftingSurfaces(j).IsMain = 1;

            else
                if repetir
                    j=aux+1;
                    k=1;
                end
                plane.LiftingSurfaces(j) = LiftingSurface(strcat('ev',k));
                plane.LiftingSurfaces(j).Geo.pos.x              = geo.ev.pos(k,1);               %posicionamento empenagem em x
                plane.LiftingSurfaces(j).Geo.pos.y              = geo.ev.pos(k,2);               %posicionamento empenagem em y 
                plane.LiftingSurfaces(j).Geo.pos.z              = geo.ev.pos(k,3);               %posicionamento empenagem em z
            end
            plane.LiftingSurfaces(j).Geo.YSymmetry      = 1;
            plane.LiftingSurfaces(j).Geo.C              = geo.ev.c(k,:);             %corda secoes POMAER [m]
            plane.LiftingSurfaces(j).Geo.Yb             = geo.ev.b(k,:);             %Span-Wise secoes POMAER [m]
            plane.LiftingSurfaces(j).Geo.Dihedral       = geo.ev.d(k,:);             %Diedro das secoes POMAER [deg]
            plane.LiftingSurfaces(j).Geo.Sweep          = geo.ev.e(k,:);             %Enflechamento POMAER [deg]
            plane.LiftingSurfaces(j).Aero.Airfoils.Data = perf(k,:);                 %Perfis POMAER
            k=k+1;
            j=j+1;
            repetir=false;
        end
      
        % =============== Mesh ===============
        repetir=true;
        for i=aux:(EVnum+aux-1)
            if i==1 && primeira==true
                k=1;
                l=1;
            else
                if repetir
                    k=aux+1;
                    l=1;
                end
            end
            aux_TypeY=ones(1,chordEVnum-1);
            aux_lengthaux=length(aux_TypeY);
            aux_TypeY(aux_lengthaux) = 3;
            plane.LiftingSurfaces(k).Aero.Mesh.TypeY    = aux_TypeY;                %Discretizacao da malha das secoes (1: Contant, 2: cossine, 3: right, 4: left)
            for j=1:(chordEVnum-1)
                if plane.LiftingSurfaces(k).Aero.Mesh.TypeY(j)==3
                    plane.LiftingSurfaces(k).Aero.Mesh.Ny(j)	= sim.panel;    %Num. de paineis
                else
                    plane.LiftingSurfaces(k).Aero.Mesh.Ny(j)    = sim.panel;    %Num. de paineis
                end
            end
            k=k+1;
            l=l+1;
            repetir=false;
        end
    end
        
%% ================================ PLOTS  ================================

    plane.UpdateGeo;
    plane.UpdateAeroMesh;
    
    if plotar == 1
		plane.PlotMesh('-clf')
        ard = 0;
        return
	elseif plotar == 2
		plane.PlotGeo('-airfoils')
		view([-40,30])
        ard = 0;
        return
    elseif plotar == 3
        plane.PlotGeo('-clf')
        view([90,90])
    end
    
%% ================================= VLM ==================================
if sim.ajuste
    plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq=1;  
else
    plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq=0;
end

if length(flc.Voo) > 1
    for i=1:length(flc.aoa)
        parfor j=1:length(flc.Voo)
            fltcond                                     = FlightConditions;         %Inicia flight conditions
            fltcond.H                                   = flc.h;                    %Altitude de referencia [m]
            fltcond.rho                                 = flc.rho;                  %rho ar POMAER
            fltcond.alpha                               = flc.aoa(i);          %vetor alpha [deg]
            fltcond.Voo                                 = flc.Voo(j);
            fltcond.p                         = 0;
            fltcond.q                         = 0;
            fltcond.r                         = 0;
            fltcond.UpdateRe;
            [CL(:,j),CD(:,j),Cm25(:,j),dist1(:,j),dist2(:,j)] = NL_VLMp(plane,fltcond,'-itermax',sim.intermax);
%             [results]                     = NL_VLMp(plane,fltcond,'-append','-itermax',sim.intermax);
        end   
    end
    for k=1:length(plane.LiftingSurfaces)
        for i=1:length(flc.Voo)
            ard(k).Coeffs(i).CL             = CL(k,i); 
            ard(k).Coeffs(i).CD             = CD(k,i);
            ard(k).Coeffs(i).Cm25           = Cm25(k,i);
        end
%             ard(k).Coeffs                = plane.LiftingSurfaces(k).Aero.Coeffs;
            [ard(k).Coeffs]              = filtro_coef(ard(k).Coeffs);   %Filtro estatistico de divergencias
            ard(k).Coeffs(1,1).Sref      = plane.LiftingSurfaces(k).Geo.Area.Sref;
            ard(k).MACXYZ                = plane.LiftingSurfaces(k).Geo.MAC_Pos;
            if sim.dist
                ard(k).Yb          = plane.LiftingSurfaces(k).Aero.Mesh.Yb0;
                
            end
            ard(k).MACg                  = plane.Geo.MAC;
            ard(k).MACXYZg               = plane.Geo.MAC_Pos;
            ard(k).MAC                   = plane.LiftingSurfaces(k).Geo.MAC;           
       
        if sim.dist
            for i=1:length(flc.Voo)
                ard(1).Loads(i).cl  =  dist1(:,i)'; 
                ard(2).Loads(i).cl  =  dist2(:,i)';
            end
        end
    end  
else
    for j=1:length(flc.Voo)
        parfor i=1:length(flc.aoa)
            fltcond                                     = FlightConditions;         %Inicia flight conditions
            fltcond.H                                   = flc.h;                    %Altitude de referencia [m]
            fltcond.rho                                 = flc.rho;                  %rho ar POMAER
            fltcond.alpha                               = flc.aoa(i);          %vetor alpha [deg]
            fltcond.Voo                                 = flc.Voo(j);
            fltcond.p                         = 0;
            fltcond.q                         = 0;
            fltcond.r                         = 0;
            fltcond.UpdateRe;
            [CL(:,i),CD(:,i),Cm25(:,i),dist1(:,i),dist2(:,i)] = NL_VLMp(plane,fltcond,'-itermax',sim.intermax)
%             [results]                     = NL_VLMp(plane,fltcond,'-append','-itermax',sim.intermax);
        end    
        for k=1:length(plane.LiftingSurfaces)
            for i=1:length(flc.aoa)
                ard(k).Coeffs(i).CL             = CL(k,i); 
                ard(k).Coeffs(i).CD             = CD(k,i);
                ard(k).Coeffs(i).Cm25           = Cm25(k,i);
            end
%             ard(k).Coeffs                = plane.LiftingSurfaces(k).Aero.Coeffs;
            [ard(k).Coeffs]              = filtro_coef(ard(k).Coeffs);   %Filtro estatistico de divergencias
            ard(k).Coeffs(1,1).Sref      = plane.LiftingSurfaces(k).Geo.Area.Sref;
            ard(k).MACXYZ                = plane.LiftingSurfaces(k).Geo.MAC_Pos;
            if sim.dist
                ard(k).Yb          = plane.LiftingSurfaces(k).Aero.Mesh.Yb0;
                
            end
            ard(k).MACg                  = plane.Geo.MAC;
            ard(k).MACXYZg               = plane.Geo.MAC_Pos;
            ard(k).MAC                   = plane.LiftingSurfaces(k).Geo.MAC;           
        end
        if sim.dist
            for i=1:length(flc.aoa)
                ard(1).Loads(i).cl  = dist1(:,i)'; 
                ard(2).Loads(i).cl  = dist2(:,i)';
            end
        end
    end
end


	
    if PlotPolar
        plane.PlotPolar;
    end
% %% pegando do VLManda normal
%         for j=1:length(flc.Voo)
%                 parfor i=1:length(flc.aoa)
%                     fltcond                               = FlightConditions;
%                     fltcond.Voo                           = flc.Voo(j);
%                     fltcond.alpha                     = flc.aoa(i);          %vetor alpha [deg]
%                     fltcond.p                         = 0;
%                     fltcond.q                         = 0;
%                     fltcond.r                         = 0;
%                     fltcond.UpdateRe;
%                     
%                     [results]                     = NL_VLM(plane,fltcond,'-append','-itermax',sim.intermax);
%                 end     
%                     if sim.ajuste
%                         plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq=1;
%                     else
%                         plane.Aero.Settings.NLVLM.Cl_from_adjusted_2DCurvesEq=0;  %utilizando polinomio 2D. Mais rapido
%                         %	0:	When capturing 2d cl, use interpolation between polars and alphas. (Slower but more precise)
%                         %	1:	When capturing 2d cl, use adjusted nonlinear equations. (Faster, but accuracy depends on the quality of the adjustent. In order to check the adjustment, type <Airfoil variable>.CheckAdjustment )
%                     end
%                     
%         end
%             
%        
% 
%         for k=1:length(plane.LiftingSurfaces)
%                 ard(k).Coeffs                = plane.LiftingSurfaces(k).Aero.Coeffs;
%                 [ard(k).Coeffs]              = filtro_coef(ard(k).Coeffs);   %Filtro estatistico de divergencias
%                 ard(k).Coeffs(1,1).Sref      = plane.LiftingSurfaces(k).Geo.Area.Sref;
%                 ard(k).MACXYZ                = plane.LiftingSurfaces(k).Geo.MAC_Pos;
%                 if sim.dist
%                     ard(k).Yb          = plane.LiftingSurfaces(k).Aero.Mesh.Yb0;
%                     for i=1:length(flc.aoa)
%                         ard(k).Loads(i).cl  = plane.LiftingSurfaces(k).Aero.Loads(i).cl;    
%                     end
%                 end
%                 ard(k).MACg                  = plane.Geo.MAC;
%                 ard(k).MACXYZg               = plane.Geo.MAC_Pos;
%                 ard(k).MAC                   = plane.LiftingSurfaces(k).Geo.MAC;
% %               ard.Lf(k).alpha           = plane.LiftingSurfaces(k).Aero.Coeffs.alpha;
% %               ard.Lf(k).CL              = plane.LiftingSurfaces(k).Aero.Coeffs.CL;
% %               ard.Lf(k).CDi             = plane.LiftingSurfaces(k).Aero.Coeffs.CDi;
% %               ard.Lf(k).CD0             = plane.LiftingSurfaces(k).Aero.Coeffs.CD0;
% %               ard.Lf(k).CMc4            = plane.LiftingSurfaces(k).Aero.Coeffs.Cm25;
% %               ard.Lf(k).CMref           = plane.LiftingSurfaces(k).Aero.Coeffs.Cm25;
% %               ard(i,k)                = plane.LiftingSurfaces(i).Aero.Coeffs;
%         end
%         ard(k+1).Coeffs                     = plane.Aero.Coeffs;            % Coeffs aerodinamicos globais da aeronave
%     
% %    end
% 	
%     if PlotPolar
%         plane.PlotPolar;
%     end
end
