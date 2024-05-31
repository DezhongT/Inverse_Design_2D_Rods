clc; clear all; close all;

Degree = [6, 11, 16];

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  4 * 1.5 ; % inches
pHeight = 3 * 1.5;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 

h1 =figure(1);
hold on;

lineNumbebr = 1.0;

hold on;

symlog = @(y) sign(y) .* log10(abs(y) + 1);


name = sprintf("../LetterA_degree_6.mat");
load(name);

plot(S, symlog(Theta), 'k--', ...
    'LineWidth',lineNumbebr, 'DisplayName', 'Raw data');

for i = 1:3
    degree = Degree(i);
    name = sprintf("../LetterA_degree_%d.mat", Degree(i));
    load(name);

    y_symlog = symlog(theta);

    % plot(S, y_symlog);
    plot(S, symlog(theta), 'Color', mycolor(i,:), ...
    'LineWidth',lineNumbebr, 'DisplayName', sprintf("Fitted model, degree = %d", degree));
end

FONT = 'Arial';
FONTSIZE = 12;
pWidth =  4 * 1.5 ; % inches
pHeight = 3  * 1.5;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 

h1 =figure(1);
hold on;
box on;

lineNumbebr = 1.0;

yticks = [-10 -5 -1 -0.5 -0.1 0 0.5];
yticklabels = arrayfun(@num2str, yticks, 'UniformOutput', false);
set(gca, 'YTick', symlog(yticks), 'YTickLabel', yticklabels);


% set(gca, 'YScale', 'log');
lgd = legend('show');
lgd.Orientation = 'horizontal'; % Set the legend orientation to horizontal
lgd.Location = "northoutside";
lgd.Position = [0.5, 0.8, 0.37, 0.01]; % Adjust these values as needed
lgd.Interpreter = 'latex'; % Use LaTeX interpreter
lgd.FontName = 'CMU Serif'; % Set font to LaTeX Computer Modern
lgd.FontSize = 10; % Set font size
lgd.NumColumns = 1;


xlabel(gca, 'Arc length, $s$', 'interpreter', 'latex','FontSize',30)
ylabel(gca, 'Rotation angle, $\theta$', 'interpreter', 'latex','FontSize',30);


% legend(h1,{'Theory baseline','Noise baseline', 'Proposed scheme'},...
%     'location','northoutside', 'Orientation','horizontal', 'Interpreter','latex');

set(gca,'fontsize',12,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);


saveas(gcf, '2.pdf');
% exportgraphics(h1, '1.pdf');



% % Sample data
% x = linspace(0, 10, 10);
% y = sin(x);
% yerr = 0.2 + 0.2 * sqrt(x);
% 
% % Create the error bar plot
% figure;
% errorbar(x, y, yerr, 'o-', 'LineWidth', 1.5, 'CapSize', 10);
% 
% % Customize the plot
% title('Error Bar Plot Example');
% xlabel('X-axis');
% ylabel('Y-axis');
% grid on;
