classdef Airplane < handle
%--------------------------------------------%
%     _    _ _____ ____ _____ ____ _____     %
%    | \  / |  _  |  __|  _  |  __|  _  |    %
%    |  \/  | [_] | (__| [_] | (__| (_) |    %
%    |_|  |_|_/ \_|____|_/ \_|____|_____|    %
% Multi-Analysis  Code for Airplane COncepts %
%                                            %
%--------------------------------------------%
%				AIRPLANE CLASS				 %
%--------------------------------------------%
%
% This class ...
%
% PROPERTIES
% -------------
%	LiftingSurfaces:
%	SlenderBodies:
%	Geo:
%	Mass:
%	Aero:
%
% METHODS
% -------------
%	save:			Save current airplane in a .mat file;
%	ClearPolars:	Clear all stored polars;
%	UpdateGeo:		Update geommetry information;
%	UpdateAeroMesh:	Update aerodynamic mesh;
%	PlotGeo:		Plot geommetry;
%	PlotMesh:		Plot aerodynamic mesh;
%	PlotWake:		Plot wake;
%	PlotPolar:		Plot Polars in a xy graph;
%
% For further information about each method, type >> help Airplane.<method>
%
% Author: André Rezende Dessimoni Carvalho
%


	properties
		LiftingSurfaces@LiftingSurface
		SlenderBodies@SlenderBody
		Geo@Airplane_Geo
		Mass@Airplane_Mass
        Aero@Airplane_Aero
		MotoPropulsor	
	end
	
	
	
	methods
		
		% Constructor method
		function [obj] = Airplane()
			
 			obj.LiftingSurfaces = LiftingSurface('Wing');
            obj.Geo(1)  = Airplane_Geo;
            obj.Aero(1) = Airplane_Aero;
            obj.Mass(1) = Airplane_Mass;
		end
		
% -------------------------------------------------------------------------
		function [obj] = Use(obj,component)
			info = whos('-file',component);
			
			switch info.class
				case 'eletric_motor'
					n	= length(obj.MotoPropulsor)+1;
					aux = load(component);
					
 					obj.MotoPropulsor = getfield(aux,char(fields(aux)));
			end
			
		end
		
% -------------------------------------------------------------------------		
		function [obj] = AddLS (obj,name)
			if isempty(name)
				name = 'NewSurface';
			end
			obj.Geo.nLS = obj.Geo.nLS+1;
			obj.LiftingSurfaces(2) = LiftingSurface(name);
		end
		
% -------------------------------------------------------------------------		
		function [] = Save(obj,varargin)
			% SAVE Aiplane variable into a .mat file
			%	Flags:
			%	-w:		Write file without confirm
			%	-file:	Change file name
			
			Confirm = true;
			Write   = false;
			Exist	= false;
			
			file    = [inputname(1), '.mat'];
			
			i=1;
			while i<=length(varargin)
				switch varargin{i}
					case '-w'
						Confirm = false;
						i = i+1;
					
					case '-file'
						file = varargin{i+1};
						in = max([1,length(file)-4]);
						if ~strcmp(file(in:end),'.mat')
							file = [file, '.mat'];
						end
						i=i+2;
						
					otherwise
						warning(['Unknown option ' varargin{i}])
						i=i+1;
				end
			end
			
			if exist(file, 'file') == 2
				Exist = true;
			end
			
			if Confirm
				if Exist
					Write = input('File exists. Rewrtite? 0/1\n');
				end
			end
									
			if ~Confirm || Write || ~Exist
				save(file,'obj')
			end
		end
		
% -------------------------------------------------------------------------		
		function [obj] = ClearPolars(obj)
			% Clear all stored aerodynamic polars in Airplane and LiftingSurfaces

			for LSn=1:obj.Geo.nLS
				obj.LiftingSurfaces(LSn).Aero.Load = [];
			end
		end
		
% -------------------------------------------------------------------------		
		function [obj] = SortPolars(obj)
			% Sort polars. 
			% Order: Mach -> Re -> p -> q -> r -> beta -> alpha
			
		end
% -------------------------------------------------------------------------		
		function [obj] = UpdateGeo(obj)
			
			nLS = length(obj.LiftingSurfaces);
			obj.Geo.nLS = nLS;
			
			nMainLS = 0;
			for LSn=1:nLS
				
				obj.LiftingSurfaces(LSn).Geo.Update;
				
				if obj.LiftingSurfaces(LSn).IsMain
					if isempty(obj.Geo.MAC)
						obj.Geo.MAC		= obj.LiftingSurfaces(LSn).Geo.MAC;
						obj.Geo.MAC_Pos = obj.LiftingSurfaces(LSn).Geo.MAC_Pos;
					end
					nMainLS = nMainLS+1;
				end
			end
			obj.Geo.nMainLS = nMainLS;
			
			if nMainLS==0
				error('No main LiftingSurface found')
			elseif nMainLS>1
				warning(['Two or more main Lifting Surfaces!!! Airplane span will be taken as the largest span.' ...
						 ' Airplane reference area will be the sum of areas. Double check all calculated geometric features.']);
			end
			
			obj.Geo.nstatLS = zeros(nLS,1);
			Sref = 0;
			for LSn=1:nLS
			
				obj.Geo.nstatLS(LSn) = length(obj.LiftingSurfaces(LSn).Geo.C);
				obj.Geo.npanLS(LSn)	 = obj.Geo.nstatLS(LSn)-1;
			
				if obj.LiftingSurfaces(LSn).IsMain ==1
					Sref = Sref+obj.LiftingSurfaces(LSn).Geo.Area.Sref;
				end
			end
			obj.Geo.Area.Sref = Sref;
            
            
			b=0;
            for LSn=1:nLS
                if obj.LiftingSurfaces(LSn).IsMain
					if obj.LiftingSurfaces(LSn).Geo.b > b
						b = obj.LiftingSurfaces(LSn).Geo.b;
					end
                end
            end
            obj.Geo.b = b;
  
			
		end
		
		
% -------------------------------------------------------------------------		
		function [obj] = UpdateAeroMesh(obj)
			for LSn=1:obj.Geo.nLS

				% Mesh initialization
				npan = obj.Geo.npanLS(LSn);
				
				if isempty(obj.LiftingSurfaces(LSn).Aero.Mesh.Ny)
					obj.LiftingSurfaces(LSn).Aero.Mesh.Ny = 20*ones(npan,1);
				end
				if isempty(obj.LiftingSurfaces(LSn).Aero.Airfoils.InterpType)
					obj.LiftingSurfaces(LSn).Aero.Airfoils.InterpType = ones(npan,1);
				end
				if isempty(obj.LiftingSurfaces(LSn).Aero.Mesh.TypeY)
					obj.LiftingSurfaces(LSn).Aero.Mesh.TypeY = ones(npan,1);
				end
				if isempty(obj.LiftingSurfaces(LSn).Aero.Mesh.Nc)
					obj.LiftingSurfaces(LSn).Aero.Mesh.Nc = ones(npan,1);
				end

			end
			
			obj = DiscretizerAeroMesh(obj);
			
		end
		
		
% -------------------------------------------------------------------------		
		function [obj] = UpdateWake(obj,fltcond)
			for i=1:length(obj.LiftingSurfaces)
				obj.LiftingSurfaces(i).Aero = DiscretizerWake(obj.LiftingSurfaces(i).Aero,fltcond);
			end
		end
		
		
% -------------------------------------------------------------------------		
	end
% -------------------------------------------------------------------------	

	methods (Static = false)
		
		function PlotGeo(obj,varargin)
			% Plot the current geometry
			%	
			%	Flags:
			%		-nimage: Number of the figure where the geommetry will be plotted. (Default: 100)
			%		-handle: Handle of the figure where the geommetry will be plotted.
			%		-airfoils: Plot geometry and name/directory of airfoils 
			
			nimage = 100;
			handle_fig_spec = 0;
			plot_foils = 0;
			i=1;
			while i<=length(varargin)
				switch varargin{i}
					case '-nimage'
						nimage = varargin{i+1};
						i=i+2;
					case '-handle'
						handle_fig_spec = 1;
						handle_axes = varargin{i+1};
						i=i+2;
					case '-airfoils'
						plot_foils = 1;
						i=i+1;
					otherwise
						i = i+1;
				end
			end
			
			if handle_fig_spec
				hold(handle_axes,'on')
			else
				figure(nimage); hold on
				handle_axes = gca;
			end
			for i=1:length(obj.LiftingSurfaces)
				obj.LiftingSurfaces(i).Geo.Plot(handle_axes)
			end	
			
			if plot_foils
				for LSn=1:length(obj.LiftingSurfaces)
					for statn=1:length(obj.LiftingSurfaces(LSn).Geo.C)
						airfoil = obj.LiftingSurfaces(LSn).Aero.Airfoils.Data(statn);
						if ~isempty(airfoil.xy)
							yy = obj.LiftingSurfaces(LSn).Geo.Yb(statn)*ones(size(airfoil.xy,1))+ ...
								 obj.LiftingSurfaces(LSn).Geo.pos.y;
							
							xx = obj.LiftingSurfaces(LSn).Geo.XYZ.LE(statn,1)+ ...
								 obj.LiftingSurfaces(LSn).Geo.C(statn)*airfoil.xy(:,1);
							
							zz = obj.LiftingSurfaces(LSn).Geo.XYZ.LE(statn,3)+ ...
								 obj.LiftingSurfaces(LSn).Geo.C(statn)*airfoil.xy(:,2);
							
							 plot3(handle_axes,xx,yy,zz,'k')
							 if ~isempty(airfoil.name)
								text(xx(end),yy(end),zz(end),airfoil.name)
							 elseif ~isempty(airfoil.dir)
								 text(xx(end),yy(end),zz(end),airfoil.dir)
							 end
							 if obj.LiftingSurfaces(LSn).Geo.YSymmetry
							 plot3(handle_axes,xx,-yy,zz,'k')
							 end
						end
					end
				end
			end
			
			plot3(obj.Mass.CG(1),obj.Mass.CG(2),obj.Mass.CG(3),'or')
			plot3(obj.Mass.CG(1),obj.Mass.CG(2),obj.Mass.CG(3),'+r')
			
		end
			
		
		
% -------------------------------------------------------------------------		
		function PlotMesh(obj,varargin)
			%	Plot the current aerodynamic mesh.
			%	
			%	Flags:
			%		'-nimage',<fig>	:	Number of the figure where the wake will be plotted. (Default: 100)
			%		'-clf'			:	Clear figure before plot
			%		'-LS', <[LS's]> :	Plot Lifting Surfaces contained in the vector [LS's]
			%		'-n'			:	Plot normals
			%		'-c'			:	Plot Control Points
			%		'-ref'			:	Plot reference axis
			%		'-cg'			:	Plot center of gravity
			%		'-loads',<polar>:	Plot loads. <polar> is the index of the polar to be plotted
			%		'-noshadow'		:	Do not plot geometry shadow
			
			
			nimage			= 100;
			clear_fig		= false;
			plot_n			= false;
			plot_CtrlPts	= false;
			plot_shadow		= true;
			plot_loads		= false;
			plot_reference	= false;
			plot_CG			= false;
			scale_load		= 1;
			plot_LS			= 1:obj.Geo.nLS;
			polar_n			= length(obj.Aero.Loads);
			
			i=1;
			while i<=length(varargin)
				switch varargin{i}
					case '-nimage'
						nimage = varargin{i+1};
						i=i+2;
					case '-clf'
						clear_fig = true;
						i=i+1;
					case '-LS'
						plot_LS = varargin{i+1};
						i=i+2;
					case '-n'
						plot_n = true;
						i=i+1;
					case '-c'
						plot_CtrlPts = true;
						i = i+1;
					case '-ref'
						plot_reference = true;
						i = i+1;
					case '-cg'
						plot_CG = true;
						i = i+1;
					case '-loads'
						plot_loads	= 1;
						polar_n		= varargin{i+1};
						i=i+2;
					case '-scaleloads'
						scale_load = varargin{i+1};
						i=i+2;
					case '-noshadow'
						plot_shadow = false;
						i = i+1;
					otherwise
						warning(['Unknown flag ' num2str(varargin{i})])
						i=i+1;
				end
			end
			
			
			
			figure(nimage); hold on
			if clear_fig
				clf; hold on
			end
			
			for LSn=plot_LS(1):plot_LS(end)
	
				for i=1:obj.LiftingSurfaces(LSn).Aero.Mesh.Ny_tot
					fill3([obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v1(i,1)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v2(i,1)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v3(i,1)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v4(i,1)],...
						  [obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v1(i,2)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v2(i,2)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v3(i,2)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v4(i,2)],...
						  [obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v1(i,3)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v2(i,3)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v3(i,3)  obj.LiftingSurfaces(LSn).Aero.Mesh.Verts.v4(i,3)],...
						  'w','LineWidth',1);
				end
				
				if plot_shadow
					axis_lims	= axis;
					if length(axis_lims)==4
						axis_lims(5:6) = [0 0];
					end
					minz = min([obj.Aero.Mesh.PC25(:,3)-.5; axis_lims(5)]);
					maxz = max([obj.Aero.Mesh.PC25(:,3); axis_lims(6)]);
					axis_lims(5) = minz;
					axis_lims(6) = maxz*1.1;
                    axis_lims=axis_lims;
					
					for i=1:length(obj.LiftingSurfaces(LSn).Geo.C)-1
						fill3(	[obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i,1) obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i+1,1) obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i+1,1) obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i,1)],...
								[obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i,2) obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i+1,2) obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i+1,2) obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i,2)],...
								[minz minz minz minz],...
								[.7 .7 .7],'LineStyle','none');
						if obj.LiftingSurfaces(LSn).Geo.YSymmetry
						fill3(	[ obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i,1)  obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i+1,1)  obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i+1,1)  obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i,1)],...
								[-obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i,2) -obj.LiftingSurfaces(LSn).Geo.XYZ.LE(i+1,2) -obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i+1,2) -obj.LiftingSurfaces(LSn).Geo.XYZ.TE(i,2)],...
								[minz minz minz minz],...
								[.7 .7 .7],'LineStyle','none');	
						end
					end
					axis (axis_lims)
				end
				
				
				if plot_n
					quiver3(obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,1), obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,2), obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,3), ...
							obj.LiftingSurfaces(LSn).Aero.Mesh.Normal(:,1),    obj.LiftingSurfaces(LSn).Aero.Mesh.Normal(:,2),    obj.LiftingSurfaces(LSn).Aero.Mesh.Normal(:,3),.5,'Color','k')
				end

				if plot_CtrlPts
						plot3(obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,1), obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,2), obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,3)+.01,'or')
						plot3(obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,1), obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,2), obj.LiftingSurfaces(LSn).Aero.Mesh.PC34(:,3)+.01,'ob')
				end

