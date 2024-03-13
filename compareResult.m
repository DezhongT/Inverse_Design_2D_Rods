clc; clear all; close all;
% read the data from txt file
data = importdata("Config/train_temp.txt");
S = data(:, 1);
X = data(:, 2);
Y = data(:, 3);

h(1) = plot(X, Y, 'o');
hold on;
axis equal;

% read the data from txt file
data = importdata("Result/baseline_temp.txt");
h(2) = plot(data(:,1), data(:,2), 'k--');

%
data = importdata("Result/noisyBaseLine_temp.txt");
h(3) = plot(data(:,1), data(:,2), 'b');


data = load("numerical_temp.mat");
a = load("param.mat");
s = linspace(0, 1, 101);
kap0 = data.kap0;
Theta1 = cumtrapz(s, kap0);
% add rotation to Theta1
Theta1 = Theta1 - Theta1(1) + a.theta0;
Config = generateConfigFromTheta(Theta1, s);
h(4) = plot(Config(:,1), Config(:,2), 'r');

legend(h,{'Noisy Data','Baseline', ...
    'Noisy fitting', 'Numerical optimization'},'location','southeast', 'Interpreter', 'latex')
num = 2;
name = sprintf("case-%g.png", num);
exportgraphics(gcf,name,'Resolution',300)
