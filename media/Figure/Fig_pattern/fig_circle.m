close; clc; clear all;

h = figure;
hold on

colpos = [0 166 81;237 28 36;0 174 239; 247 148 30 ]/255; 
% colors, 1 black; 2 green; 3 red; 4 blue; 5 yellow
number_of_colors = 6;
mycolor = parula(number_of_colors); 

lineNumber = 3;

df = importdata("circle_eta_15.mat");

interval = 1;
pred_base = df.pred_config_base;
x = pred_base(1:interval:end, 1);
y = pred_base(1:interval:end, 2);
z = zeros(size(x));

[X, Y, Z] = tubeplot(x, y, z, 0.005, 20);
surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis

camlight; lighting phong;

interval = 3;
pred_noise = df.pred_config_noise;
x = pred_noise(1:interval:end, 1);
y = pred_noise(1:interval:end, 2);
plot(x, y, 'LineStyle', '-', 'Color', mycolor(4,:), 'Marker', 'o', 'LineWidth', lineNumber)

pred_opt = df.pred_config_opt;
x = pred_opt(1:interval:end, 1);
y = pred_opt(1:interval:end, 2);
plot(x, y, 'LineStyle', '-', 'Color', mycolor(5,:), 'Marker', '^', 'LineWidth', lineNumber)

interval = 1;
natural_base = df.natural_config_base;
x = natural_base(1:interval:end, 1);
y = natural_base(1:interval:end, 2);
plot(x, y, 'LineStyle', '--', 'Color', mycolor(1,:), 'LineWidth', lineNumber)
plot(x, y, 'LineStyle', '--', 'Color', 'r', 'LineWidth', lineNumber)

natural_noise = df.natural_config_noise;
x = natural_noise(1:interval:end, 1);
y = natural_noise(1:interval:end, 2);
plot(x, y, 'LineStyle', ':', 'Color', mycolor(2,:), 'LineWidth', lineNumber)


natural_opt = df.natural_config_opt;
x = natural_opt(1:interval:end, 1);
y = natural_opt(1:interval:end, 2);
plot(x, y, 'LineStyle', '-.', 'Color', mycolor(3,:), 'LineWidth', lineNumber)

xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;

view([0, 90])
axis off;

% ylim([-0.1, 0.31])
% xlim([-0.45, 0.05])

pWidth = 4; % inches
pHeight = 3;
set(gcf, 'PaperUnits','inches', 'PaperPosition',[0 0 pWidth pHeight], ...
    'PaperSize', [pWidth pHeight]);
saveas(h, 'fig_circle.pdf');



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


