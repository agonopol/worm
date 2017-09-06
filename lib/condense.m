function condensed = condense(adj, neurons, options)

    markov = rownorm(adj);
    [V,D] = eig(markov);
    matrix = bsxfun(@times,V(:,1:50)',diag(D(1:50, :)))';
    

    options.sizefn = @(clusters, labels) centrality(adj, clusters)';
    options.labelfn = @(clusters, labels) label(labels, centrality(adj, clusters)');
    options.plotfn = @plotworm;

    condenser = ContractionClustering(matrix, cellstr(neurons), options);
    condensed = condenser.contract();
    
    % Write out cluster assigments
    
    f = fopen(strcat(options.destination, 'cluster_assigments.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');

    for i = 1:min(size(condensed.clusterAssignments))
        fprintf(f, join(string(condensed.clusterAssignments(i,:)), ','));
        fprintf(f, '\n');
    end
    fclose(f);

    % Write out cluster centrality analysis
    
    f = fopen(strcat(options.destination, 'cluster_centrality.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');
    
    
    for i = 1:min(size(condensed.clusterAssignments))
        fprintf(f, join(string(centrality(adj, condensed.clusterAssignments(i,:))), ','));
        fprintf(f, '\n');
    end        
    fclose(f);

    % Write out sanky for the last 4 iterations
    scores = zeros(size(condensed.clusterAssignments));
    data = condensed.contractionSequence(:, :, 1);

    for i = 1:size(condensed.clusterAssignments, 1)
        [~, Q] = affmodularity(data, condensed.clusterAssignments(i, :));
        scores(i, :) = Q;
    end
    
    for i = 0:4
        target = strcat(options.destination, 'step-', string(condensed.iteration - i), '-sanky.html');
        sanky(condensed.clusterAssignments(1:end-i, :), neurons, target, scores(1:end-i, :));
    end
    
    quality(adj, 'modularity', ...
            'maxk', 50, ...
            'output', strcat(condensed.options.destination, 'modularity-comparison.png'), ...
            'condensation', condensed.clusterAssignments, ... 
            'k-means', kmeanscompare(adj, condensed.clusterAssignments), ...
            'agglomerative', hierarchicalcompare(adj, condensed.clusterAssignments));
    
    quality(data, 'CalinskiHarabasz', ...
        'maxk', 50, ...
        'output', strcat(condensed.options.destination, 'CalinskiHarabasz-comparison.png'), ...
        'condensation', condensed.clusterAssignments, ... 
        'k-means', kmeanscompare(adj, condensed.clusterAssignments), ...
        'agglomerative', hierarchicalcompare(adj, condensed.clusterAssignments));
    
    quality(data, 'DaviesBouldin', ...
        'maxk', 50, ...
        'output', strcat(condensed.options.destination, 'DaviesBouldin-comparison.png'), ...
        'condensation', condensed.clusterAssignments, ... 
        'k-means', kmeanscompare(adj, condensed.clusterAssignments), ...
        'agglomerative', hierarchicalcompare(adj, condensed.clusterAssignments));
    
        quality(data, 'Silhouette', ...
        'maxk', 50, ...
        'output', strcat(condensed.options.destination, 'Silhouette-comparison.png'), ...
        'condensation', condensed.clusterAssignments, ... 
        'k-means', kmeanscompare(adj, condensed.clusterAssignments), ...
        'agglomerative', hierarchicalcompare(adj, condensed.clusterAssignments));
end