% 				if plot_loads
% 					if ~isempty(obj.LiftingSurfaces(LSn).Aero.Loads(polar_n).cx(:))
% 						scale_load_LS = max(obj.LiftingSurfaces(LSn).Aero.Loads(polar_n).cx(:))/max(obj.Aero.Loads(polar_n).cx(:))*scale_load;
% 					quiver3(obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,1),		obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,2),		obj.LiftingSurfaces(LSn).Aero.Mesh.PC25(:,3), ...
% 							obj.LiftingSurfaces(LSn).Aero.Loads(polar_n).cx(:), obj.LiftingSurfaces(LSn).Aero.Loads(polar_n).cy(:), obj.LiftingSurfaces(LSn).Aero.Loads(polar_n).cz(:),scale_load_LS,'Color','b')
% 					else
% 						warning(['Empty loads on Lifting Surface ', num2str(LSn)])
% 					end
% 				end
				
			end
		
		if plot_loads
			quiver3(obj.Aero.Mesh.PC25(:,1),		obj.Aero.Mesh.PC25(:,2),	 obj.Aero.Mesh.PC25(:,3), ...
					obj.Aero.Loads(polar_n).cx(:), obj.Aero.Loads(polar_n).cy(:),obj.Aero.Loads(polar_n).cz(:),scale_load,'Color','b')
		end
				
		if plot_CG
			plot3(obj.Mass.CG(1),obj.Mass.CG(2),obj.Mass.CG(3),'or')
			plot3(obj.Mass.CG(1),obj.Mass.CG(2),obj.Mass.CG(3),'+r')
		end
		if plot_reference
			quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[.5;0;0],[0;.5;0],[0;0;.5],'Color','r')
		end
			
			axis equal
			grid minor
			grid on
			box on
			axis vis3d
			view(-45,30)
			rotate3d on
			
		end
		
		
