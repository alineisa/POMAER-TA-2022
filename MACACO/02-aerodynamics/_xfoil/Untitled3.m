clear; clc; close all
data=importdata('pol.dat',' ',12);


str = strjoin(data.textdata(:,1));
% str=data.textdata(:,1)
mach = get_par(str, 'Mach =')
Re = get_par(str, 'Re =')
Ncrit = get_par(str, 'Ncrit =')
xtrf_t = get_par(str, 'xtrf =')
xtrf_b = get_par(str, '(top)')
v = get_par(str, 'Version')
% perfil = regexp(str,'Calculated polar for: \w+','match')
function [val] = get_par(str, var)

	regex_num = '[ ]*[0-9]+\.[0-9]+[ ]*e*[ ]*[0-9]*';
	pattern = [var, regex_num];
	
	val = regexp(str,pattern,'match');
	val = regexp(val,regex_num,'match');
	if ~isempty(val)
		val = strjoin(val{:});
		val = val(~isspace(val));
		val = str2num(val);
	end
end
