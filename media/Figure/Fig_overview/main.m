close; clc; clear all;

figure;
hold on

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
% colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow
number_of_colors = 4;
mycolor = parula(number_of_colors); 
mycolor = colpos;
lineNumbebr = 2;

df = importdata("randomPath_eta_15.mat");
interval = 2;

noise_base = df.natural_config_detection;
x = noise_base(:, 2);
y = noise_base(:, 3);
plot(x,y, 'LineStyle','none', 'Marker', '.', 'Color', mycolor(4,:), 'MarkerSize',20)

natural_base = df.natural_config_base;
x = natural_base(1:interval:end, 1);
y = natural_base(1:interval:end, 2);
plot(x, y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumbebr)

pred_base = df.pred_config_base;
x = pred_base(1:interval:end, 1);
y = pred_base(1:interval:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',2)



% title('Smooth Rod');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;

view([0, 90])
axis off;

exportgraphics(gcf, 'rod.pdf', 'Resolution', 300);  % 300 DPI
