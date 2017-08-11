close all;
clear;
clc;

addpath('./lib');
loaddeps();

options = Options();
options.clusterAssignmentMethod = 'none';
options.epsilonClusterIdentificationMethod = 'constantEpsilon';
options.frequencyMergingEpsilonClusters = 'always'; %always,uponMetastability%
options.controlSigmaMethod = 'nuclearNormStabilization'; %nuclearNormStabilization,movementStabilization
options.numDiffusionSteps = 3;
options.phateEmbedding = false;

jsh = arrayfun(@(x) sprintf('JSH%03d', x), 1:282, 'UniformOutput', false);
n2u = [arrayfun(@(x) sprintf('N2U_%03d', x), 2:182, 'UniformOutput', false) ...
       arrayfun(@(x) sprintf('N2U_VC_%03d', x), 1:34, 'UniformOutput', false) ];

jshworm = 'data/adjacency_jsh_Weights.csv';
n2uworm = 'data/adjacency_N2U_Weights.csv';


path = jshworm;
adj = readworm(path);
rows = find(arrayfun(@(x1) any(strcmp(x1, jsh)), adj.EMSection));

[jshworm_neurons, jshworm_adj] = weightedadj(adj(:, {'Neuron1','Neuron2', 'EMSection', 'Weight'}));
    
[~, name, ~] = fileparts(path);
options.destination = fullfile(pwd(), 'results', 'whole', name, '//');
[dest, ~, ~] = fileparts(options.destination);
mkdir_if_not_exists(dest);
    
jshworm_cluster = cluster(jshworm_adj, jshworm_neurons, options);

path = n2uworm;
adj = readworm(path);
rows = find(arrayfun(@(x1) any(strcmp(x1, n2u)), adj.EMSection));

[n2uworm_neurons, n2uworm_adj] = weightedadj(adj(:, {'Neuron1','Neuron2', 'EMSection', 'Weight'}));
    
[~, name, ~] = fileparts(path);
options.destination = fullfile(pwd(), 'results', 'whole', name, '//');
[dest, ~, ~] = fileparts(options.destination);
mkdir_if_not_exists(dest);
    
n2uworm_cluster = cluster(n2uworm_adj, n2uworm_neurons, options);
   
scores = rindexscore(jshworm_cluster, n2uworm_cluster);
plot(scores);