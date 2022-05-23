delay = 3;
mataxfoil_cont = 90;

    for i = 1:8
    cd(['X' num2str(i)])
    delete(['mataxfoil' num2str(i) '.bat'])
    name = ['mataxfoil' num2str(i) '.bat'];
	mat=fopen(name,'w');
	
	% 		fprintf(mat,'@echo off\n');
	fprintf(mat,'set xfoil=xfoil%d.exe\n',i);
	fprintf(mat,'timeout %2.0f\n',delay);
	
	fprintf(mat,'set /a k=0\n');
	fprintf(mat,':start\n');
	fprintf(mat,'set /a k+=1\n');
	fprintf(mat,'if %%k%%==%3.0f goto fim\n',mataxfoil_cont);
	fprintf(mat,'echo %%k%%\n');
	
	fprintf(mat,'tasklist > %%TEMP%%\\tasks.txt\n');
	fprintf(mat,'  find /i "%%xfoil%%" %%TEMP%%\\tasks.txt > nul\n');
	
	fprintf(mat,'  if errorlevel 1 goto :ERR\n');
	fprintf(mat,'    echo xfoil aberto\n');
	fprintf(mat,'  goto start\n');
	
	fprintf(mat,'  :ERR\n');
	fprintf(mat,'    echo xfoil fechado\n');
	fprintf(mat,'    exit\n');
	
	fprintf(mat,':fim\n');
	fprintf(mat,'TASKKILL /F /IM xfoil%d.exe\n',i);
	fprintf(mat,'exit\n');
	
	fclose all;
    cd ..
    end