% -------------------------------------------------------------------------		
		function PlotWake(obj,varargin)
			% Plot the wake. It is better to be used after PlotMesh or PlotGeo
			%
			% Flags:
			%	-nimage: Number of the figure where the wake will be plotted. (Default: 100)
			%	-axis  <limits>:	Axis limits [xmin xmax ymin ymax zmin zmax]. Default: Maintein axis from previous plotted figure.
			%	-xaxis <limits>:	X Axis limits
			%	-yaxis <limits>:	Y Axis limits
			%	-zaxis <limits>:	Z Axis limits
			%
			
			nimage = 100;
			setaxis = false;
			setaxisx = false;
			setaxisy = false;
			setaxisz = false;
			
			i=1;
			while i<=length(varargin)
				switch varargin{i}
					case '-nimage'
						nimage = varargin{i+1};
						i=i+2;
					case '-axis'
						setaxis = true;
						axis_set = varargin{i+1};
						i=i+2;
					case '-xaxis'
						setaxisx = true;
						axis_setx = varargin{i+1};
						i=i+2;
					case '-yaxis'
						setaxisy = true;
						axis_sety = varargin{i+1};
						i=i+2;
					case '-zaxis'
						setaxisz = true;
						axis_setz = varargin{i+1};
						i=i+2;
					otherwise
						i = i+1;
				end
			end
			
			
			figure(nimage); hold on
			
				XLIM = xlim;
				YLIM = ylim;
				ZLIM = zlim;
			
			
			for k=1:length(obj.LiftingSurfaces)
				for i=1:obj.LiftingSurfaces(k).Aero.Mesh.Ny_tot
					for j=1:1
						line(	[obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j,1) obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j+1,1)],...
								[obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j,2) obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j+1,2)],...
								[obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j,3) obj.LiftingSurfaces(k).Aero.Wake.LLVerts(i,j+1,3)],'LineStyle','-')

						line(	[obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j,1) obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j+1,1)],...
								[obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j,2) obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j+1,2)],...
								[obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j,3) obj.LiftingSurfaces(k).Aero.Wake.RLVerts(i,j+1,3)],'LineStyle','-')
					end	
					line(	[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,4,1) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,1)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,4,2) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,2)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,4,3) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,3)],'LineStyle','-')
						
					line(	[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,1) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,1)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,2) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,2)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,1,3) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,3)],'LineStyle','-')
						
					line(	[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,1) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,3,1)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,2) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,3,2)],...
							[obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,2,3) obj.LiftingSurfaces(k).Aero.Wake.BVerts(i,3,3)],'LineStyle','-')
				end
			end
			
			if setaxis
				axis(axis_set)
			elseif setaxisx
				xlim(axis_setx)
			elseif setaxisy
				ylim(axis_sety)
			elseif setaxisz
				zlim(axis_setz)
			else
				axis([XLIM(1) XLIM(2) YLIM(1) YLIM(2) ZLIM(1), ZLIM(2)])
			end
        end
        
