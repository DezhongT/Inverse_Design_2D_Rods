function config = generateConfigFromTheta(Theta, s)
dxds = cos(Theta);
dyds = sin(Theta);

X = cumtrapz(s, dxds);
Y = cumtrapz(s, dyds);

config = [X; Y]';


end