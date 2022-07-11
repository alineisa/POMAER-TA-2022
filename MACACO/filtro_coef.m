function [output, penal] = filtro_coef(vlm_bruto)
% Filtro de valores NaN e divergï¿½ncias

output = vlm_bruto;    
coefmax = 3.5;
is_nan=0;

% Verifica se ha pontos fora
for alpha1 = 1:length(vlm_bruto)
    if ~isfinite(vlm_bruto(alpha1).CL) ||  abs(vlm_bruto(alpha1).CL)>=coefmax
%        fprintf('\n Divergencia alpha = %.2f \r',vlm_bruto(alpha1).alpha)
       is_nan=1;
    end
end

% Apenas roda se ha pontos fora
penal = 0; 
if is_nan
    is_nan = 0;

%Transforma bruto em coef com vetores de coeffs
for pos = 1:length(vlm_bruto)
    outliers=0;
%     coef_novo(ls)=coef(ls);
    coef.CL(pos)=vlm_bruto(pos).CL;
    coef.CD(pos)=vlm_bruto(pos).CD;
    coef.Cm25(pos)=vlm_bruto(pos).Cm25;
end

for alpha2 = 1:length(coef.CL)
    if ~isfinite(coef.CL(alpha2)) ||  abs(coef.CL(alpha2))>=coefmax
        coef.CL(alpha2)=100; %forcando a ser outlier
        coef.CD(alpha2)=30; %forcando a ser outlier
        coef.Cm25(alpha2)=30; %forcando a ser outlier   
        outliers=outliers+1;
    end
end


%% ================= FILTRO ESTATISTICO =================
% fora = find(abs(coef(ls).CL)>coefmax);

%         warning('Ha um ponto de divergencia de coeffs vindo do VLM. Os valores serao considerados outliers e filtrados com base no teste do "Desvio Generalizado Extremo de Student" (GESD test) e interpolados por spline de ordem cubica')
        disp('Foi encontrado um outlier. Continue rodando!');
        coef.CL  = filloutliers(coef.CL,'spline','gesd','MaxNumOutliers',outliers);
        coef.CD  = filloutliers(coef.CD,'spline','gesd','MaxNumOutliers',outliers);
        coef.Cm25 = filloutliers(coef.Cm25,'spline','gesd','MaxNumOutliers',outliers);

%% ================= DEVOLUCAO =================

for alpha3=1:length(coef.CL)
      output(alpha3).CL=coef.CL(alpha3);
      output(alpha3).CD=coef.CD(alpha3);
      output(alpha3).Cm25=coef.Cm25(alpha3);
end
%% =================Filtro linear de valores NaN de plane=================

% for ii = 1:length(fora)    
% 	if fora(ii) == 1
% 		coef_novo(ls).CL(fora(ii)) = coef.CL(fora(ii) + 1)-(coef.CL(fora(ii) + 2)-coef.CL(fora(ii) + 1));
%         coef_novo(ls).CL = filloutliers(coef(ls).CL,'spline','gesd');
%         coef_novo(ls).CD(fora(ii)) = coef.CD(fora(ii) + 1)-(coef.CD(fora(ii) + 2)-coef.CD(fora(ii) + 1));
%         coef_novo(ls).CD = filloutliers(coef(ls).CD,'spline','gesd')
%         coef_novo(ls).Cm25(fora(ii)) = coef.Cm25(fora(ii) + 1)-(coef.Cm25(fora(ii) + 2)-coef.Cm25(fora(ii) + 1));
%         coef_novo(ls).Cm25 = filloutliers(coef(ls).Cm25,'spline','gesd')
%     elseif fora(ii) == 2
%             coef_novo(ls).CL(fora(ii)) = (coef_novo(ls).CL(fora(ii) - 1)+coef_novo(ls).CL(fora(ii) + 1))/2;
%             coef_novo(ls).CD(fora(ii)) = (coef_novo(ls).CD(fora(ii) - 1)+coef_novo(ls).CD(fora(ii) + 1))/2;
%             coef_novo(ls).Cm25(fora(ii)) = (coef_novo(ls).Cm25(fora(ii) - 1)+coef_novo(ls).Cm25(fora(ii) + 1))/2;
% 	elseif fora(ii) == length(coef)
% 		coef_novo(ls).CL(fora(ii)) = coef_novo(ls).CL(fora(ii) - 1)+(coef_novo(ls).CL(fora(ii) - 1)-(coef_novo(ls).CL(fora(ii) - 2)));
%         coef_novo(ls).CD(fora(ii)) = coef_novo(ls).CD(fora(ii) - 1)+(coef_novo(ls).CD(fora(ii) - 1)-(coef_novo(ls).CD(fora(ii) - 2)));
%         coef_novo(ls).Cm25(fora(ii)) = coef_novo(ls).Cm25(fora(ii) - 1)+(coef_novo(ls).Cm25(fora(ii) - 1)-(coef_novo(ls).Cm25(fora(ii) - 2)));
% 	else
% 		coef_novo(ls).CL(fora(ii)) = coef_novo(ls).CL(fora(ii) - 1)+(coef_novo(ls).CL(fora(ii) - 1)-(coef_novo(ls).CL(fora(ii) - 2)));
%         coef_novo(ls).CD(fora(ii)) = coef_novo(ls).CD(fora(ii) - 1)+(coef_novo(ls).CD(fora(ii) - 1)-(coef_novo(ls).CD(fora(ii) - 2)));
%         coef_novo(ls).Cm25(fora(ii)) = coef_novo(ls).Cm25(fora(ii) - 1)+(coef_novo(ls).Cm25(fora(ii) - 1)-(coef_novo(ls).Cm25(fora(ii) - 2)));
%     end
% end

