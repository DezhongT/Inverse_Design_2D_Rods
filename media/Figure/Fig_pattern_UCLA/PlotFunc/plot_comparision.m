clc; clear all; close all;

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  1.75  ; % inches
pHeight = 1.75*3/4 ;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 
lineNumbebr = 3;

load("../LetterA_Config.mat");

x = Config(:, 2);
y = Config(:, 3);
z = -0.01*ones(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.01, 200);


figure;
box on;
hold on;

interval = 5;
camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

axis equal;

view([0, 90])
axis off;

load("../LetterA_eta_15.mat");
plot(natural_config_base(:,1), natural_config_base(:, 2), '--', ...
    "LineWidth", lineNumbebr);
plot(natural_config_opt(:,1), natural_config_opt(:, 2), '--',  ...
    "LineWidth", lineNumbebr);

plot(pred_config_base(1:interval:end,1), pred_config_base(1:interval:end, 2), 'o-', ....
    "LineWidth", lineNumbebr, 'MarkerSize', 5 );
plot(pred_config_opt(1:interval:end,1), pred_config_opt(1:interval:end, 2), '^-',  ...
    "LineWidth", lineNumbebr, "MarkerSize",5);

surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);

set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

exportgraphics(gcf, '16.pdf', 'Resolution', 300);  % 300 DPI



