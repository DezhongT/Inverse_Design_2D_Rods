%% Clear cache
clear; clc; close all

addpath('..\utils\') 

% Initialize the figure and hold the plot
h = figure(1);
hold on

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  8.5 ; % inches
pHeight = pWidth/4*3;

lineNumber = 1;

Aerror = [];
Berror = [];
Cerror = [];

Derror = [];
Eerror = [];
Ferror = [];

cd dataset1
dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.0005
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.0005
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.0005
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

cd ..
cd dataset2

dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.0005
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.0005
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.0005
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

subplot(1,4,1)
title(['$\sigma =$' num2str(0.0005)], 'interpreter', 'latex', 'FontSize', FONTSIZE)
hold on
box on
eta_list = [4 9 14];
error_mean = [mean(Aerror) mean(Berror) mean(Cerror)];
error_std = [std(Aerror) std(Berror) std(Cerror)];
bar(eta_list, error_mean,'FaceColor',"#0072BD", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)

eta_list = [6 11 16];
error_mean = [mean(Derror) mean(Eerror) mean(Ferror)];
error_std = [std(Derror) std(Eerror) std(Ferror)];
bar(eta_list, error_mean,'FaceColor', "#D95319", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)
axis square 

% ylabel('Error, $e$', 'interpreter', 'latex', 'FontSize', FONTSIZE)

cd ..

Aerror = [];
Berror = [];
Cerror = [];

Derror = [];
Eerror = [];
Ferror = [];

cd dataset1
dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.001
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.001
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.001
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

cd ..
cd dataset2

dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.001
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.001
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.001
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end


subplot(1,4,2)
title(['$\sigma =$' num2str(0.001)], 'interpreter', 'latex', 'FontSize', FONTSIZE)
hold on
box on
eta_list = [4 9 14];
error_mean = [mean(Aerror) mean(Berror) mean(Cerror)];
error_std = [std(Aerror) std(Berror) std(Cerror)];
bar(eta_list, error_mean,'FaceColor',"#0072BD", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)

eta_list = [6 11 16];
error_mean = [mean(Derror) mean(Eerror) mean(Ferror)];
error_std = [std(Derror) std(Eerror) std(Ferror)];
bar(eta_list, error_mean,'FaceColor', "#D95319", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)
axis square 

cd ..

Aerror = [];
Berror = [];
Cerror = [];

Derror = [];
Eerror = [];
Ferror = [];

cd dataset1
dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.0015
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.0015
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.0015
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

cd ..
cd dataset2

dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.0015
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.0015
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.0015
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end


subplot(1,4,3)
title(['$\sigma =$' num2str(0.0015)], 'interpreter', 'latex', 'FontSize', FONTSIZE)
hold on
box on
eta_list = [4 9 14];
error_mean = [mean(Aerror) mean(Berror) mean(Cerror)];
error_std = [std(Aerror) std(Berror) std(Cerror)];
bar(eta_list, error_mean,'FaceColor',"#0072BD", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)

eta_list = [6 11 16];
error_mean = [mean(Derror) mean(Eerror) mean(Ferror)];
error_std = [std(Derror) std(Eerror) std(Ferror)];
bar(eta_list, error_mean,'FaceColor', "#D95319", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)
axis square 

cd ..

Aerror = [];
Berror = [];
Cerror = [];

Derror = [];
Eerror = [];
Ferror = [];

cd dataset1
dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.002
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.002
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.002
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

cd ..
cd dataset2

dinfo = dir('random*.mat');
numFiles = length(dinfo);

for i = 1:numFiles
    filename = dinfo(i).name;
    data = readFileInfo(filename);
    if data.eta == 5 && data.noise == 0.002
        Aerror = [Aerror data.error_opt];
        Derror = [Derror data.error_noise];
    end
    if data.eta == 10 && data.noise == 0.002
        Berror = [Berror data.error_opt];
        Eerror = [Eerror data.error_noise];
    end
    if data.eta == 15 && data.noise == 0.002
        Cerror = [Cerror data.error_opt];
        Ferror = [Ferror data.error_noise];
    end
end

subplot(1,4,4)
title(['$\sigma =$' num2str(0.002)], 'interpreter', 'latex', 'FontSize', FONTSIZE)
hold on
box on
eta_list = [4 9 14];
error_mean = [mean(Aerror) mean(Berror) mean(Cerror)];
error_std = [std(Aerror) std(Berror) std(Cerror)];
bar(eta_list, error_mean,'FaceColor',"#0072BD", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)

eta_list = [6 11 16];
error_mean = [mean(Derror) mean(Eerror) mean(Ferror)];
error_std = [std(Derror) std(Eerror) std(Ferror)];
bar(eta_list, error_mean,'FaceColor', "#D95319", 'BarWidth', 0.4);
errorbar(eta_list, error_mean, error_std,"LineStyle","none", 'Color','k', 'LineWidth', lineNumber)
axis square 

cd ..

% Get all subplot handles
hSubplots = findobj(gcf,'Type','Axes');

% Apply labels to all subplots
for i = 1:length(hSubplots)
    xlabel(hSubplots(i), '$\eta$', 'interpreter', 'latex', 'FontSize', FONTSIZE)
    % ylabel(hSubplots(i), 'Error, $e$', 'interpreter', 'latex', 'FontSize', FONTSIZE)
    xticks(hSubplots(i), [5 10 15])
    yticks(hSubplots(i), [0 0.2 0.4 0.6 0.8 1])
    ylim(hSubplots(i), [0 0.4])
    set(hSubplots(i),'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
end

set(gca,'fontsize',FONTSIZE,'TickLabelInterpreter','latex');
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

% exportgraphics(gcf, 'Figure_error.pdf', 'Resolution', 600);
saveas(gcf,'1.pdf')