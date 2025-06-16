clear all;
clc;
%% Path to files
FAST_InputFileName = '..\..\WT Model\IEA3.4-RWT-OpenFAST\IEA-3.4-130-RWT.fst';
Ts = 0.025;
%% Simulink configuration
mdl = 'OpenLoop';
agentblk = [mdl '/RL Agent'];
open_system(mdl); 
% rng('default')

%% Create RL enviroment
n_states = 5; % [power_error, power_error', wind_speed, current_pitch, rotor_speed]
observationInfo = rlNumericSpec([n_states 1],'LowerLimit', ...
            -inf*ones(n_states,1),'UpperLimit',inf*ones(n_states,1));
n_actions = 301;
actions = linspace(0,pi/6,n_actions); %[0,0.1°,0.2°,...,30°]
actionInfo = rlFiniteSetSpec(actions);
env = rlSimulinkEnv(mdl,agentblk,observationInfo,actionInfo);

%% Initialize agent

rate = 1; % Rate limiter value
agent = load('../agents/agent_policy_refinement.mat','saved_agent');
agent = agent.saved_agent;
agent.SampleTime=Ts; 
%% Evaluate agent
simOptions = rlSimulationOptions('MaxSteps',maxsteps);
experience = sim(env,agent,simOptions);

%% Plots 
