function dkapds = bvpfun(s, kap)
global theta theta1 theta2 theta3 theta4 eta
% kap(1) kap; kap(2) dkap; kap(3) ddkap
% dkapds = [
%             kap(2);
%             (eta * theta2(s)*kap(2)- eta*theta1(s)^3*kap(1)+...
%             eta*theta4(s)*theta1(s) - eta*theta3(s)*theta2(s)-...
%             eta*theta2(s)*(cos(theta(s))- theta1(s)^3)-...
%             2*eta^2 * sin(theta(s))*theta1(s)^2)/(eta*theta1(s));
%          ];

dkapds = [
            kap(2);
            (eta * theta2(s)*kap(2)- eta*theta1(s)^3*kap(1)-...
            eta*theta4(s)*theta1(s) + eta*theta3(s)*theta2(s)+...
            eta*theta2(s)*(eta*cos(theta(s))- theta1(s)^3)+...
            2*eta^2 * sin(theta(s))*theta1(s)^2)/(eta*theta1(s));
         ];



end