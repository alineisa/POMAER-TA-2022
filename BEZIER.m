function [X,Y,val] = CASTELJAU(a,b,p,y)

% function val = CASTELJAU(a,b,p,y)
%
% INPUT:  a   Linke Intervallgrenze
%         b   Rechte Intervallgrenze
%         p   Stützstellen (nx2-Matrix)
%         y   Auswertungspunkte (Spaltenvektor)
%
% OUTPUT: val   Werte des Bezierpolynoms an y (mx2-Matrix)
%
% Date:   2007-11-05
% Author: Jonas Ballani
n = size(p,1);
m = length(y);
T = zeros(n,n);
val = zeros(m,2);
X(:,1) = p(:,1);
Y(:,1) = p(:,2);

for j = 1:m
    for i = 2:n
        X(i:n,i) = (b-y(j))/(b-a)*X(i-1:n-1,i-1) + (y(j)-a)/(b-a)*X(i:n,i-1);
        Y(i:n,i) = (b-y(j))/(b-a)*Y(i-1:n-1,i-1) + (y(j)-a)/(b-a)*Y(i:n,i-1);
    end
    val(j,1) = X(n,n);
    val(j,2) = Y(n,n);
end
 
  
  