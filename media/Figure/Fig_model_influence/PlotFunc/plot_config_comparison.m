clc; clear all; close all;

load("../LetterA_Config.mat");

x = Config(:, 2);
y = Config(:, 3);
z = -0.2*ones(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.005, 200);

Degree = [6, 11, 16];

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  4 * 1.5 ; % inches
pHeight = 3 * 1.5;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 
lineNumbebr = 1.0;

h1 =figure(1);
hold on;
box on;
surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'DisplayName', "Target shape");

marker = ['o', '^', '.'];
for i = 1:3
    degree = Degree(i);
    name = sprintf("../LetterA_degree_%d.mat", Degree(i));
    load(name);

    plot(pred_config_base(:,1), pred_config_base(:,2), 'Color', mycolor(i,:), ...
    'LineWidth',lineNumbebr,'marker', marker(i), 'DisplayName', sprintf("Fitted model, degree = %d", degree));
end


camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

axis equal;


lgd = legend('show');
lgd.Orientation = 'horizontal'; % Set the legend orientation to horizontal
lgd.Location = "northoutside";
% lgd.Position = [0.5, 0.95, 0.05, 0.05]; % Adjust these values as needed
lgd.Interpreter = 'latex'; % Use LaTeX interpreter
lgd.FontName = 'CMU Serif'; % Set font to LaTeX Computer Modern
lgd.FontSize = 10; % Set font size
lgd.NumColumns = 2;


view([0, 90])

set(gca,'fontsize',12,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

xlabel(gca, '$x$', 'interpreter', 'latex','FontSize',30)
ylabel(gca, '$y$', 'interpreter', 'latex','FontSize',30);


saveas(gcf, '3.pdf');

exportgraphics(gcf, 'rodA.png', 'Resolution', 300);  % 300 DPI