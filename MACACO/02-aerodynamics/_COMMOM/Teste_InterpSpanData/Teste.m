clear all; clc; close all

p1 = Airfoil('-file','p1.txt');
p2 = Airfoil('-file','p2.txt');
p3 = Airfoil('-file','p3.txt');

plane = Airplane;

plane.LiftingSurfaces(1).Geo.C		= [1 1 .5];
plane.LiftingSurfaces(1).Geo.Yb		= [0 1 2];

plane.LiftingSurfaces(2)			= LiftingSurface('HT');
plane.LiftingSurfaces(2).Geo.C		= [1 1 .5];
plane.LiftingSurfaces(2).Geo.Yb		= [0.5 1 1.5];
plane.LiftingSurfaces(2).Geo.Dihedral = [0 0];
plane.LiftingSurfaces(2).Geo.pos.x	= 3;
plane.LiftingSurfaces(2).Geo.pos.y	= .5;
plane.LiftingSurfaces(2).Geo.pos.z  = 0;

plane.UpdateGeo;

plane.LiftingSurfaces(1).Aero.Airfoils.Data			= [p1 p2 p3];
plane.LiftingSurfaces(1).Aero.Airfoils.InterpType	= [1 1];
plane.LiftingSurfaces(1).Aero.Mesh.Ny				= [10 10];
plane.LiftingSurfaces(1).Aero.Mesh.TypeY			= [2 2];

plane.LiftingSurfaces(2).Aero.Airfoils.Data			= [p1 p2 p3];
plane.LiftingSurfaces(2).Aero.Airfoils.InterpType	= [1 1];
plane.LiftingSurfaces(2).Aero.Mesh.Ny				= [10 10];
plane.LiftingSurfaces(2).Aero.Mesh.TypeY			= [2 2];



plane.UpdateAeroMesh;
plane.PlotMesh

Repan		= ones(length(plane.Aero.Mesh.Yb),1);
alpha_eff	= ones(length(plane.Aero.Mesh.Yb),1)*5*pi/180;


[cl_visc] = InterpSpanData(plane,Repan,alpha_eff,1);
[out]     = InterpSpanData(plane,Repan,alpha_eff,2);

figure(1)
plot(plane.LiftingSurfaces(1).Aero.Mesh.Yb0,cl_visc( plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(2)),'-o'); hold on
plot(plane.LiftingSurfaces(2).Aero.Mesh.Yb0,cl_visc( plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(2)),'-*'); grid minor; grid on


figure(2)
plot(plane.LiftingSurfaces(1).Aero.Mesh.Yb0,out( plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(2),1),'-o'); hold on
plot(plane.LiftingSurfaces(2).Aero.Mesh.Yb0,out( plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(2),1),'-o'); grid minor; grid on

figure(3)
plot(plane.LiftingSurfaces(1).Aero.Mesh.Yb0,out( plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(1).Aero.Mesh.IndexOnMergedMesh(2),2),'-o'); hold on
plot(plane.LiftingSurfaces(2).Aero.Mesh.Yb0,out( plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(1):plane.LiftingSurfaces(2).Aero.Mesh.IndexOnMergedMesh(2),2),'-o'); grid minor; grid on
