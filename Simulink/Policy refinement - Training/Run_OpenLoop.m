clear all;
clc;
%% Path to files
FAST_InputFileName = '..\..\WT Model\IEA3.4-RWT-OpenFAST\IEA-3.4-130-RWT.fst';
Ts = 0.5; %control timestep/0.025 OpenFAST timestep

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

%% Load previous agent

agent = load('../agents/agent_policy_transfer.mat','saved_agent');
agent = agent.saved_agent;

%% Agent options

agent.UseExplorationPolicy = 1;
agent.AgentOptions.EpsilonGreedyExploration.Epsilon = 0.1; %Initialize epsilon in 10%
agent.AgentOptions.EpsilonGreedyExploration.EpsilonDecay=power(10,-3.25);
agent.SampleTime=Ts;

%% RL training configuration

TMax = 10000; % Total simulation Time 
maxepisodes = 1; %non-episodic task 
maxsteps = ceil((TMax/maxepisodes)/Ts);
training_Opts = rlTrainingOptions(...
'MaxEpisodes',maxepisodes, ...
'MaxStepsPerEpisode',maxsteps, ...
'Verbose',true,...
'StopTrainingCriteria','EpisodeCount',...
'StopTrainingValue',maxepisodes,...
'SaveAgentCriteria','EpisodeCount',...
'SaveAgentValue',maxepisodes,...
'SaveAgentDirectory', 'policy_refinement'); %directory to save the agent

%% Train agent
rate = 1; % Rate limiter value
trainingStats = train(agent,env,trainOpts); 
