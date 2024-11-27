close; clc; clear all;

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  3.5 ; % inches
pHeight = pWidth /4*3 ;

h = figure;
hold on

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
mycolor = colpos;

interval1 = 1;
interval2 = 15;
interval3 = 8;
lineNumber = 2;

df = importdata('sine_eta_5_rotation_0.mat');

pred_noise = df.pred_config_noise;
x = pred_noise(1:interval2:end, 1);
y = pred_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',lineNumber)

natural_noise = df.natural_config_noise;
x = natural_noise(1:interval2:end, 1);
y = natural_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumber)

noise_base = df.natural_config_detection;
x = noise_base(1:interval3:end, 2);
y = noise_base(1:interval3:end, 3);
scatter(x, y, 20, 'MarkerEdgeColor', mycolor(4,:), 'MarkerFaceColor', mycolor(4,:), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.8);

df = importdata('sine_eta_5_rotation_-90.mat');

pred_noise = df.pred_config_noise;
x = pred_noise(1:interval2:end, 1);
y = pred_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',lineNumber)

natural_noise = df.natural_config_noise;
x = natural_noise(1:interval2:end, 1);
y = natural_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumber)

noise_base = df.natural_config_detection;
x = noise_base(1:interval3:end, 2);
y = noise_base(1:interval3:end, 3);
scatter(x, y, 20, 'MarkerEdgeColor', mycolor(4,:), 'MarkerFaceColor', mycolor(4,:), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.8);

df = importdata('sine_eta_5_rotation_-180.mat');

pred_noise = df.pred_config_noise;
x = pred_noise(1:interval2:end, 1);
y = pred_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',lineNumber)

natural_noise = df.natural_config_noise;
x = natural_noise(1:interval2:end, 1);
y = natural_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumber)

noise_base = df.natural_config_detection;
x = noise_base(1:interval3:end, 2);
y = noise_base(1:interval3:end, 3);
scatter(x, y, 20, 'MarkerEdgeColor', mycolor(4,:), 'MarkerFaceColor', mycolor(4,:), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.8);

df = importdata('sine_eta_5_rotation_90.mat');

pred_noise = df.pred_config_noise;
x = pred_noise(1:interval2:end, 1);
y = pred_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',lineNumber)

natural_noise = df.natural_config_noise;
x = natural_noise(1:interval2:end, 1);
y = natural_noise(1:interval2:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumber)

noise_base = df.natural_config_detection;
x = noise_base(1:interval3:end, 2);
y = noise_base(1:interval3:end, 3);
scatter(x, y, 20, 'MarkerEdgeColor', mycolor(4,:), 'MarkerFaceColor', mycolor(4,:), 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.8);

xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid off;
box on;

view([0, 90])


xlabel(gca, '$x$ [m]', 'interpreter', 'latex','FontSize',FONTSIZE)
ylabel(gca, '$y$ [m]', 'interpreter', 'latex','FontSize',FONTSIZE);

set(gca,'xticklabel',{[0 0.2 0.4 0.6 0.8 1.0]})

set(gca,'fontsize', FONTSIZE,'TickLabelInterpreter','latex');

set(h, 'Units', 'inches', 'Position', [1, 1, pWidth, pHeight]);
set(h, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

saveas(h, '6.pdf')

% Function to generate a tube around a parametric curve
function [X, Y, Z] = tubeplot(x, y, z, radius, n)
    if nargin < 5
        n = 20; % Number of sides of the tube
    end
    if nargin < 4
        radius = 0.1; % Default radius
    end

    % Calculate the derivatives
    dx = gradient(x);
    dy = gradient(y);
    dz = gradient(z);
    
    % Normalize the direction vectors
    dd = sqrt(dx.^2 + dy.^2 + dz.^2);
    dx = dx ./ dd;
    dy = dy ./ dd;
    dz = dz ./ dd;
    
    % Create an orthogonal vector
    ex = -dy;
    ey = dx;
    ez = zeros(size(dz));
    
    % Normalize the orthogonal vector
    len = sqrt(ex.^2 + ey.^2 + ez.^2);
    ex = ex ./ len;
    ey = ey ./ len;
    ez = ez ./ len;
    
    % Cross product to get the third orthogonal vector
    [tx, ty, tz] = crossProduct(dx, dy, dz, ex, ey, ez);
    
    % Parametric circle
    theta = linspace(0, 2*pi, n);
    cosTheta = cos(theta);
    sinTheta = sin(theta);
    
    % Generate the tube
    X = zeros(length(x), n);
    Y = zeros(length(y), n);
    Z = zeros(length(z), n);
    
    for i = 1:length(x)
        X(i, :) = x(i) + radius * (ex(i) * cosTheta + tx(i) * sinTheta);
        Y(i, :) = y(i) + radius * (ey(i) * cosTheta + ty(i) * sinTheta);
        Z(i, :) = z(i) + radius * (ez(i) * cosTheta + tz(i) * sinTheta);
    end
end

% Cross product helper function
function [cx, cy, cz] = crossProduct(ax, ay, az, bx, by, bz)
    cx = ay .* bz - az .* by;
    cy = az .* bx - ax .* bz;
    cz = ax .* by - ay .* bx;
end

