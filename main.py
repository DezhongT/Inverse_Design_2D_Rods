import matplotlib.pyplot as plt
import numpy as np
from scipy.io import savemat
from utils import generate_config_from_txt , generate_config_from_scratch
from solver import compute_theory, forward_solver, numerical_optimization
import sys

np.random.seed(42)

def run_simulation(noise, eta, degree = 15, fileName = None, rotation = 0.0):
        """
        run the simulation to solve the inverse design of a planar rod
        Parameters
        ----------
        noise : float
            standard deviation of the gaussian noise to add to the target pattern.
        eta: float
            material properites to describe the bending deformations under external force (gravity)
        degree : int, optional
            the fitting degree number used for a polynomial function
        fileName : string, option
            if this is none, then the target shape will be generated randomly from scratch;
            if this has a string, then the target shape will be read from a file located at the path
        rotation: float, option
            this is a rotation angle value used to adjust the rotation of the target shape; it should
            be only added when fileName is not None
        Returns
        -------
        None.

        """
        if fileName is not None:
                Config, Config_noise = generate_config_from_txt(fileName,  noise = noise, rotation= rotation)
        else:
                Config, Config_noise = generate_config_from_scratch(noise = noise)

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
        # plt.show()

        Data = {"natural_config_base" : natural_config_base, "natural_config_noise" : natural_config_noise,
                "natural_config_opt" : natural_config_opt, "pred_config_base": pred_config_base,
                "pred_config_noise": pred_config_noise, "pred_config_opt" : pred_config_opt, 
                "natural_config_detection": Config_noise}

        print(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat')
        savemat(f'random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.mat', Data)
        plt.savefig(f'plot_random_eta_{eta:g}_degree_{degree:d}_noise_{noise:g}.png')

def main(argv):
        args = {}
        for arg in argv[1:]:
                if ":=" in arg:
                        key, value = arg.split(":=")
                        args[key] = value
        if "fileName" in args:
                if "degree" in args:
                        if "rotation" in args:
                                run_simulation(noise=float(args["noise"]), eta=float(args["eta"]), degree=int(args["degree"]), fileName=args["fileName"], rotation=float(args["rotation"]))
                        else:
                                run_simulation(noise=float(args["noise"]), eta=float(args["eta"]), degree=int(args["degree"]), fileName=args["fileName"])
                else:
                        if "rotation" in args:
                                run_simulation(noise=float(args["noise"]), eta=float(args["eta"]), fileName=args["fileName"], rotation=float(args["rotation"]))
                        else:
                                run_simulation(noise=float(args["noise"]), eta=float(args["eta"]), fileName=args["fileName"])
        else:
                if "degree" in args:
                        run_simulation(noise=float(args["noise"]), eta=float(args["eta"]), degree=int(args["degree"]))
                else:
                        run_simulation(noise=float(args["noise"]), eta=float(args["eta"]))



if __name__=="__main__":
        main(sys.argv)


