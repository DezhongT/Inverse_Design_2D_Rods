function res = bcfunc1(ya, yb)
% start with the pin boundary
global theta2 theta eta
res = [
       ya(1) + theta2(0) - eta*cos(theta(0))
       yb(1) + theta2(1)
      ];


end