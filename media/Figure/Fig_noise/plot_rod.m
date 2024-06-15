clear;clc;close all

h1 = figure;
hold on
interval = 1;
colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
mycolor = colpos;

df = importdata('randomPath_eta_15_noise_0.0015.mat');

natural_base = df.natural_config_base;
x = natural_base(1:interval:end, 1);
y = natural_base(1:interval:end, 2);
z = zeros(size(x));
[X, Y, Z] = tubeplot(x, y, z, 0.005, 20);
h = surf(X, Y, Z, 'FaceColor', mycolor(3,:), 'EdgeColor', 'none');

pred_base = df.pred_config_base;
x = pred_base(1:interval:end, 1);
y = pred_base(1:interval:end, 2);
z = zeros(size(x));
[X, Y, Z] = tubeplot(x, y, z, 0.005, 20);
surf(X, Y, Z, 'FaceColor', mycolor(1,:), 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis


camlight; lighting phong;

xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
axis off;

ylim([-0.1, 0.31])
xlim([-0.45, 0.05])

view([0, 90])


pWidth = 3.5; % inches
pHeight = pWidth * 3 / 4;
set(h1, 'Units', 'inches', 'Position', [1, 1, pWidth, pHeight]);
set(h1, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);

exportgraphics(h1, '1.pdf','Resolution',600)

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

