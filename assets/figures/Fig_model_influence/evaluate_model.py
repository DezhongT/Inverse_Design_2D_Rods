import matplotlib.pyplot as plt
import numpy as np

from utils import generate_config_from_txt , generate_config_from_scratch
from solver import compute_theory, forward_solver, numerical_optimization
from utils import compute_theta

Config, Config_noise = generate_config_from_txt("patterns/letterA.txt",  noise = 0.0e-4, rotation = np.pi/2)

eta = 10.0 # definie the eta
degree = 6 # define the degree of polynominal for theta



S = Config[:, 0]
X = Config[:, 1]
Y = Config[:, 2]
Theta = compute_theta(S, X, Y)
p = np.polyfit(S, Theta, degree)
theta = lambda x : np.polyval(p, x)
dp1 = np.polyder(p)
theta1 = lambda x : np.polyval(dp1, x)

Kap0_base, natural_config_base, BCs = compute_theory(Config, eta, degree=degree)
pred_config_base = forward_solver(Kap0_base, Config[:, 0], eta,  BCs)

# plt.plot(S, Theta)
# plt.plot(S, theta(S), 'o')

plt.plot(X, Y)
plt.plot(pred_config_base[:, 0], pred_config_base[:, 1], 'o')
plt.axis("equal")
plt.show()

Data = { "pred_config_base": pred_config_base, "Theta" : Theta, "theta": theta(S), "S": S , "theta1": theta1(S)}
Data = {"Config": Config}
import scipy.io
scipy.io.savemat('LetterA_Config.mat', Data)

# dis = sqrt(sum(dis.^2, 2));
# dis = cumsum(dis);
# dis = [0; dis];

