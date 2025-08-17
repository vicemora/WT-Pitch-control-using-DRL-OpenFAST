clear all;
clc;
%% Path to files
TMax = 400;
FAST_InputFileName = '..\..\WT Model\IEA3.4-RWT-OpenFAST\IEA-3.4-130-RWT.fst';
Ts = 0.025;
%% Simulink configuration
mdl = 'OpenLoop';
agentblk = [mdl '/RL Agent'];
open_system(mdl); 
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
%agent = load('../agents/agent_policy_refinement.mat','saved_agent');
agent = load('../Policy refinement - Training/saved_agent/Agent1.mat','saved_agent');
agent = agent.saved_agent;
agent.SampleTime=Ts; 
%% Evaluate agent
maxepisodes = 1;
maxsteps = ceil((TMax/maxepisodes)/Ts);
simOptions = rlSimulationOptions('MaxSteps',maxsteps);
experience = sim(env,agent,simOptions);
%% Plots 
% Cargar el archivo .mat
data = load('out_data_1.mat');

% Obtener el nombre del campo (asumiendo que hay solo una variable)
varname = fieldnames(data);
array = data.(varname{1});  % Acceder al contenido de la variable

% Extraer tiempo y potencia
tiempo = array(1, :);       % Fila 1 (índice 1 en MATLAB)
potencia = array(16, :)/1000;    % Fila 17

% Graficar
figure;
plot(tiempo, potencia, 'LineWidth', 1.5);
xlabel('Tiempo');
ylabel('Potencia');
xlim([100,400])
ylim([3.2,3.6])
title('Potencia vs Tiempo');
grid on;


%% Plots 
