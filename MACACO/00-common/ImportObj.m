function [ obj ] = ImportObj( file )

% Function that allows to import saved objects (.mat files) renaming it.

aux = load(file);
obj = getfield(aux,char(fields(aux)));

end

