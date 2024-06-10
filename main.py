import matplotlib.pyplot as plt
import numpy as np

from utils import generate_config_from_txt , generate_config_from_scratch
from solver import compute_theory, forward_solver, numerical_optimization

# np.random.seed(1000)
# np.random.seed(50)
np.random.seed(12)

# Config, Config_noise = generate_config_from_txt("patterns/letterU.txt",  noise = 0.0e-4, rotation= -np.pi/2.0)
# Config, Config_noise = generate_config_from_txt("patterns/letterC1.txt",  noise = 0.0e-4, rotation= np.pi/2.0)
# Config, Config_noise = generate_config_from_txt("patterns/letterL.txt",  noise = 0.0e-4, rotation= 0.0)
# Config, Config_noise = generate_config_from_txt("patterns/letterA.txt",  noise = 0.0e-4, rotation= np.pi/2.0)
# Config, Config_noise = generate_config_from_scratch(noise = 0.001)
Config, Config_noise = generate_config_from_txt("patterns/sine.txt",  noise = 10e-4, rotation= np.pi/2)

# exit(0)

eta = 5 # definie the eta
degree = 5 # define the degree of polynominal for theta
Kap0_base, natural_config_base, BCs = compute_theory(Config, eta, degree=degree)
pred_config_base = forward_solver(Kap0_base, Config[:, 0], eta,  BCs)

print("Completed baseline")
Kap0_noise, natural_config_noise, BCs = compute_theory(Config_noise, eta, degree = degree)
pred_config_noise = forward_solver(Kap0_noise, Config_noise[:, 0], eta,  BCs)
print("Completed noise baseline")


Kap0_opt, natural_config_opt, BCs = numerical_optimization(Config_noise, Kap0_noise, eta, BCs, degree=degree-1, max_iter=3000)
pred_config_opt = forward_solver(Kap0_opt, Config_noise[:, 0], eta,  BCs)
print("Completed opt")

fig, axs = plt.subplots(1, 2, figsize=(10, 5))
axs[0].plot(Config[:, 1], Config[:, 2],  'k--' , label = "Original shape")
axs[0].plot(Config_noise[:, 1], Config_noise[:, 2],  'o' , label = "Noise data")
axs[0].plot(natural_config_base[:, 0], natural_config_base[:, 1], label = "Natural base")
axs[0].plot(natural_config_noise[:, 0], natural_config_noise[:, 1], label = "Natural noise")
axs[0].plot(natural_config_opt[:, 0], natural_config_opt[:, 1], label = "Natural opt")
axs[0].axis('equal')
axs[0].legend()

axs[1].plot(Config[:, 1], Config[:, 2],  'k--' , label = "Original shape")
axs[1].plot(Config_noise[:, 1], Config_noise[:, 2],  'o' , label = "Noise data")
axs[1].plot(pred_config_base[:, 0], pred_config_base[:, 1], label = "Pred base")
axs[1].plot(pred_config_noise[:, 0], pred_config_noise[:, 1], label = "Pred noise")
axs[1].plot(pred_config_opt[:, 0], pred_config_opt[:, 1], label = "Pred opt")
#
axs[1].axis('equal')
axs[1].legend()
plt.show()

Data = {"natural_config_base" : natural_config_base, "natural_config_noise" : natural_config_noise,
        "natural_config_opt" : natural_config_opt, "pred_config_base": pred_config_base,
        "pred_config_noise": pred_config_noise, "pred_config_opt" : pred_config_opt, 
        "natural_config_detection": Config_noise}

# Data = {"natural_config_base" : natural_config_base, "natural_config_noise" : natural_config_noise,
#         "pred_config_base": pred_config_base, "pred_config_noise": pred_config_noise}
import scipy.io
scipy.io.savemat(f'randomPath_eta_{eta:g}.mat', Data)

# dis = sqrt(sum(dis.^2, 2));
# dis = cumsum(dis);
# dis = [0; dis];

