import numpy as np
from utils import compute_theta, generate_config_from_theta
from scipy.integrate import solve_bvp, cumulative_trapezoid
from scipy.interpolate import interp1d, CubicSpline
from numpy import cos, sin

class AdamOptimizer:
    def __init__(self, learning_rate=0.001, beta1=0.9, beta2=0.999, epsilon=1e-8):
        self.learning_rate = learning_rate
        self.beta1 = beta1
        self.beta2 = beta2
        self.epsilon = epsilon
        self.m = None  # First moment estimate
        self.v = None  # Second moment estimate
        self.t = 0      # Time step

    def update(self, params, gradients):
        if self.m is None:
            self.m = np.zeros_like(params)
            self.v = np.zeros_like(params)

        self.t += 1

        # Update biased first and second moment estimates
        self.m = self.beta1 * self.m + (1 - self.beta1) * gradients
        self.v = self.beta2 * self.v + (1 - self.beta2) * (gradients ** 2)

        # Bias-corrected first and second moment estimates
        m_hat = self.m / (1 - self.beta1 ** self.t)
        v_hat = self.v / (1 - self.beta2 ** self.t)

        # Update parameters
        params -= self.learning_rate * m_hat / (np.sqrt(v_hat) + self.epsilon)


def compute_theory(Config, eta, degree = 6):
    S = Config[:, 0]
    X = Config[:, 1]
    Y = Config[:, 2]
    Theta = compute_theta(S, X, Y)

    p = np.polyfit(S, Theta, degree)
    theta = lambda x : np.polyval(p, x)
    dp1 = np.polyder(p)
    theta1 = lambda x : np.polyval(dp1, x)
    dp2 = np.polyder(dp1)
    theta2 = lambda x : np.polyval(dp2, x)
    dp3 = np.polyder(dp2)
    theta3 = lambda x : np.polyval(dp3, x)
    dp4 = np.polyder(dp3)
    theta4 = lambda x : np.polyval(dp4, x)



    def ode_backward(s, kap):
        dkap1_ds = kap[1]
        dkap2_ds = (eta * theta2(s) * kap[1] - eta * theta1(s)**3*kap[0] - \
                    eta * theta4(s) * theta1(s) + eta * theta3(s) * theta2(s) + \
                    eta * theta2(s) * (eta * np.cos(theta(s)) - theta1(s)**3) + \
                    2 * eta**2 * np.sin(theta(s)) * theta1(s)**2)/(eta * theta1(s))
        dkap_ds = np.vstack((dkap1_ds, dkap2_ds))
        return dkap_ds

    def bc_backward(kapa, kapb):
        se = S[-1]
        return np.array([kapa[0] + theta2(0) - eta * np.cos(theta(0)),
                         kapb[0] + theta2(se)])
    S = np.linspace(0, S[-1], 101)
    sol_guess = np.zeros((2, S.size))

    sol = solve_bvp(ode_backward, bc_backward, S,  sol_guess, max_nodes = 10000, tol = 1e-7)
    s = sol.x
    dKap = -sol.y
    residual = sol.rms_residuals
    if max(residual) > 1e-5:
        print("Backward BVP solver is wrong, the residual of sol is: ", max(residual))
    dKap_cubic = interp1d(s, dKap)

    dKap = dKap_cubic(S)
    dKap = dKap[0]
    Kap = cumulative_trapezoid(dKap, S, initial = 0)
    # handling kap based on boundary conditions
    Kap0 = theta1(S[-1])
    Kap = Kap + Kap0 - Kap[-1]
    Theta1 = cumulative_trapezoid(Kap, S, initial = 0)
    Theta1 = Theta1 - Theta1[0] + theta(0)
    natural_config = generate_config_from_theta(Theta1, S)

    # define func of Kap
    # degree = 4
    # p = np.polyfit(S, Kap, degree)
    # Kap = lambda x : np.polyval(p, x)
    Kap = CubicSpline(S, Kap)
    # BCs
    BCs  = []
    BCs.append(["clamped", theta(0), 0, 0])
    BCs.append(["free"])
    return Kap, natural_config, BCs