%% =================Filtro linear de valores NaN de plane_trimagem=================
 
%  for i = 1:length(coef.CLarf)
%     if isnan(coef.CLarf(i))
%         coef.CLarf(i)=1000;
%         warning('Ha valores NaN de w.CLarf vindo do VLM. Para todos os casos, o NaN sera atribuido CLarf=1000 e filtrado por interpolacao linear')
%     end
% end
%  
%  fora_arf = find(abs(coef.CLarf)>coefmax);
%  
% for ii = 1:length(fora_arf)    
% 	if fora_arf(ii) == 1
% 		coef_novo(k).CLarf(fora_arf(ii)) = coef.CLarf(fora_arf(ii) + 1)-(coef.CLarf(fora_arf(ii) + 2)-coef.CLarf(fora_arf(ii) + 1));
%         coef_novo(k).CDarf(fora_arf(ii)) = coef.CDarf(fora_arf(ii) + 1)-(coef.CDarf(fora_arf(ii) + 2)-coef.CDarf(fora_arf(ii) + 1));
%         coef_novo(k).Cm25arf(fora_arf(ii)) = coef.Cm25arf(fora_arf(ii) + 1)-(coef.Cm25arf(fora_arf(ii) + 2)-coef.Cm25arf(fora_arf(ii) + 1));
%     elseif fora_arf(ii) == 2
%             coef_novo(k).CLarf(fora_arf(ii)) = (coef_novo(k).CLarf(fora_arf(ii) - 1)+coef_novo(k).CLarf(fora_arf(ii) + 1))/2;
%             coef_novo(k).CDarf(fora_arf(ii)) = (coef_novo(k).CDarf(fora_arf(ii) - 1)+coef_novo(k).CDarf(fora_arf(ii) + 1))/2;
%             coef_novo(k).Cm25arf(fora_arf(ii)) = (coef_novo(k).Cm25arf(fora_arf(ii) - 1)+coef_novo(k).Cm25arf(fora_arf(ii) + 1))/2;
% 	elseif fora_arf(ii) == length(coef)
% 		coef_novo(k).CLarf(fora_arf(ii)) = coef_novo(k).CLarf(fora_arf(ii) - 1)+(coef_novo(k).CLarf(fora_arf(ii) - 1)-(coef_novo(k).CLarf(fora_arf(ii) - 2)));
%         coef_novo(k).CDarf(fora_arf(ii)) = coef_novo(k).CDarf(fora_arf(ii) - 1)+(coef_novo(k).CDarf(fora_arf(ii) - 1)-(coef_novo(k).CDarf(fora_arf(ii) - 2)));
%         coef_novo(k).Cm25arf(fora_arf(ii)) = coef_novo(k).Cm25arf(fora_arf(ii) - 1)+(coef_novo(k).Cm25arf(fora_arf(ii) - 1)-(coef_novo(k).Cm25arf(fora_arf(ii) - 2)));
% 	else
% 		coef_novo(k).CLarf(fora_arf(ii)) = coef_novo(k).CLarf(fora_arf(ii) - 1)+(coef_novo(k).CLarf(fora_arf(ii) - 1)-(coef_novo(k).CLarf(fora_arf(ii) - 2)));
%         coef_novo(k).CDarf(fora_arf(ii)) = coef_novo(k).CDarf(fora_arf(ii) - 1)+(coef_novo(k).CDarf(fora_arf(ii) - 1)-(coef_novo(k).CDarf(fora_arf(ii) - 2)));
%         coef_novo(k).Cm25arf(fora_arf(ii)) = coef_novo(k).Cm25arf(fora_arf(ii) - 1)+(coef_novo(k).Cm25arf(fora_arf(ii) - 1)-(coef_novo(k).Cm25arf(fora_arf(ii) - 2)));
%     end
% end

end
for alpha1 = 1:length(vlm_bruto)
    if ~isfinite(vlm_bruto(alpha1).CL) ||  abs(vlm_bruto(alpha1).CL)>=coefmax
%        fprintf('\n Divergencia alpha = %.2f \r',vlm_bruto(alpha1).alpha)
       penal = 1;
       disp('Outlier não corrigido, ARD triste :( ') 
    end
end

end
