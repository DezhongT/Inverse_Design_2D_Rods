close; clc; clear all;

FONT = 'Arial';
FONTSIZE = 10;
pWidth =  3.5 ; % inches
pHeight = pWidth /4*3 ;

h = figure;
hold on

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
mycolor = colpos;

interval = 1;
df = importdata('randomPath_eta_15_noise_0.002.mat');

natural_base = df.natural_config_base;
x = natural_base(1:interval:end, 1);
y = natural_base(1:interval:end, 2);
z = zeros(size(x));
[X, Y, Z] = tubeplot(x, y, z, 0.005, 20);
h1 = surf(X, Y, Z, 'FaceColor', mycolor(3,:), 'EdgeColor', 'none');
h1.FaceAlpha = 0.5;

pred_base = df.pred_config_base;
x = pred_base(1:interval:end, 1);
y = pred_base(1:interval:end, 2);
z = zeros(size(x));
[X, Y, Z] = tubeplot(x, y, z, 0.005, 20);
h2 = surf(X, Y, Z, 'FaceColor', mycolor(1,:), 'EdgeColor', 'none');
h2.FaceAlpha = 0.25;

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis
camlight; lighting phong;

lineNumber = 2;

interval = 3;

df = importdata("randomPath_eta_15_noise_0.002.mat");
pred_opt = df.pred_config_opt;
x = pred_opt(1:interval:end, 1);
y = pred_opt(1:interval:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', '^', 'Color', mycolor(1,:), 'LineWidth',lineNumber)

natural_opt = df.natural_config_opt;
x = natural_opt(1:interval:end, 1);
y = natural_opt(1:interval:end, 2);
plot(x,y, 'LineStyle', '-', 'Marker', 'o', 'Color', mycolor(3,:), 'LineWidth',lineNumber)

xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid off;
box on;

view([0, 90])

ylim([-0.1, 0.31])
xlim([-0.45, 0.05])

xlabel(gca, '$x$ [m]', 'interpreter', 'latex','FontSize',FONTSIZE)
ylabel(gca, '$y$ [m]', 'interpreter', 'latex','FontSize',FONTSIZE);

set(gca,'xticklabel',{[0 0.2 0.4 0.6 0.8 1.0]})

set(gca,'fontsize', FONTSIZE,'TickLabelInterpreter','latex');

set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

pWidth = 3.5; % inches
pHeight = pWidth * 3 / 4;
set(h, 'Units', 'inches', 'Position', [1, 1, pWidth, pHeight]);
set(h, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

exportgraphics(h, '2.pdf','Resolution',600)

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

