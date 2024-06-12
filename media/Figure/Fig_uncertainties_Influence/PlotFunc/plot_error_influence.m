clc; clear all; close all;


load("../LetterA_Config.mat");

Sigma = [0, 2, 4, 6, 8, 10];

Config = Config(:, 2:end);

Base_error_data = zeros(5, 3);
Noise_error_data = zeros(5, 3);
Opt_error_data = zeros(5, 3);

for i = 1:length(Sigma)
    for n = 1:3
        name = sprintf("../LetterA_%gem4_%g.mat", Sigma(i), n);
        load(name);

        diff_base = pred_config_base - Config;
        diff_base = sum(diff_base.^2, 2);
        diff_base = sqrt(diff_base);

        diff_noise = pred_config_noise - Config;
        diff_noise = sum(diff_noise.^2, 2);
        diff_noise = sqrt(diff_noise);

        diff_opt = pred_config_opt - Config;
        diff_opt = sum(diff_opt.^2, 2);
        diff_opt = sqrt(diff_opt);

        diff_base = mean(diff_base);
        diff_noise = mean(diff_noise);
        diff_opt = mean(diff_opt);

        Base_error_data(i, n) = diff_base;
        Noise_error_data(i, n) = diff_noise;
        Opt_error_data(i, n) = diff_opt;

    end
end

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  3.5 ; % inches
pHeight = pWidth /4*3 ;

colpos = [0 0 0;0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; % colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow

number_of_colors = 5;
mycolor = parula(number_of_colors); 

h1 =figure(1);
hold on;

lineNumbebr = 2.0;


mean_value = mean(Base_error_data, 2);
std_value = std(Base_error_data, 0, 2);
% errorbar(Sigma, mean_value, std_value, '--', 'Color', mycolor(1,:), ...
%     'LineWidth',lineNumbebr, 'DisplayName', 'Theory baseline');

plot(Sigma, mean_value, 'k--', 'Color', mycolor(1,:), ...
    'LineWidth',lineNumbebr);
hold on
mean_value = mean(Noise_error_data, 2);
std_value = std(Noise_error_data, 0, 2);
errorbar(Sigma, mean_value, std_value, 'o-', 'Color', mycolor(2,:), ...
    'LineWidth',lineNumbebr);

mean_value = mean(Opt_error_data, 2);
std_value = std(Opt_error_data, 0, 2);
errorbar(Sigma, mean_value, std_value, '^-', 'Color', mycolor(3,:), ...
    'LineWidth',lineNumbebr);

xlabel(gca, 'Measurement error, $\sigma$', 'interpreter', 'latex','FontSize',FONTSIZE)
ylabel(gca, 'Design error, $e$', 'interpreter', 'latex','FontSize',FONTSIZE);

box on

set(gca, 'YScale', 'log');

set(gca,'xticklabel',{[0 0.2 0.4 0.6 0.8 1.0]})

set(gca,'fontsize', FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);


saveas(gcf, '2.pdf');