def forward_solver(Kap0, S, eta, BCs ):
    def odefunc(s, q):
        kap0 = Kap0(s)
        dq1_ds = eta * (q[1] + 1.0/eta * kap0)
        dq2_ds = q[2]
        dq3_ds = -cos(q[0]) + eta * q[3] * (q[1] + 1./eta * kap0)
        dq4_ds = sin(q[0]) - eta * q[2] * (q[1] + 1./eta * kap0)
        dq5_ds = cos(q[0])
        dq6_ds = sin(q[0])
        dqds = np.vstack((dq1_ds, dq2_ds, dq3_ds, dq4_ds, dq5_ds, dq6_ds))
        return dqds

    # define BC funcs from BCs
    theta0 = BCs[0][1]
    def boundary_conditions(qa, qb):
        return np.array([qa[0] - theta0, qa[4], qa[5], qb[1], qb[2], qb[3]])
    S_u = np.linspace(0, S[-1], 101)
    q_guess = np.zeros((6, S_u.size))
    sol = solve_bvp(odefunc, boundary_conditions, S_u, q_guess, max_nodes = 10000, tol = 1e-8)
    s = sol.x
    q = sol.y
    residual = sol.rms_residuals
    if max(residual) > 1e-5:
        print("Forward BVP solver is wrong ", max(residual))


    q_cubic = interp1d(s, q, kind='cubic')
    q_interp_cubic = q_cubic(S).T
    pred_x = q_interp_cubic[:, 4]
    pred_y = q_interp_cubic[:, 5]

    Config = np.hstack((pred_x.reshape(-1, 1), pred_y.reshape(-1, 1)))

    return Config

