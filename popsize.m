
function [Popsize,Valobj,NAVsize] = popsize(fname,D,XVmin,XVmax,dynpop,NP,F,CR,strategy,xpop,xfun);

clear xpopord better popincr dycont uiiaux

n_afo=0;

xfun=xfun';

if dynpop < NP 

xpopord=[];

better=sort(xfun(:,1));
Valobj=better(1:dynpop);

dynpop;

NP;
    
ix1=1;
ix2=1;

xpop;
xfun;

[xpop xfun];

 for ix1=1:NP
  xoptsize=better(ix1);   
  
  for ix2=1:NP
   if xfun(ix2,1)==xoptsize
    xpopord(ix1,:)=xpop(ix2,:);
   end
  end
  
 end
 clear xpop
 [xpopord  better];
 xpopord(1:dynpop,:);
 xpop=xpopord(1:dynpop,:);
 
end

if dynpop > NP
 popincr=[];   
 dycont=dynpop-NP;
 
for idycont=1:dycont
n_afo=n_afo+1;    
uiiaux=[];
muiiaux = rand(1,D) < CR;
mpooaux = muiiaux < 0.9; 

auxcand=randperm(NP);
uiiaux = xpop(auxcand(1),1:D) + F*(xpop(auxcand(2),1:D) - xpop(auxcand(3),1:D));      
uiiaux = xpop(auxcand(1),1:D).*mpooaux + uiiaux.*muiiaux;   
  
for jjc=1:D
 if uiiaux(1,jjc)<XVmin(jjc);
   uiiaux(1,jjc)=XVmin(jjc);
 end
 if uiiaux(1,jjc)>XVmax(jjc);
  uiiaux(1,jjc)=XVmax(jjc);
 end
end


popincr(idycont,:)=uiiaux(1,:);
vcfo(idycont)=feval(fname,uiiaux(1,:),[],[0 0 0]);  

end

xpop=[xpop;popincr];

Valobj=[xfun;vcfo'];

end

NAVsize=n_afo;

Popsize=[];
Popsize=xpop;






                                      




