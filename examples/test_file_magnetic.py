import matplotlib.pyplot as plt
import numpy as np
from scipy.io import savemat
from utils import generate_config_from_txt , generate_config_from_scratch
from solver import compute_theory, forward_solver, numerical_optimization, numerical_optimization_magnetic
import sys
from utils import compute_theta
from numpy import cos, sin
from scipy.integrate import solve_bvp, cumulative_trapezoid
from scipy.interpolate import interp1d, CubicSpline
from solver import forward_solver_magnetic

# np.random.seed(42)
# np.random.seed(40)
np.random.seed(25)

noise = 1e-3
eta = 10  # eta = rho A g / EI
degree = 10
B = [-1, 0]

Config, Config_noise = generate_config_from_scratch(noise = noise)

qx_func = lambda x: 0
qy_func = lambda x: 0

dqx_func = lambda x: 0
dqy_func = lambda x: 0

Kap0, natural_config, BCs = compute_theory(Config_noise, eta, qx_func, qy_func, dqx_func, dqy_func, degree=degree)
pred_config_base = forward_solver_magnetic(Kap0, Config[:, 0], eta, BCs, B)
print("Completed prediction")

Kap0_opt, natural_config_opt, BCs = numerical_optimization_magnetic(Config_noise, Kap0, eta, BCs, B, degree = degree-1, max_iter=3000, lr = 0.1)
pred_config_opt = forward_solver_magnetic(Kap0_opt, Config_noise[:, 0], eta, BCs, B)
print("Completed opt")

Data = {"natural_config_opt" : natural_config_opt, "pred_config_base": pred_config_base,
        "pred_config_opt" : pred_config_opt, "natural_config_detection": Config_noise}

print(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat')
savemat(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat', Data)

plt.plot(Config[:, 1], Config[:, 2],  'k--' , label = "Original shape")
plt.plot(pred_config_base[:, 0], pred_config_base[:, 1], label = "Pred base")

plt.plot(pred_config_opt[:, 0], pred_config_opt[:, 1], label = "Pred opt")
plt.axis('equal')
plt.legend()
plt.show()