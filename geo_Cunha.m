function geo_Cunha(geo)
p = geo;
clearvars geo
geo.s.perfil = [32 32 32 32
                10 10 10 10
                23 23 23 23];
p.LiftingSurface.pos = -p.LiftingSurface.pos;
geo.s.pos = p.LiftingSurface.pos;                           % Passando para eixos de estabilidade
geo.s.pos(:,1) = p.cg.pos(1)*ones(3,1) + p.LiftingSurface.pos(:,1);
geo.s.pos(:,3) = p.cg.pos(3)*ones(3,1) + p.LiftingSurface.pos(:,3);
geo.s.b = p.LiftingSurface.b;
geo.s.c = p.LiftingSurface.c;
geo.s.d = p.LiftingSurface.d;
geo.s.e = p.LiftingSurface.e;
geo.s.twist = p.LiftingSurface.twist;
geo.s.ai = p.LiftingSurface.incidence(:,1);
geo.section_number = p.LiftingSurface.section_num;
geo.surfacenum = length(geo.s.b(:,1));
geo.o.panel         = 10;                                                    % Numero de paineis por secao de LS (Ideal: 25)
geo.o.itermax       = 10;                                                    % Numero de iteracoes maximas (Ideal: 20)
save('geo.mat','geo')
end