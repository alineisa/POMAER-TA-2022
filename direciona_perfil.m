function direciona_perfil(base,cambra,espessura)
    for i = 1:length(base)
        nome_aux = [base{i} '_'  num2str(cambra(i)) '_' num2str(espessura(i))];
        salvar_mat = ['P' num2str(i)];
        perfil = ImportObj(nome_aux);
        mat_name_aux = matlab.lang.makeValidName(salvar_mat);
        eval([mat_name_aux  ' = perfil;'])
        save(['MACACO/CURVAS/' matlab.lang.makeValidName(salvar_mat)],mat_name_aux);        
    end  
end