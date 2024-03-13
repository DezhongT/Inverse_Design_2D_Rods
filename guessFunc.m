function kap = guessFunc(s)
global theta2 theta eta
dkap_0 =  - theta2(0) + eta * cos(theta(0));
dkap_1 = - theta2(1);
kap = [-(s - 1) * (s + dkap_0) + dkap_1
       -(s - 1) - (s + dkap_0)];
kap = [0
       0];

end