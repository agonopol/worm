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
options.fastStop = true;
options.maxClusters = 7;
options.phateEmbedding = false;

files = dir('data/*Final.csv');

jsh = arrayfun(@(x) sprintf('JSH%03d', x), 1:282, 'UniformOutput', false);
n2u = [arrayfun(@(x) sprintf('N2U_%03d', x), 2:182, 'UniformOutput', false) ...
       arrayfun(@(x) sprintf('N2U_VC_%03d', x), 1:34, 'UniformOutput', false) ];

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
    
    markov = rownorm(adj);
    [V,D] = eig(markov);
    matrix = bsxfun(@times,V(:,1:50)',diag(D(1:50, :)))';
    
    assigments = kmeans(matrix, 15);
    f = fopen(strcat(options.destination, 'k-means_cluster_assigments.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');
    
    fprintf(f, join(string(assigments), ','));
    fprintf(f, '\n');
    fclose(f);
    
    clc;
    close all force;
    close all hidden;
      
end