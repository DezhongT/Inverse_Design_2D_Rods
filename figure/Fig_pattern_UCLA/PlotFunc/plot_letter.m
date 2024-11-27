clc; clear all; close all;

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  1.75; % inches
pHeight = pWidth / 4*3;

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
mycolor = colpos;

load("../LetterA_Config.mat");

x = Config(:, 2);
y = Config(:, 3);
z = zeros(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.005, 200);

h = figure;
surf(X, Y, Z, 'FaceColor', mycolor(1,:), 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

axis equal;

view([0, 90])
axis off;

set(h, 'Units', 'inches', 'Position', [1, 1, pWidth, pHeight]);
set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

exportgraphics(h, '4.pdf','Resolution',600)


