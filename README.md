# RL-Based Pitch Control: Simulation Setup with OpenFAST and Simulink

## 1. Simulation Setup with OpenFAST and Simulink

To evaluate the performance of reinforcement learning (RL) algorithms under realistic operating conditions, we use the OpenFAST simulator developed by NREL.

To use OpenFAST from the Simulink environment, you must download the binaries available in the official OpenFAST GitHub repository:

**[OpenFAST v4.0.4 – GitHub Release](https://github.com/OpenFAST/openfast/releases/tag/v4.0.4)**

### Required Files

Specifically, you will need the following files from the release:

- `OpenFAST-Simulink_x64.dll`: The shared library required for running OpenFAST as a Simulink block.
- `FAST_SFunc.mexw64`: The compiled S-Function that interfaces Simulink with OpenFAST.

To set up the interface copy both files to a folder within a directory (e.g., lib/openfast/) and add that folder to the MATLAB path.