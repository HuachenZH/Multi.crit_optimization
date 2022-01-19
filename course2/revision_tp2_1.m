%% step zero
clear
close all
%% Param
xstep=50;
xstart=50;
xend=1400;

vstep=25;
vstart=25;
vend=500;

k=1; % coef risk
b=0.25*10^-4;

%% Decesion variables
x=xstart:xstep:xend;
disp(["length(x)= ",length(x)])
v=vstart:vstep:vend;
disp(["length(v)= ",length(v)])

%% Objective functions
% x is horizontal, column number = length(x)
% v is vertical, row number = length(y)
Pollution=x.*v'.^2;  % 20*28
Profit=(15-2*x./v').*x-b.*x.*v'.^2;  % 20*28
Risk=k*x;  % 1*28
Risk_scale=(Risk-min(Risk))/(max(Risk)-min(Risk));
Profit_scale=(Profit-min(min(Profit)))./(max(max(Profit))-min(min(Profit))); % 20*28
Pollution_scale=(Pollution-min(min(Pollution)))./(max(max(Pollution))-min(min(Pollution))); % 20*28

%% only consider the profits
disp(["Maximum profit is ",max(max(Profit))])
% find the x and v corresponded
[ilig icol]=find(Profit==max(max(Profit)));
% ilig for v, icol for x
disp(["x corresponded is ", x(icol)])
disp(["v corresponded is ", v(ilig)])

%% max profit, with a given fishing zone. Find best speed
figure(2)
hold on
pcolor(x,v,Profit)
caxis([0,7000])
title("Colormap of Profit")
xlabel("distance x")
ylabel("speed v")

%% consider profit and risk
% the vector for x for max profit :
ProfitQ3=max(Profit);
% scale it :
ProfitQ3_scale=(ProfitQ3-min(ProfitQ3))/(max(ProfitQ3)-min(ProfitQ3)); % one min is sufficient, this is vector but not matrix
Risk_scale; % already computed
lambda=0.5; % lambda is with profit
ws_Q3=lambda*ProfitQ3_scale+(1-lambda)*(1-Risk_scale) % bigger the better

% the maximum score is :
disp(["The max ws is ",max(ws_Q3)])

% find where it is :
ilig=find(ws_Q3==max(ws_Q3));
disp(["Its index is ",ilig])

% plot it
figure(2)
plot(x(ilig),v_q2(ilig),'ro','LineWidth',3)

%% given speed, find distance
figure(3)
hold on
pcolor(x,v,Profit)
caxis([0,7000])
title("Colormap of Profit Q4")
xlabel("distance x")
ylabel("speed v")

max(Profit,[],2);
[a,b]=find(Profit==max(Profit,[],2))
% what we want is b
figure(3)
plot(x(b),v,'g-','LineWidth',3)

%% Pareto for profit-consumption
% We want to max profit and min consumption.
figure(4)
hold on
pcolor(x,v,Profit)
caxis([0,7000])
title("Colormap of Profit Q5")
xlabel("distance x")
ylabel("speed v")

for lambda=0:0.01:1 % lambda is with Profit
WSQ5=Profit_scale*lambda+(1-lambda)*(1-Pollution_scale); % 20*28
% disp(["The max score is" max(max(WSQ5))])
[ilig icol]=find(WSQ5==max(max(WSQ5)));
% ilig for v, icol for x
plot(x(icol),v(ilig),'wo','LineWidth',3)
end

%% three criterias
figure(5)
hold on
pcolor(x,v,Profit)
caxis([0,7000])
title("Colormap of Profit Q5")
xlabel("distance x")
ylabel("speed v")


% lam1=0.3; % lam1 is with Profit
% lam2=0.3; % lam2 is with Pollution
step=0.05
Risk_scale7=Risk_scale.*ones(length(v),1);
for lam1=0:step:0.9
    for lam2=0:step:1-lam1
        
            % make a WS which we will maximise
            ws7=lam1*Profit_scale+lam2*(1-Pollution_scale)+(1-lam1-lam2)*(1-Risk_scale7);
            [ilig icol]=find(ws7==max(max(ws7)));
            plot(x(icol),v(ilig),'wo','LineWidth',3)
        
    end
end