def numerical_optimization(data, Kap0, eta, BCs, degree = 15, max_iter = 1000, lr = 0.1):
    s_u = data[:, 0]
    x_u = data[:, 1]
    y_u = data[:, 2]

    Kap0 = Kap0(s_u)
    params = np.polyfit(s_u, Kap0, degree)
    theta0 = BCs[0][1]

    def model_loss(compute_grad = True):
        # compute x and y from pde solver
        def odefunc(s, q):
            kap0 = np.poly1d(params)
            kap0 = kap0(s)
            dq1_ds = eta * (q[1] + 1.0/eta * kap0)
            dq2_ds = q[2]
            dq3_ds = -cos(q[0]) + eta * q[3] * (q[1] + 1./eta * kap0)
            dq4_ds = sin(q[0]) - eta * q[2] * (q[1] + 1./eta * kap0)
            dq5_ds = cos(q[0])
            dq6_ds = sin(q[0])
            dqds = np.vstack((dq1_ds, dq2_ds, dq3_ds, dq4_ds, dq5_ds, dq6_ds))
            return dqds
        def boundary_conditions(qa, qb):
            return np.array([qa[0] - theta0, qa[4], qa[5], qb[1], qb[2], qb[3]])

        s = np.linspace(0, s_u[-1], 101)
        q_guess = np.zeros((6, s.size))

        sol = solve_bvp(odefunc, boundary_conditions, s, q_guess, max_nodes = 10000, tol = 1e-5)
        s = sol.x
        q = sol.y
        residual = sol.rms_residuals
        if max(residual) > 1e-5:
            print("Temp forward BVP solver is wrong", max(residual))

        q_cubic = interp1d(s, q, kind='cubic')
        s_interp = s_u
        q_interp_cubic = q_cubic(s_interp).T

        x_cubic = interp1d(s_u, x_u, kind='cubic')
        y_cubic = interp1d(s_u, y_u, kind='cubic')
        q_guess = q_cubic(np.linspace(0, s_u[-1], 101))

        pred_x = q_interp_cubic[:, 4]
        pred_y = q_interp_cubic[:, 5]

        # pred_x, y = f(kap0, params) -> grad F_params
        ll = 0.5 * ((pred_x - x_u) ** 2).sum(0)
        ll = ll + 0.5 * ((pred_y - y_u) ** 2).sum(0)

        if not compute_grad:
            return ll

        ## adjoint method for sensitivity analysis
        # construct the g
        Q = np.eye(6)
        Q[:4, :4] = 0
        # construct ode for lambda
        def odeLambda(s, lam):
            # define the function of df/dq
            q = q_cubic(s)
            zeroR = np.zeros_like(q[0])
            onesR = np.ones_like(q[0])
            # kap0 = params[0] * s**4  + params[1] * s**3 + params[2] * s**2 + params[3] * s+ params[4]
            kap0 = np.poly1d(params)
            kap0 = kap0(s)
            matrix = [[zeroR, eta * onesR, zeroR, zeroR, zeroR, zeroR],
                      [zeroR, zeroR, onesR, zeroR, zeroR, zeroR],
                      [sin(q[0]), eta * q[3], zeroR, eta * (q[1] + 1.0/eta * kap0), zeroR, zeroR],
                      [cos(q[0]), -eta * q[2], -eta * (q[1] + 1.0/eta * kap0), zeroR, zeroR, zeroR],
                      [-sin(q[0]), zeroR, zeroR, zeroR, zeroR, zeroR],
                      [cos(q[0]), zeroR, zeroR, zeroR, zeroR, zeroR]]
            matrix = np.array(matrix).reshape(6, 6, -1)
            df_dq_T = np.transpose(matrix, axes = (2, 1, 0)) # (6, 6 , -1)
            # compute the function of dg/du : g = q.T Q q ; dg_dq = (Q + Q.T) * q
            x_interp = x_cubic(s)
            y_interp = y_cubic(s)
            q[4] -= x_interp
            q[5] -= y_interp
            dg_dq = q.T @ (Q + Q.T)

            f = np.zeros_like(lam)
            for i in range(lam.shape[1]):
                df_dq_t = df_dq_T[i]
                lam_t = lam[:, i]
                f[:, i] = df_dq_t @ lam_t

            f = -f - dg_dq.T
            return f

        def bcLambda(lama, lamb):
            return np.array([lama[1], lama[2], lama[3], lamb[0], lamb[4], lamb[5]])

        s = np.linspace(0, s_u[-1], 101)
        lam_guess = np.zeros((6, s.size))
        solL = solve_bvp(odeLambda, bcLambda, s, lam_guess, max_nodes=10000, tol = 1e-5)
        S = solL.x
        lam = solL.y # (6, -1)
        residual = solL.rms_residuals
        if max(residual) > 1e-5:
            print("Adjoint BVP solver is wrong")
        # compute the intergral
        df_dp_int = np.zeros((lam.shape[1], params.shape[0]))
        for i in range(df_dp_int.shape[0]):
            s = S[i]
            q = q_cubic(s)
            df_dkap = [1, 0, q[3], -q[2], 0, 0]
            df_dkap = np.array(df_dkap).reshape(-1, 1)

            dkap_dp = []
            for j in range(params.shape[0]):
                dkap_dp.append(s**(params.shape[0]-1-j))
            dkap_dp = np.array(dkap_dp).reshape(1, -1)
            lam_t = lam[:, i]
            df_dp = df_dkap @ dkap_dp
            df_dp_int[i, :] = df_dp.T @ lam_t

        # print(params)
        grad = np.trapz(df_dp_int.T, S.T)
        grad = 100 * grad
        if np.linalg.norm(grad) > 1:
            grad = grad/np.linalg.norm(grad)

        return ll, grad, q_guess

    optimizer = AdamOptimizer(learning_rate=lr)
    iter = 0
    while iter < max_iter:
        ll, grad, q_guess = model_loss()
        optimizer.update(params, grad)
        if ll < 0.001:
            break
        if iter % 10 == 0:
            print(f"Iter: {iter} | loss {ll} | grad {np.linalg.norm(grad)}")
        iter += 1

    Kap = lambda x : np.polyval(params, x)
    Kap0 = Kap(s_u)

    Theta1 = cumulative_trapezoid(Kap0, s_u, initial = 0)
    Theta1 = Theta1 - Theta1[0] + theta0
    natural_config = generate_config_from_theta(Theta1, s_u)
    return Kap, natural_config, BCs
