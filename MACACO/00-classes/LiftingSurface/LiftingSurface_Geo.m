classdef LiftingSurface_Geo < handle
	%LIFTINGSURFACES_GEO
	
	
	% Para  o  correto  funcionamento  da  classe eh necessario acrescentar
	%    "01-geometrico" no path: addpath('01-geometrico')
	
	properties
		ID
		YSymmetry  = 1;								% Symmetry about XZ plane

		pos = struct('x',0,...
					 'y',0,...
					 'z',0)
		C											% (INPUT) Chord at each station
		Yb											% (INPUT) Span-Wise coordinate
		Dihedral									% (INPUT) Diehedral angle related to xy plane at each station [deg]
		Sweep										% (INPUT) Sweep angle at 0.25*C(Y) for each station [deg]
		
		Incidence = 0								% (INPUT) Incidence angle refered to horizontal (+: nose up) [deg]
		Incidence_xcr = 0.25						% (INPUT) Position relative to the root chord where Incidence will be apllied (0:LE / 1:TE)
		Incidence_axis = [0 1 0]					% (INPUT) Axis in wich incidence will be applied
		
		TwistY										% (INPUT) Geometrical twist at each statio (+: nose up) [deg]
		TwistZ
		
		
		SweepTE										% (OUTPUT) Sweep angle at the Trailing Edge [deg]
		SweepLE										% (OUTPUT) Sweep angle at the Leading Edge [deg]
		
		Area = struct(	'Sx',[],...					% (OUTPUT) Projected Area on yz plane [m^2]
						'Sy',[],...					% (OUTPUT) Projected Area on xz plane [m^2]
						'Sz',[],...					% (OUTPUT) Projected Area on xy plane [m^2] (It takes into account the geometric twist!!!)
						'SYb',[],...				% (OUTPUT) Area on Yb reference (m^2)(Area of the panels)
						'Sref',[],...				% (OUTPUT) Reference area [m^2] (Used for non dimensionalization of the aerodynamic coefficients)
						'Swet',[])					% (OUTPUT) Wet Area
		
		XYZ = struct('LE',[],...					% (OUTPUT) Coordinates of Leadind and Trailing Edges, and Quarter Chord of the sections
			         'TE',[],...
					 'C25',[])					 
		
				
		MAC											% (OUTPUT) Mean aerodynamic chord
		MAC_Pos										% (OUTPUT) Mean aerodynamic chord position[m]

				 
		AR											% (OUTPUT) Aspect Ratio
		b											% (OUTPUT) Total span (distance between tips) [m]
		b2											% (OUTPUT) Semi span  (distance between y=0 and the right tip)
		TaperRatio									% (OUTPUT) Taper Ratio Vector
		
		
	end
	

	methods
		
% =========================================================================
%       OVERALL UPDATE
% =========================================================================
		function obj = LiftingSurface_Geo(ID)
			obj.ID = ID;
		end
		
		function obj = Update (obj)
			
			nsec = length(obj.Yb);	% Numero de estacoes
			npan = nsec-1;			% Numero de paineis
			
			
			
			% Airfoil data
			% -----------------------------------------------
			
				
			
			% Dihedral, Twist and Sweep initialization
			% -----------------------------------------------
			if  isempty(obj.TwistY);	obj.TwistY	 = zeros(1,nsec)	;end
			if  isempty(obj.TwistZ);	obj.TwistZ	 = zeros(1,nsec)	;end
			if  isempty(obj.Dihedral);	obj.Dihedral = zeros(1,npan)	;end
			if  isempty(obj.Sweep);		obj.Sweep    = zeros(1,npan)	;end
			
			
			% Other calculations
			% -----------------------------------------------
			
			% Y-Z at 0.25*C calculation
			obj = obj.SweepLineCoordinates;
			
			% Sweep at LE and TE calculation
			obj = obj.SweepUpdate;
			
			% Leading and Traling edges Coordinates
			obj = obj.LTECoordinates;
			
			% Span and Semi-Span
			obj = obj.bUpdate;
			
			% Areas
			obj = obj.SUpdate;
			
			% Aspect-Ratio
			obj = obj.ARUpdate;
			
			% Mean Aerodynamic chord
			obj = obj.MACUpdate;
			
			% Taper Ratio
			obj = obj.TaperRatioUpdate;
			
			
% 			obj.p_plot(obj)
			
		end
		
		
