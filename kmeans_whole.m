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

files = dir('data/*.csv');

for file = files'
    
    path = fullfile(file.folder, file.name);
    adj = readworm(path);
    [neurons, adj] = weightedadj(adj);
    
    [~, name, ~] = fileparts(path);
    options.destination = fullfile(pwd(), 'results', 'whole', name, '//');
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