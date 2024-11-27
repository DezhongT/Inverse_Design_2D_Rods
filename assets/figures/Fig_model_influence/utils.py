import numpy as np
from scipy.integrate import cumulative_trapezoid
from scipy.interpolate import CubicSpline
from numpy import cos, sin
import matplotlib.pyplot as plt

def generate_config_from_theta(theta, s):
    dxds = np.cos(theta)
    dyds = np.sin(theta)

    X = cumulative_trapezoid(dxds, s, initial=0)
    Y = cumulative_trapezoid(dyds, s, initial=0)

    Config = np.hstack((X.reshape(-1, 1), Y.reshape(-1, 1)))

    return Config

def compute_theta(S, X, Y):
    spline_fit_X = CubicSpline(S, X)
    spline_fit_Y = CubicSpline(S, Y)

    spline_dX_dS = spline_fit_X.derivative()
    spline_dY_dS = spline_fit_Y.derivative()

    dX_dS = spline_dX_dS(S)
    dY_dS = spline_dY_dS(S)

    Theta = np.arctan2(dY_dS, dX_dS)

    for i in range(Theta.shape[0]-1):
        while abs(Theta[i+1] - Theta[i]) > 1.05 * np.pi:
            Theta[i+1] -= 2 * np.sign(Theta[i+1]-Theta[i]) * np.pi

    return Theta

def generate_config_from_scratch(noise = 0.001):
    rand_num = np.random.rand(6, 1)
    lower_bound = -10
    upper_bound = 10
    coeff = lower_bound + (upper_bound - lower_bound) * rand_num

    theta = lambda x : np.polyval(coeff, x)
    S = np.linspace(0.0, 1.0, 101)
    Theta = theta(S)

    Config = generate_config_from_theta(Theta, S)

    dis = np.diff(Config, axis = 0)
    dis = np.sqrt(np.sum(dis**2, axis = 1))
    dis = np.cumsum(dis)
    dis = np.concatenate((np.array([0]), dis))
    Config = np.hstack((dis.reshape(-1, 1), Config))

    X = Config[:, 1]
    Y = Config[:, 2]
    X = X + noise * np.random.randn(X.shape[0])
    Y = Y + noise * np.random.randn(Y.shape[0])
    Config_noise = np.hstack((X.reshape(-1, 1), Y.reshape(-1, 1)))
    dis_n = np.diff(Config_noise, axis = 0)
    dis_n = np.sqrt(np.sum(dis_n**2, axis = 1))
    dis_n = np.cumsum(dis_n)
    dis_n = np.concatenate((np.array([0]), dis_n))
    Config_noise = np.hstack((dis_n.reshape(-1, 1), Config_noise))

    return Config, Config_noise

def rotate_angle(data, theta):
    rot = np.array([[cos(theta), -sin(theta), 0 ],
                    [sin(theta), cos(theta), 0],
                    [0, 0, 1]])

    res = np.zeros_like(data)

    for i in range(res.shape[0]):
        temp = data[i]
        res[i] = temp @ rot.T

    return res

def generate_config_from_txt(path, noise = 0.001, rotation = 0.0):
    data = np.loadtxt(path)
    data = rotate_angle(data, rotation)

    Config = data[:, :2]
    dis = np.diff(Config, axis = 0)
    dis = np.sqrt(np.sum(dis**2, axis = 1))
    dis = np.cumsum(dis)
    dis = np.concatenate((np.array([0]), dis))
    Config = np.hstack((dis.reshape(-1, 1), Config))
    Config = Config/Config[-1, 0]

    X = Config[:, 1]
    Y = Config[:, 2]
    X = X + noise * np.random.randn(X.shape[0])
    Y = Y + noise * np.random.randn(Y.shape[0])
    Config_noise = np.hstack((X.reshape(-1, 1), Y.reshape(-1, 1)))
    dis_n = np.diff(Config_noise, axis = 0)
    dis_n = np.sqrt(np.sum(dis_n**2, axis = 1))
    dis_n = np.cumsum(dis_n)
    dis_n = np.concatenate((np.array([0]), dis_n))
    Config_noise = np.hstack((dis_n.reshape(-1, 1), Config_noise))

    return Config, Config_noise