% =========================================================================
%       GEOMETRICAL METHODS
% =========================================================================		
		
		function [ obj ] = SweepLineCoordinates( obj )
			nsec = length(obj.Yb);
			obj.XYZ.C25(1,1) = obj.pos.x;
			obj.XYZ.C25(1,2) = obj.pos.y + obj.Yb(1);
			obj.XYZ.C25(1,3) = obj.pos.z;
			for i=2:nsec
				obj.XYZ.C25(i,2) = obj.XYZ.C25(i-1,2) + (obj.Yb(i)-obj.Yb(i-1))*cosd(obj.Dihedral(i-1));
				obj.XYZ.C25(i,3) = obj.XYZ.C25(i-1,3) + (obj.Yb(i)-obj.Yb(i-1))*sind(obj.Dihedral(i-1));
				
				% Line-Plane angle equation: https://www.vitutor.com/geometry/distance/line_plane.html
				obj.XYZ.C25(i,1) = obj.XYZ.C25(i-1,1) + sqrt( (-(obj.XYZ.C25(i,2)-obj.XYZ.C25(i-1,2))^2    ...
					                                           -(obj.XYZ.C25(i,3)-obj.XYZ.C25(i-1,3))^2) / ...
														(1-1/(sind(obj.Sweep(i-1))^2)) );
			end
			
			
			xref = obj.Incidence_xcr*obj.C(1) + (obj.pos.x-.25*obj.C(1));
			for i=1:nsec
 				vet_i = [ obj.XYZ.C25(i,1)-xref, 0, obj.XYZ.C25(i,3)-obj.pos.z];
				vet_f = RodriguesRotation(vet_i,obj.Incidence_axis,obj.Incidence);
				obj.XYZ.C25(i,1) = vet_f(1) + xref;
				obj.XYZ.C25(i,3) = vet_f(3) + obj.pos.z;
			end
		end
		
		
% -------------------------------------------------------------------------		

		function [ obj ] = LTECoordinates( obj )

			npan = length(obj.Yb)-1;

			for i=1:npan+1

				obj.XYZ.LE(i,1) = obj.XYZ.C25(i,1) - 0.25*obj.C(i)*cosd(obj.TwistY(i))*cosd(obj.TwistZ(i));
				obj.XYZ.TE(i,1) = obj.XYZ.C25(i,1) + 0.75*obj.C(i)*cosd(obj.TwistY(i))*cosd(obj.TwistZ(i));

				obj.XYZ.LE(i,2) = obj.XYZ.C25(i,2) + 0.25*obj.C(i)*sind(obj.TwistZ(i));
				obj.XYZ.TE(i,2) = obj.XYZ.C25(i,2) - 0.75*obj.C(i)*sind(obj.TwistZ(i));

				obj.XYZ.LE(i,3) = obj.XYZ.C25(i,3) + 0.25*obj.C(i)*sind(obj.TwistY(i));
				obj.XYZ.TE(i,3) = obj.XYZ.C25(i,3) - 0.75*obj.C(i)*sind(obj.TwistY(i));
				
				
            end
			
            % Diedro + Incidência
            xref = obj.Incidence_xcr*obj.C(1) + (obj.pos.x-.25*obj.C(1));
            for i=1:npan+1
				vet_i = [ obj.XYZ.LE(i,1)-xref, 0, obj.XYZ.LE(i,3)-obj.pos.z];
				vet_f = RodriguesRotation(vet_i,obj.Incidence_axis,obj.Incidence);
				obj.XYZ.LE(i,1) = vet_f(1)+obj.pos.x;
				obj.XYZ.LE(i,3) = vet_f(3)+obj.pos.z;
				
				vet_i = [ obj.XYZ.TE(i,1)-xref, 0, obj.XYZ.TE(i,3)-obj.pos.z];
				vet_f = RodriguesRotation(vet_i,obj.Incidence_axis,obj.Incidence);
				obj.XYZ.TE(i,1) = vet_f(1)+obj.pos.x;
				obj.XYZ.TE(i,3) = vet_f(3)+obj.pos.z;
                aux=obj.XYZ.LE-obj.XYZ.TE;
                aux=-aux/4+obj.XYZ.LE;

			end
			obj.XYZ.C25=aux;
			
		end
		
