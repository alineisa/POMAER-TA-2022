folders = {'00-classes'
           '00-common'
           '00-others'
           '00-db_components'
           '01-geometric'
           '02-aerodynamics'
           'CURVAS'
            };

cd 'MACACO'
addpath(genpath(pwd))

for i=1:length(folders)
	f = folders{i};
		cd (f)
		addpath(genpath(pwd))
		cd ..
end

cd ..
clear f folders i

folders =  {'Perfis_dat'
           'Perfis_salvos'};

for i=1:length(folders)
	f = folders{i};
		cd (f)
		addpath(genpath(pwd))
		cd ..
end
clear f folders i
