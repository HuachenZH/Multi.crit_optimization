%% step zero
clear
close all
%% Param
Rint = 0.03;
h = 20;
k = 1.4;

Rstep = 0.005;
Rmin=0.04;
Rmax=0.08;
Lstep = 1;
Lmin=10;
Lmax=40;

%% Decision variable
% it means the variable
% in this case it's rayon r and length l
R=Rmin:Rstep:Rmax;
L=Lmin:Lstep:Lmax;
disp(["Length of vector R: ",length(R)])
disp(["Length of vector L: ",length(L)])


%% Objective function
% The function, the physical equation
Rth=1./(2*pi*h.*R.*L')+log(R./Rint)./(2*pi*k.*L') %résistance thermique
% R in horizontal, L' in vertical
% R gives column number
% L gives line number
V=pi*(R.^2-Rint^2).*L' % V for volume

%% Q1
% Optimal value for Rth, and R and L corresponded
disp(["The min of Rth is ", min(min(Rth))])
[ilig icol]=find(Rth==min(min(Rth)))
%ilig is for L
%icol is for R
disp(["value of R is ", R(icol)])
disp(["value of L is ", L(ilig)])



% Optimal value for V, and R L corresponded
disp(["The min of V is ", min(min(V))])
[ilig icol]=find(V==min(min(V)))
%ilig is for L
%icol is for R
disp(["value of R is ", R(icol)])
disp(["value of L is ", L(ilig)])



%% Decision varialbe space
figure(1)
hold on
for i=1:length(L)
    for j=1:length(R)
        plot(R(j),L(i),'ko');
    end
end
title("Solutions in decision space")
xlabel("values of R")
ylabel("values of L")


%% Objective space
% plot combinaison de Rth et V, les 2 objective functions
figure(2)
hold on
plot(Rth,V,'ko')
title("Objective space")
xlabel("Rth")
ylabel("V")
% plot with two matrixs, is like plot vectors several times


%% Pareto Set
% scale the objective functions
Rthscale=(Rth-min(min(Rth)))./(max(max(Rth))-min(min(Rth)))
Vscale=(V-min(min(V)))./(max(max(V))-min(min(V)))
% lambda is with Rth, so 1-lambda for V
for lambda=0:0.005:1
% ws for weighted sum
ws=lambda.*Rthscale+(1-lambda).*Vscale;
% find them on decision space and solution space
[ilig icol]=find(ws==min(min(ws)));
% remind, ilig is for L, icol is for R
figure(1)
plot(R(icol),L(ilig),'rx')
figure(2)
plot(Rth(ilig,icol),V(ilig,icol),'gx')
end