% -------------------------------------------------------------------------		
		function [ obj ] = SweepUpdate( obj )
			
			npan = length(obj.Yb)-1;
			for i=1:npan
				obj.SweepLE(i) = SweepTransfer(obj.C(i),obj.C(i+1),(obj.XYZ.C25(i+1,2)-obj.XYZ.C25(i,2)), 0.25, 0.00, obj.Sweep(i));
				obj.SweepTE(i) = SweepTransfer(obj.C(i),obj.C(i+1),(obj.XYZ.C25(i+1,2)-obj.XYZ.C25(i,2)), 0.25, 1.00, obj.Sweep(i));
			end
			
		end
		

% -------------------------------------------------------------------------		
		function [ obj ] = bUpdate ( obj )	
			
			obj.b2 = max(abs(obj.Yb));
			if obj.YSymmetry
				obj.b = 2*obj.b2;
			else
				obj.b = obj.b2;
			end
			
		end
% -------------------------------------------------------------------------		
		function [ obj ] = SUpdate ( obj )	
			
			% projected areas (It takes into account the geometric twist!!!)
			Sx2_i = zeros(length(obj.Yb)-1,1);
			Sy2_i = zeros(length(obj.Yb)-1,1);
			Sz2_i = zeros(length(obj.Yb)-1,1);
			for i=1:length(obj.Yb)-1
				x1 = obj.XYZ.LE(i  ,1);
				y1 = obj.XYZ.LE(i  ,2);
				z1 = obj.XYZ.LE(i  ,3);
				
				x2 = obj.XYZ.LE(i+1,1);
				y2 = obj.XYZ.LE(i+1,2);
				z2 = obj.XYZ.LE(i+1,3);
				
				x3 = obj.XYZ.TE(i+1,1);
				y3 = obj.XYZ.TE(i+1,2);
				z3 = obj.XYZ.TE(i+1,3);
				
				x4 = obj.XYZ.TE(i,  1);
				y4 = obj.XYZ.TE(i,  2);
				z4 = obj.XYZ.TE(i,  3);

				% Ref.: http://mathforum.org/library/drmath/view/60583.html
				Sx2_i(i) = (z1*y2 - z2*y1) + (z2*y3 - z3*y2) + (z3*y4 - z4*y3) + (z4*y1 - z1*y4);
				Sy2_i(i) = (x1*z2 - x2*z1) + (x2*z3 - x3*z2) + (x3*z4 - x4*z3) + (x4*z1 - x1*z4);
				Sz2_i(i) = (x1*y2 - x2*y1) + (x2*y3 - x3*y2) + (x3*y4 - x4*y3) + (x4*y1 - x1*y4);

			end
			
			
			obj.Area.Sy = sum(abs(Sy2_i/2));	
			if obj.YSymmetry
				obj.Area.Sx = sum(abs(Sx2_i));
				obj.Area.Sz = sum(abs(Sz2_i));
			else
				obj.Area.Sx = sum(abs(Sx2_i/2));
				obj.Area.Sz = sum(abs(Sz2_i/2));
			end
			
			% Reference area is taken as the largest projected area
			obj.Area.Sref = max([obj.Area.Sx obj.Area.Sy obj.Area.Sz]);

			
			
			SYb_i = zeros(length(obj.Yb)-1,1);
			for i=1:length(obj.Yb)-1
				SYb_i(i) = (obj.C(i+1)  + obj.C(i) ) * ...
						   (obj.Yb(i+1) - obj.Yb(i)) / 2;
			end
			if obj.YSymmetry
				obj.Area.SYb = sum(SYb_i)*2;
			else
				obj.Area.SYb = sum(SYb_i);
			end
			
		end
