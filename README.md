# RL-Based Pitch Control: Simulation Setup with OpenFAST and Simulink

## 1. Simulation Setup with OpenFAST and Simulink

To evaluate the performance of reinforcement learning (RL) algorithms under realistic operating conditions, we use the OpenFAST simulator developed by NREL.

To use OpenFAST from the Simulink environment, you must download the binaries available in the official OpenFAST GitHub repository:

**[OpenFAST v4.0.4 – GitHub Release](https://github.com/OpenFAST/openfast/releases/tag/v4.0.4)**

### Required Files

Specifically, you will need the following files from the release:

- `OpenFAST-Simulink_x64.dll`: The shared library required for running OpenFAST as a Simulink block.
- `FAST_SFunc.mexw64`: The compiled S-Function that interfaces Simulink with OpenFAST.

To set up the interface copy both files to a folder with\in a directory (e.g., lib/openfast/) and add that folder to the MATLAB path.


## 2. OpenFAST IEA 3.4 MW RWT Model

All simulations in this work are based on the **IEA Wind Task 37 3.4 MW Reference Wind Turbine (RWT)** model — a land-based turbine developed for system-level engineering studies.

**[IEA-3.4-130-RWT – GitHub Repository](https://github.com/WISDEM/IEA-3.4-130-RWT)**

It includes the primary input file (.fst)  and module input files (.dat) for ElastoDyn, ServoDyn, AeroDyn, InflowWind, etc.

### ROSCO Controller Integration

There are to ways to integrate the NREL ROSCO controller for this wind turbine model.

First by using ROSCO dynamic library

1. Locate the **“Bladed Interface”** section within the `ServoDyn` input file.
2. Set the `DLL_FileName` field to point to the `libdiscon.dll` file.

> 🔗 **[Download libdiscon.dll – NREL/ROSCO Releases](https://github.com/NREL/ROSCO/releases)**

### ⚠️ Important Notes

- Make sure the `libdiscon.dll` version **matches** the ROSCO version referenced by the `DISCON.IN` file.
- If using a different wind turbine model, repeat this setup and version-matching process accordingly.