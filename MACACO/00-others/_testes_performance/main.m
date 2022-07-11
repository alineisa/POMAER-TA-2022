clear all; close all
clc

n = 1:10000:1e6;
n=round(logspace(0,6,100));
% n = [100 500 1000 10000 1e5 1e6];

rfun = zeros(length(n),1);
rscr = zeros(length(n),1);

for k=1:length(n)

slow_wrapper = SlowWrapper(n(k));
tic;
  for x = 1:numel(slow_wrapper.A)
    slow_wrapper.set_next(x);
  end
tobj = toc;


A = zeros(n(k),1);
next = 0;
tic;
  for x = 1:numel(A)
    next = next+1;
    A(next) = x;
  end
tscr = toc;


A = zeros(n(k),1);
next = 0;
tic;
  for x = 1:numel(A)
    next = set_next(next);
    A(next) = x;
  end
tfun = toc;

rfun(k) = tobj/tfun;
rscr(k) = tobj/tscr;

end
figure
semilogx(n,rfun)
figure
semilogx(n,rscr)
