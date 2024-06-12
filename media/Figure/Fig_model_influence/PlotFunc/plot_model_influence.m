clc; clear all; close all;

Degree = [6, 11, 16];

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  3.5 ; % inches
pHeight = 3.5/4*3;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 

h1 = figure(1);

lineNumbebr = 3.0;

hold on;

symlog = @(y) sign(y) .* log10(abs(y) + 1);


name = sprintf("../LetterA_degree_6.mat");
load(name);

plot(S, symlog(Theta), 'k-', ...
    'LineWidth',lineNumbebr, 'DisplayName', 'Raw data');

mystyle = {':', '--', '-.'};
for i = 1:3
    degree = Degree(i);
    name = sprintf("../LetterA_degree_%d.mat", Degree(i));
    load(name);

    y_symlog = symlog(theta);

    % plot(S, y_symlog);
    plot(S, symlog(theta), 'Color', mycolor(i,:), 'LineStyle', mystyle(i), ...
    'LineWidth',lineNumbebr);
end


hold on;
box on;

lineNumbebr = 3.0;

xticks = [0 0.5 1];
yticks = [-10 -5 -1 -0.5 -0.1 0 0.5];
% set(gca,'xticklabel',{[]})

yticklabels = arrayfun(@num2str, yticks, 'UniformOutput', false);
set(gca, 'YTick', symlog(yticks), 'YTickLabel', yticklabels);

xlabel(gca, 'Arc length, $s$', 'interpreter', 'latex','FontSize',FONTSIZE)
ylabel(gca, 'Rotation angle, $\theta$', 'interpreter', 'latex','FontSize',FONTSIZE);


set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(h1, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);
saveas(h1, '3.pdf');