% -------------------------------------------------------------------------		
		function [ obj ] = MACUpdate ( obj )
			% Update Mean Aerodynamic Chord
			% Calculation reference: source code of GETMAC (getmac.f90) avaiable at: http://www.pdas.com/getmacdownload.html
			
			%#ok<*PROP> (This line is used for matlab to stop showing tips on variables )
			
			C	= obj.C;
			Yb	= obj.Yb; 
			X	= obj.XYZ.C25(:,1);
			Y	= obj.XYZ.C25(:,2);
			Z	= obj.XYZ.C25(:,3);
			
			area = 0;
			mac  = 0;
			xmac = 0;
			ymac = 0;
			zmac = 0;
			
			for i=1:length(Yb)-1
				
				c1		= C(i);
				c2		= C(i+1);
				span	= Yb(i+1) - Yb(i);
				
				
				a_seg	= (c1+c2)*span/2;
				taper	= c2/c1;
				taper1	= taper+1;
				frac	= (taper+taper1)/(3.0*taper1);
				
				mac_seg	 = c1*(taper^2 + taper + 1.0)/(1.5*taper1);
				xmac_seg = X(i) + frac*(X(i+1)-X(i));
				ymac_seg = Y(i) + frac*(Y(i+1)-Y(i));
				zmac_seg = Z(i) + frac*(Z(i+1)-Z(i));
				
				mac  = mac  + mac_seg *a_seg;
				xmac = xmac + xmac_seg*a_seg;
				ymac = ymac + ymac_seg*a_seg;
				zmac = zmac + zmac_seg*a_seg;
				
				area = area + a_seg;
				
			end
			
			mac  = mac /area;
			xmac = xmac/area;
			ymac = ymac/area;
			zmac = zmac/area;
			
			obj.MAC = mac;
			obj.MAC_Pos = [xmac ymac  zmac];
			
		end
		
% -------------------------------------------------------------------------		
		function [ obj ] = ARUpdate( obj )
			obj.AR = obj.b^2/obj.Area.Sref;
		end
		
		function [ obj ] = TaperRatioUpdate( obj )
			nsec = length(obj.Yb)-1;
			obj.TaperRatio=zeros(1,nsec);
			for i=1:nsec
				obj.TaperRatio(1,i) = obj.C(i+1)/obj.C(i);
			end
		end
		
% =========================================================================
%       WAKE METHODS
% =========================================================================


% =========================================================================
%       MOVIMENT METHODS
% =========================================================================

		function [ obj ] = AddRoll( obj, angle )
		end
% -------------------------------------------------------------------------		
		function [ obj ] = AddPitch( obj,angle )
		end
% -------------------------------------------------------------------------	
		function [ obj ] = AddYaw( obj, angle )
		end
% -------------------------------------------------------------------------	
		function [ obj ] = AddTranslationS( obj, dx, dy, dz )
		end
% -------------------------------------------------------------------------	
		function [ obj ] = AddTranslationV( obj, V, t )
		end
% -------------------------------------------------------------------------			
		function [ obj ] = ResetPosition( obj )
		end
	
		
	end
	
	
	
	
	
	
	
	
	
	
	
	
	%% ========================================================================
	%							OTHER METHODS
	%  ========================================================================
	
	methods
		
		

		
		% -----------------------------------------------------------------
		function Plot(obj,handle_axes)

			
			cor=['y';'k';'b';'r';'c';'m';'g'];
			roc=flipud(cor);
			for i=1:length(obj.Yb)-1
				x1 = obj.XYZ.LE(i  ,1);
				x2 = obj.XYZ.LE(i+1,1);
				x3 = obj.XYZ.TE(i+1,1);
				x4 = obj.XYZ.TE(i  ,1);
				
				y1 = obj.XYZ.LE(i  ,2);
				y2 = obj.XYZ.LE(i+1,2);
				y3 = obj.XYZ.TE(i+1,2);
				y4 = obj.XYZ.TE(i  ,2);
				
				z1 = obj.XYZ.LE(i,  3);
				z2 = obj.XYZ.LE(i+1,3);
				z3 = obj.XYZ.TE(i+1,3);
				z4 = obj.XYZ.TE(i,  3);
				
				
				fill3(handle_axes,[x1 x2 x3 x4],[y1 y2 y3 y4],[z1 z2 z3 z4],cor(i))

				line(handle_axes, [obj.XYZ.C25(i,1) obj.XYZ.C25(i+1,1)],...
					  [obj.XYZ.C25(i,2) obj.XYZ.C25(i+1,2)],...
					  [obj.XYZ.C25(i,3) obj.XYZ.C25(i+1,3)],'Color',roc(i))
				
				if obj.YSymmetry
					fill3(handle_axes,[x1 x2 x3 x4],[-y1 -y2 -y3 -y4],[z1 z2 z3 z4],cor(i))
					alpha(.5)
				end
				
				plot3(handle_axes,obj.MAC_Pos(:,1),obj.MAC_Pos(:,2),obj.MAC_Pos(:,3),'+')
			end
			
			xlabel('x');ylabel('y');zlabel('z');
			grid on; grid minor
			axis equal; 
			axis image
		end
	
	end

end

