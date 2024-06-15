data = importdata("train_temp.txt");

x = data(:, 2);
y = data(:, 3);
z = zeros(size(x));

[X, Y, Z] = tubeplot(x(45:55), y(45:55), z(45:55), 0.01, 20);
[X, Y, Z] = tubeplot(x, y, z, 0.01, 20);
figure;
surf(X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'none');

camlight('headlight');  % Add default headlight for better visualization
light('Position', [0 0 1.0], 'Style', 'local', 'Color', [0.5, 0.5, 0.5]);  % Light source in positive z-axis


camlight; lighting phong;
% title('Smooth Rod');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;

view([0, 90])
axis off;

exportgraphics(gcf, 'rod.pdf', 'Resolution', 300);  % 300 DPI



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

