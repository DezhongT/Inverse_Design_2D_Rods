clc; clear all; close all;

load("../LetterC_Config.mat");

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  1.75; % inches
pHeight = pWidth / 4*3;

x = Config(:, 2);
y = Config(:, 3);
z = zeros(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.005, 200);

h1 = figure;
surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

axis equal;

view([0, 90])
axis off;

set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

saveas(gcf, '2.pdf');



