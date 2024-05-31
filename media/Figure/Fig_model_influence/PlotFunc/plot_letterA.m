clc; clear all; close all;

load("../LetterA_Config.mat");

x = Config(:, 2);
y = Config(:, 3);
z = zeros(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.005, 200);

figure;
surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

axis equal;

view([0, 90])
axis off;

exportgraphics(gcf, 'rodA.png', 'Resolution', 300);  % 300 DPI


% h(1) = plot(Config(:, 2), Config(:, 3), 'k-');

