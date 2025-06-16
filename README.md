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

The turbine model is available at:

**[IEA-3.4-130-RWT – GitHub Repository](https://github.com/WISDEM/IEA-3.4-130-RWT)**

The repository includes the primary input file (.fst) and module input files (.dat) for ElastoDyn, ServoDyn, AeroDyn, InflowWind, and other necessary files for OpenFAST simulation.

### Controller integration

In this work, the ROSCO controller is used to obtain an initial informed control policy.

There are two ways to utilize the NREL ROSCO (pitch) controller for this wind turbine model:

#### Option 1: Dynamic Library Integration (Recommended)

1. Locate the **“Bladed Interface”** section within the `ServoDyn` input file.
2. Set the `DLL_FileName` field to point to the `libdiscon.dll` file. [Download from NREL/ROSCO Releases](https://github.com/NREL/ROSCO/releases)
3. Ensure that the `PCMode` option in the `ServoDyn` input file is set to `5`, which enables the external controller. 

#### Option 2: Simulink Block Integration

An alternative approach involves using the ROSCO controller as a Simulink block. This can be constructed from the ROSCO toolbox files available in the repository: https://github.com/NREL/ROSCO/tree/main/Matlab_Toolbox

**Note:** The ROSCO Simulink toolbox is no longer actively maintained. Therefore, compatibility issues and errors might be possible. For this reason, we prefer the first option (further considerations for this approach are discussed later in the repository). However, we present this second option because it offers a pathway to generalize policy transfer to other controllers (not ROSCO) and turbine models within the Simulink environment. 


## 3. Policy Transfer

The `Simulink` directory contains the necessary files to **train** and **evaluate** an agent using the **policy transfer** approach.

### OpenFAST Configuration – Policy transfer training

To enable policy transfer training, set the following parameters in the `ServoDyn` module:

- `PCMode = 5`  
- `VSContrl = 5`

### OpenFAST Configuration – Policy transfer testing

To evaluate a transferred policy in testing mode, configure the `ServoDyn` module as follows:

- `PCMode = 4`  
- `VSContrl = 5`

---

## 4. Policy Refinement

The `Simulink` directory also contains the necessary files to **train** and **evaluate** an agent using the **policy refinement** approach.

### OpenFAST Configuration – Policy refinement training

For training in refinement mode, set the following in `ServoDyn`:

- `PCMode = 4`  
- `VSContrl = 5`

### OpenFAST Configuration – Policy refinement testing

To test the refined policy, use the same configuration as above:

- `PCMode = 4`  
- `VSContrl = 5`


`Implementation notes:`   










