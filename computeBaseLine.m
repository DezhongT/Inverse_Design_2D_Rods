clc; clear all; close all;

data = importdata("Config/train_temp.txt");

scale = 1.0/data(end, 1);
data = scale * data;

S = data(:, 1);
X = data(:, 2);
Y = data(:, 3);

Theta = computeTheta(S, X, Y);

global theta theta1 theta2 theta3 theta4 eta;
degree = 5;
p = polyfit(S, Theta, degree);
theta = @(x) polyval(p, x);
dp1 = polyder(p);
theta1 = @(x) polyval(dp1, x);
dp2 = polyder(dp1);
theta2 = @(x) polyval(dp2, x);
dp3 = polyder(dp2);
theta3 = @(x) polyval(dp3, x);
dp4 = polyder(dp3);
theta4 = @(x) polyval(dp4, x);


eta = 20; % control parameters rho * g/ EI ## 1, 20, 50
smesh = linspace(0, 1, 101);
solint = bvpinit(smesh, @guessFunc);
sol = bvp5c(@bvpfun, @bcfunc1, solint);



s = linspace(0, 1, 101);
Theta = theta(s);
currentConfig = generateConfigFromTheta(Theta, s);
dis = computeDis(currentConfig);

s = sol.x;
dKap = -sol.y(1,:);
s_interp = linspace(0, 1, 101);
dKap = interp1(s, dKap, s_interp);
s = s_interp;
Kap = cumtrapz(s, dKap);
% free end Kap0
Kap0 = theta1(1);
Kap = Kap + Kap0 - Kap(end);
Theta1 = cumtrapz(s, Kap);
% add rotation to Theta1
Theta1 = Theta1 - Theta1(1) + Theta(1);
Config = generateConfigFromTheta(Theta1, s);
dis1 = computeDis(Config);

plot(currentConfig(:,1), currentConfig(:,2), 'bo');
hold on;
plot(Config(:,1), Config(:,2));
axis equal;

%% save result
theta0 = theta(0);
save("param.mat", "eta", "theta0");


mkdir("Result")
fid = fopen("Result/baseline_temp.txt", 'w');
for i = 1:length(Config)
    fprintf(fid, "%f %f\n", Config(i, :));
end
fclose(fid);
