close all;
clear;
clc;

addpath('./lib');
loaddeps();

options = Options();
options.clusterAssignmentMethod = 'none'; %none,spectral
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
    worms(path) = condensed;
        
    close all force;
    close all hidden;  
    
end

pairs = {'/Users/alex/src/bio/condense/worm/data/adjacency_jsh_Weights.csv', '/Users/alex/src/bio/condense/worm/data/adjacency_Worm1_jsh.csv';
         '/Users/alex/src/bio/condense/worm/data/adjacency_jsh_Weights.csv', '/Users/alex/src/bio/condense/worm/data/adjacency_N2U_Weights.csv';
         '/Users/alex/src/bio/condense/worm/data/JSH_Weights_Lefts_Final.csv', '/Users/alex/src/bio/condense/worm/data/JSH_Weights_Rights_Final.csv';
         '/Users/alex/src/bio/condense/worm/data/JSH_Weights_Lefts_Final.csv', '/Users/alex/src/bio/condense/worm/data/N2U_Weights_Lefts_Final.csv';
         '/Users/alex/src/bio/condense/worm/data/adjacency_N2U_Weights.csv', '/Users/alex/src/bio/condense/worm/data/adjacency_Worm2_N2U.csv';
         '/Users/alex/src/bio/condense/worm/data/adjacency_N2U_Weights.csv', '/Users/alex/src/bio/condense/worm/data/adjacency_N2U_Weights.csv';
         '/Users/alex/src/bio/condense/worm/data/N2U_Weights_Lefts_Final.csv', '/Users/alex/src/bio/condense/worm/data/N2U_Weights_Rights_Final.csv';
         '/Users/alex/src/bio/condense/worm/data/N2U_Weights_Lefts_Final.csv', '/Users/alex/src/bio/condense/worm/data/N2U_Weights_Lefts_Final.csv';};
 
 for i = 1:size(pairs, 1)
     [~, xN, ~] = fileparts(pairs{i, 1});
     [~, yN, ~] = fileparts(pairs{i, 2});
     
     output = fullfile(pwd(), 'results', 'whole', strcat(xN, '-', yN, '-emd.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'emd', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);
     
     output = fullfile(pwd(), 'results', 'whole', strcat(xN, '-', yN, '-mmd.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'mmd', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);
     
     output = fullfile(pwd(), 'results', 'whole', strcat(xN, '-', yN, '-rindex.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'rindex', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);

end