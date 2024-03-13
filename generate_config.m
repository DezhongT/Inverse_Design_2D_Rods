clc; clear all; close all;
%% define the parameters 
lower_bound = -10;
upper_bound = 10;
coeff = lower_bound + (upper_bound - lower_bound) * rand(6, 1);

eta = 10;
like_prior = 0.003; % noise

%%
syms x;
theta = @(x) polyval(coeff, x); 

s = linspace(0, 1, 100);
Theta = theta(s);
Config = generateConfigFromTheta(Theta, s);

dis = diff(Config);
dis = sqrt(sum(dis.^2, 2));
dis = cumsum(dis);
dis = [0; dis];

%% add noise
X = Config(:, 1);
Y = Config(:, 2);
X = X + like_prior * randn(size(X));
Y = Y + like_prior * randn(size(Y));
Config_noise = [X, Y];
dis_n = diff(Config_noise);
dis_n = [0; sqrt(sum(dis_n.^2, 2))];
dis_n = cumsum(dis_n);



plot(Config(:,1), Config(:,2), 'o-');
hold on;
axis equal;
plot(X, Y, '^');

theta00 = theta(0);

n_pi = floor(abs(theta00)/(2*pi));
theta0 = theta00 + sign(0 - theta00) * n_pi * 2*pi;


mkdir("Config")
fid = fopen("Config/train_temp.txt", 'w');
fid1 = fopen("Config/train_temp_noise.txt", 'w');
for i = 1:length(Config)
    fprintf(fid, "%f %f %f\n", dis(i), Config(i, :));
    fprintf(fid1, "%f %f %f\n", dis_n(i), X(i), Y(i));
end
fclose(fid);
fclose(fid1);
