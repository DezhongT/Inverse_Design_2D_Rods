# Inverse Design for 2D Rods
Codes for form-finding of an arbitrary 2D rod under gravity.

## Dependence
The codes include MATLAB and python scripts.
#### Python Dependencies
```bash
python3 -m pip install numpy scipy
```
#### MATLAB Dependencies
The latest MATLAB license

## Scripts Explanation
### generate_config.m
This script generates an arbitrary stable rod configuration under gravity, which offers the entry point(training data) for finding the design of the natural configuration of the rod.
#### Parameters
- ```eta``` - The material properties of the rod.
- ```like_prior``` - The noise magnitude of the measurement (training) data.

Once those two parameters are set, we can run the following script for computing the natural configuration of the rod.

### computeBaseLine.m
This script generates the ground truth of the natural configuration of the rod

### computeNoisyBaseLine.m
This script generates the computed natural configuration of the rod from noisy training data.


### inverse_rod_analytical_solver.py
This script generates the optimized computed natural configuration of the rod from noisy training data. Note that the ```computeBaseLine.m``` and ```computeNoisyBaseLine.m``` should be run before running this script.

### compareResult.m
This script generates the comparison figure for visualizing the results from different schemes.

