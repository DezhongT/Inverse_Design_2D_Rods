function theta = computeTheta(S, X, Y)
spline_fit_X = spline(S, X);
spline_fit_Y = spline(S, Y);

spline_dX_dS = fnder(spline_fit_X, 1);
spline_dY_dS = fnder(spline_fit_Y, 1);


dX_dS = ppval(spline_dX_dS, S);
dY_dS = ppval(spline_dY_dS, S);

Theta = atan2(dY_dS, dX_dS);


% update theta
for i = 1:99
    while abs(Theta(i+1) - Theta(i)) > 1.05 * pi
        Theta(i+1) = Theta(i+1) - 2*sign(Theta(i+1)-Theta(i))*pi;
    end
end

% theta = spline(S, Theta);
theta = Theta;


plot(S, Theta, 'o-');

a = 'tdz';

end