% -------------------------------------------------------------------------	        
		function PlotPolar(obj)


			f = figure('Units', 'normalized', 'Position', [0.1,0.1,.6,.6]);
			ax = axes('Units','normalized', 'Position',[0.05 0.1 0.45 0.85]);
			
			% Panels
			% -------------------------
			panel_vars = uipanel('Title','Plot Definitions','Units', 'normalized',...
			 'FontSize',10, 'Position',[.53 .1 .25 .87]);
		 
			panel_format = uipanel('Title','Format','Units', 'normalized',...
			 'FontSize',10, 'Position',[.8 .77 .15 .2]);
		 
			panel_opts = uipanel('Title','Options','Units', 'normalized',...
			 'FontSize',10, 'Position',[.8 0.1 .15 0.65]);
		 
		 
			% Variables
			% -------------------------
			
			uicontrol('Parent',panel_vars,'Style','text',...
			'Units', 'normalized',...
			'Position',[0 0.93 1 0.05],...
			'String','Plot Type');
		
			popup_plottype = uicontrol('Parent',panel_vars,'Style', 'popup',...
           'String', {'Coefficients'; 'Derivatives'; 'Loads 2D'; 'Loads 3D'; 'Mesh'; 'Geometry'},...
		   'Units', 'normalized',...
           'Position', [0 0.9 1 0.05],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','popup_x');
	   
			uicontrol('Parent',panel_vars,'Style','text',...
			'Units', 'normalized',...
			'Position',[0 0.83 1 0.05],...
			'String','Surfaces');
		
			list_surfs = uicontrol('Parent',panel_vars,'Style', 'list',...
           'String',{'Global', obj.LiftingSurfaces(:).label},...
		   'Units', 'normalized','max',1e5,...
           'Position', [0 0.65 1 0.20],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','popup_x');
	   
			uicontrol('Parent',panel_vars,'Style','text',...
			'Units', 'normalized',...
			'Position',[0 0.58 1 0.05],...
			'String','Polar Set');
		
			list_polarset = uicontrol('Parent',panel_vars,'Style', 'list',...
           'String', {''},...
		   'Units', 'normalized',...
           'Position', [0 0.4 1 0.2],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','popup_x');
	   
			uicontrol('Parent',panel_vars,'Style','text',...
			'Units', 'normalized',...
			'Position',[0 0.33 1 0.025],...
			'String','X variable');
		
			popup_x = uicontrol('Parent',panel_vars,'Style', 'popup',...
           'String', {'alpha','beta','p','q','r','CL'},...
		   'Units', 'normalized',...
           'Position', [0 0.3 1 0.025],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','popup_x');
	   		
			uicontrol('Parent',panel_vars,'Style','text',...
			'Units', 'normalized',...
			'Position',[0 0.23 1 0.025],...
			'String','Y variable');
		
			list_y = uicontrol('Parent',panel_vars,'Style', 'list',...
           'String', {'CL','CD','CD0','CDi','Cm25','Cl_rol','Cn'},...
		   'Units', 'normalized','max',1e5,...
           'Position', [0 0 1 0.23],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','popup_y'); 
	   
	   
			% Formatation
			% -------------------------
			check_grid = uicontrol('Parent',panel_format,'Style', 'checkbox',...
           'String', 'Grid',...
		   'Units', 'normalized',...
           'Position', [0. 0.8 1 0.1],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','check_grid'); 
	   
			check_minorgrid = uicontrol('Parent',panel_format,'Style', 'checkbox',...
           'String', 'Minor Grid',...
		   'Units', 'normalized',...
           'Position', [0. .6 1 0.1],...
           'Callback', @(source,event)PlotPolarData(obj),'Tag','check_minorgrid'); 
	   
			PlotPolarData(obj)
	   
	   
			function PlotPolarData(obj)
				plot_k = 0;
				cla(ax)
				
				for LSn=1:length(list_surfs.Value)
					for Yn=1:length(list_y.Value)
						plot_k = plot_k+1;
						
						LS_label = list_surfs.String(list_surfs.Value(LSn));
						if strcmp('Global',LS_label)
							data = obj.Aero.Coeffs;
						else
							data = obj.LiftingSurfaces(strcmp(LS_label, {obj.LiftingSurfaces(:).label})==1).Aero.Coeffs;
						end


						x_ind = get(popup_x, 'Value');
						x_var = popup_x.String{x_ind};

						switch x_var
							case 'alpha'
								x = [data.alpha];
								x_name = '\alpha [deg]';
							case 'beta'
								x = [data.beta];
								x_name = '\beta [deg]';
							case 'p'
								x = [data.p];
								x_name = 'p';
							case 'q'
								x = [data.q];
								x_name = 'q';
							case 'r'
								x = [data.r];
								x_name = 'r';
							case 'CL'
								x = [data.CL];
								x_name = 'C_L';
						end

						y_ind = get(list_y, 'Value');
						y_var = list_y.String{y_ind(Yn)};

						switch y_var
							case 'CL'
								y = [data.CL];
								y_name = 'C_L';
							case 'CD'
								y = [data.CD];
								y_name = 'C_D';
							case 'CD0'
								y = [data.CD0];
								y_name = 'C_{D0}';
							case 'CDi'
								y = [data.CDi];
								y_name = 'C_{Di}';
							case 'Cm25'
								y = [data.Cm25];
								y_name = 'C_M';
							case 'Cl_rol'
								y = [data.Cl_rol];
								y_name = 'C_{l_{rol}}';
							case 'Cn'
								y = [data.Cn];
								y_name = 'C_n';
						end
						
						leg_txt{plot_k} = [char(LS_label), ' - ', char(y_var)];
						
						plot(ax, x, y); hold on
						xlabel(x_name);
						
						
					end
				end
				legend('Location','NorthWest');
				legend(leg_txt)
				
				
				
 				plot_grid		= get(check_grid,		'Value');
				plot_minorgrid	= get(check_minorgrid,	'Value');
				
				if plot_grid
					grid(ax,'on')
				else
					grid(ax,'off')
				end
				
				if plot_minorgrid
					set(ax,'XMinorGrid','on')
					set(ax,'YMinorGrid','on')
				else
					set(ax,'XMinorGrid','off')
					set(ax,'YMinorGrid','off')
				end
				
	
			end
		end
		
		
	end
	
	
	
end
