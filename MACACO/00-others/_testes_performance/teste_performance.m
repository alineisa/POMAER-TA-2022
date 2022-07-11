warning off
close all

p=struct(plane);

n=1;
for k=1:1000

	
	i1=tic;
	for i=1:1000
% 		p.LiftingSurfaces(1).geo.mesh.Verts(1).v1 = p.LiftingSurfaces(1).geo.mesh.Verts(1).v2;
% 		a=p;
		b= p.LiftingSurfaces(1).geo.X25(1)*2;
	end
	t1=toc(i1);
	
	
	i2=tic;
	for i=1:1000
% 		plane.LiftingSurfaces(1).geo.mesh.Verts(n).v1 = plane.LiftingSurfaces(1).geo.mesh.Verts(n).v2;
% 		c=plane;
		d= plane.LiftingSurfaces(1).geo.X25(1)*2;
	end
	t2=toc(i2);
	
	


	r(k) = t2/t1;

end



plot(r); grid on
disp(mean(r))
disp(std(r))
