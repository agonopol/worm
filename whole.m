close all;
clear;
clc;

addpath('./lib');
loaddeps();

options = Options();
options.clusterAssignmentMethod = 'none';
options.epsilonClusterIdentificationMethod = 'constantEpsilon'; %constantEpsilon,dynamicSigmaFraction
options.frequencyMergingEpsilonClusters = 'always'; %always,uponMetastability%
options.controlSigmaMethod = 'nuclearNormStabilization'; %nuclearNormStabilization,movementStabilization
options.numDiffusionSteps = 3;

files = dir('data/*.csv');

worms = containers.Map();

for file = files'
    
    path = fullfile(file.folder, file.name);
    adj = readworm(path);
    [neurons, adj] = weightedadj(adj);
    
    [~, name, ~] = fileparts(path);
    options.destination = fullfile(pwd(), 'results', 'whole', name, '//');
    [dest, ~, ~] = fileparts(options.destination);
    mkdir_if_not_exists(dest);
    
    condensed = condense(adj, neurons, options);
    break;
    worms(path) = condensed;
    
    close all force;
    close all hidden;      
end