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
np.random.seed(4)

noise = 3e-3
eta = 15  # eta = rho A g / EI
degree = 15
B = [0, 5]

Config, Config_noise = generate_config_from_scratch(noise = noise)

# Constant
qx_func = lambda x: 0
qy_func = lambda x: -1

dqx_func = lambda x: 0
dqy_func = lambda x: 0

# # Constant
# qx_func = lambda x: 1
# qy_func = lambda x: 0

# dqx_func = lambda x: 0
# dqy_func = lambda x: 0

# # Linear
# qx_func = lambda x: 0
# qy_func = lambda x: -x

# dqx_func = lambda x: 0
# dqy_func = lambda x: -1 

# # Nonlinear
# qx_func = lambda x: np.cos(2 * np.pi * x)
# qy_func = lambda x: np.sin(2 * np.pi * x)

# dqx_func = lambda x: -2 * np.pi * np.sin(2 * np.pi * x)
# dqy_func = lambda x: 2 * np.pi * np.cos(2 * np.pi * x)

Kap0_base, natural_config_base, BCs = compute_theory(Config, eta, qx_func, qy_func, dqx_func, dqy_func, degree=degree)
pred_config_base = forward_solver(Kap0_base, Config[:, 0], eta, BCs, qx_func, qy_func)
print("Completed baseline")

Kap0_noise, natural_config_noise, BCs = compute_theory(Config_noise, eta, qx_func, qy_func, dqx_func, dqy_func, degree = degree)
pred_config_noise = forward_solver(Kap0_noise, Config_noise[:, 0], eta,  BCs, qx_func, qy_func)
print("Completed noise baseline")

Kap0_opt, natural_config_opt, BCs = numerical_optimization(Config_noise, Kap0_noise, eta, BCs, qx_func, qy_func, degree=degree-1, max_iter=3000)
pred_config_opt = forward_solver(Kap0_opt, Config_noise[:, 0], eta, BCs, qx_func, qy_func)
print("Completed opt")

Data = {"natural_config_base" : natural_config_base, "natural_config_noise" : natural_config_noise,
        "natural_config_opt" : natural_config_opt, "pred_config_base": pred_config_base,
        "pred_config_noise": pred_config_noise, "pred_config_opt" : pred_config_opt, 
        "natural_config_detection": Config_noise}

print(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat')
savemat(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat', Data)

plt.plot(Config[:, 1], Config[:, 2],  'k--' , label = "Original shape")
plt.plot(pred_config_base[:, 0], pred_config_base[:, 1], label = "Pred base")
plt.plot(pred_config_noise[:, 0], pred_config_noise[:, 1], label = "Pred noise")
plt.plot(pred_config_opt[:, 0], pred_config_opt[:, 1], label = "Pred opt")

plt.plot(natural_config_base[:, 0], natural_config_base[:, 1], label = "Natural base")
plt.plot(natural_config_noise[:, 0], natural_config_noise[:, 1], label = "Natural noise")
plt.plot(natural_config_opt[:, 0], natural_config_opt[:, 1], label = "Natural opt")
plt.axis('equal')
plt.legend()
plt.show()