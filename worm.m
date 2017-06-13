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
    options.destination = fullfile(pwd(), 'results', name, '//');
    [dest, ~, ~] = fileparts(options.destination);
    mkdir_if_not_exists(dest);
    
    markov = rownorm(adj);
    [V,D] = eig(markov);
    matrix = bsxfun(@times,V(:,1:50)',diag(D(1:50, :)))';
    
    contractor = ContractionClustering(matrix, cellstr(neurons), options);
    contractor = contractor.contract();
    
    flipped = flip(contractor.clusterAssignments);

    % Write out cluster assigments
    
    f = fopen(strcat(options.destination, 'cluster_assigments.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');

    for i = 1:min(size(contractor.clusterAssignments))
        fprintf(f, join(string(flipped(i,:)), ','));
        fprintf(f, '\n');
    end
    fclose(f);

    % Write out cluster centrality analysis
    
    f = fopen(strcat(options.destination, 'cluster_centrality.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');
    
    
    for i = 1:min(size(contractor.clusterAssignments))
        fprintf(f, join(string(centrality(adj, flipped(i,:))), ','));
        fprintf(f, '\n');
    end        
    fclose(f);

    % Write out sanky for the last 4 iterations
    for i = 0:4
        target = strcat(options.destination, 'step-', string(contractor.iteration - i), '-sanky.html');
        sanky(contractor.clusterAssignments(1:end-i, :), neurons, target);
    end
  
    clc;
    close all force;
    close all hidden;
end