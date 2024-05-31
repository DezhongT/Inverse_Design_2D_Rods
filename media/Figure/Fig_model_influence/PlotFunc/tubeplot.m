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

