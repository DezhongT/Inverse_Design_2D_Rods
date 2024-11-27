clc; clear all; close all;

Degree = [6, 11, 16];

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  3.5  ; % inches
pHeight = 3.5 * 3/ 4 ;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 

h1 =figure(1);
hold on;

lineNumbebr = 3.0;

hold on;

symlog = @(y) sign(y) .* log10(abs(y) + 1);


name = sprintf("../LetterA_degree_6.mat");
load(name);

plot(S(1:end-1), symlog(diff(Theta)./diff(S)), 'k-', ...
    'LineWidth',lineNumbebr, 'DisplayName', 'Raw data');

mystyle = {':', '--', '-.'};
for i = 1:3
    degree = Degree(i);
    name = sprintf("../LetterA_degree_%d.mat", Degree(i));
    load(name);

    y_symlog = symlog(theta);

    % plot(S, y_symlog);
    p = plot(S, symlog(theta1), 'Color', mycolor(i,:),  'LineStyle', mystyle(i), ...
    'LineWidth',lineNumbebr);
    p.Color(4) = 0.75;
end

h1 =figure(1);
hold on;
box on;


yticks = [-10 -1 0 1 10 50];
yticklabels = arrayfun(@num2str, yticks, 'UniformOutput', false);
set(gca, 'YTick', symlog(yticks), 'YTickLabel', yticklabels);

xlabel(gca, 'Normalized arc length, $\tilde{s}$', 'interpreter', 'latex','FontSize',FONTSIZE)
ylabel(gca, 'Derivative of rotation angle, $\theta''$', 'interpreter', 'latex','FontSize',FONTSIZE);

set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);


saveas(gcf, '4.pdf');