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

files = dir('data/*.csv');

jsh = arrayfun(@(x) sprintf('JSH%03d', x), 1:282, 'UniformOutput', false);
n2u = [arrayfun(@(x) sprintf('N2U_%03d', x), 2:182, 'UniformOutput', false) ...
       arrayfun(@(x) sprintf('N2U_VC_%03d', x), 1:34, 'UniformOutput', false) ];

worms = containers.Map();

for file = files'
    
    path = fullfile(file.folder, file.name);
    adj = readworm(path);
    
    if not(isempty(strfind(path, 'N2U')))
        rows = find(arrayfun(@(x1) any(strcmp(x1, n2u)), adj.EMSection));
    else
        rows = find(arrayfun(@(x1) any(strcmp(x1, jsh)), adj.EMSection));
    end
    
    [neurons, adj] = weightedadj(adj(rows, {'Neuron1','Neuron2', 'EMSection', 'Weight'}));
    
    [~, name, ~] = fileparts(path);
    options.destination = fullfile(pwd(), 'results', 'brain', name, '//');
    [dest, ~, ~] = fileparts(options.destination);
    mkdir_if_not_exists(dest);
    
    worms(path) = condense(adj, neurons, options);
    
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
     
     output = fullfile(pwd(), 'results', 'brain', strcat(xN, '-', yN, '-emd.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'emd', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);
     
     output = fullfile(pwd(), 'results', 'brain', strcat(xN, '-', yN, '-mmd.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'mmd', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);
     
     output = fullfile(pwd(), 'results', 'brain', strcat(xN, '-', yN, '-rindex.png'));
     qpopulation(worms(pairs{i,1}), worms(pairs{i,2}), 150, 'rindex', 'output', output, 'hierarchical', @hierarchicalcompare, 'k-means', @kmeanscompare);

end