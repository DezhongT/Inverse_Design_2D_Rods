close; clc; clear all;

h = figure;
hold on

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
% colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow
number_of_colors = 6;
mycolor = parula(number_of_colors); 
error = zeros(4,1);

lineNumber = 3;

interval = 1;

df = importdata("randomPath_eta_15_noise_0.mat");

pred_base = df.pred_config_base;
x0 = pred_base(1:interval:end, 1);
y0 = pred_base(1:interval:end, 2);

pred_noise = df.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);

error(1) = sqrt(sum(([x0; y0] - [x; y]).^2, 1));

df = importdata("randomPath_eta_15_noise_0.001.mat");
pred_noise = df.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);
plot(x, y, 'LineStyle', '-.', 'Color', mycolor(2,:), 'LineWidth',lineNumber)
error(2) = sqrt(sum(([x0; y0] - [x; y]).^2, 1));


df = importdata("randomPath_eta_15_noise_0.002.mat");
pred_noise = df.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);
plot(x, y, 'LineStyle', '--', 'Color', mycolor(3,:), 'LineWidth',lineNumber)
error(3) = sqrt(sum(([x0; y0] - [x; y]).^2, 1));

df = importdata("randomPath_eta_15_noise_0.003.mat");
pred_noise = df.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);
plot(x, y, 'LineStyle', ':', 'Color', mycolor(4,:), 'LineWidth',lineNumber)
error(4) = sqrt(sum(([x0; y0] - [x; y]).^2, 1));

plot(x0, y0, 'LineStyle', '-', 'Color', 'red', 'LineWidth', lineNumber)

error

xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;

view([0, 90])
axis off;

ylim([-0.1, 0.31])
xlim([-0.45, 0.05])

pWidth = 4; % inches
pHeight = 3;
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

saveas(h, 'fig_pred_noise.pdf');