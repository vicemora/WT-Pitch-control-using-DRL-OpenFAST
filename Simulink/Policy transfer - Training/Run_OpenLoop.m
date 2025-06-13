clear all;
clc;
%% Path to files
FAST_InputFileName = '..\..\WT Model\IEA3.4-RWT-OpenFAST\IEA-3.4-130-RWT.fst';

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

%% Create RL-DDQN agent
nI = observationInfo.Dimension(1);  %Number of inputs                      
nO = numel(actionInfo.Elements); %Number of outputs
hidden_1 = 64;
hidden_2 = 128;
dnn = [
    featureInputLayer(nI,'Normalization','none','Name','state')
    fullyConnectedLayer(hidden_1,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(hidden_2,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(nO,'Name','fc3')];
dnn = dlnetwork(dnn);
summary(dnn)

criticOptions = rlRepresentationOptions('LearnRate',0.01,'GradientThreshold',1,'L2RegularizationFactor',1e-4);
critic = rlQValueRepresentation(dnn,observationInfo,actionInfo,'Observation',{'state'},criticOptions);
agentOpts = rlDQNAgentOptions(...
    'SampleTime',Ts,... 
    'UseDoubleDQN',true,...
    'TargetSmoothFactor',1e-2,...
    'TargetUpdateFrequency',50,...
    'DiscountFactor',0.99,...
    'ExperienceBufferLength',1e6,...
    'MiniBatchSize',128);

agent = rlDQNAgent(critic,agentOpts);
agent.ExperienceBuffer=rlPrioritizedReplayMemory(observationInfo,actionInfo);
agent.AgentOptions.InfoToSave.ExperienceBuffer=true;
agent.AgentOptions.InfoToSave.Optimizer=true;
agent.AgentOptions.InfoToSave.PolicyState=true;
agent.AgentOptions.InfoToSave.Target=true;


%% RL training configuration

Ts = 0.5; %cbontrol timestep/0.025 OpenFAST timestep
TMax = 6000; % Total simulation Time 
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


