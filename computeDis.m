function dis = computeDis(config)

dConfig = diff(config);

dS = sum(dConfig.^2, 2);

dS = sqrt(dS);
dis = sum(dS);

end