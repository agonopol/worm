function cluster(adj, neurons, options)

    markov = rownorm(adj);
    [V,D] = eig(markov);
    matrix = bsxfun(@times,V(:,1:50)',diag(D(1:50, :)))';
    
    
    options.sizefn = @(clusters, labels) centrality(adj, clusters)';
    options.labelfn = @(clusters, labels) label(labels, centrality(adj, clusters)');

    contractor = ContractionClustering(matrix, cellstr(neurons), options);
    contractor = contractor.contract();
    
    % Write out cluster assigments
    
    f = fopen(strcat(options.destination, 'cluster_assigments.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');

    for i = 1:min(size(contractor.clusterAssignments))
        fprintf(f, join(string(contractor.clusterAssignments(i,:)), ','));
        fprintf(f, '\n');
    end
    fclose(f);

    % Write out cluster centrality analysis
    
    f = fopen(strcat(options.destination, 'cluster_centrality.csv'), 'w');
    fprintf(f, join(string(neurons'), ','));
    fprintf(f, '\n');
    
    
    for i = 1:min(size(contractor.clusterAssignments))
        fprintf(f, join(string(centrality(adj, contractor.clusterAssignments(i,:))), ','));
        fprintf(f, '\n');
    end        
    fclose(f);

    % Write out sanky for the last 4 iterations
    for i = 0:4
        target = strcat(options.destination, 'step-', string(contractor.iteration - i), '-sanky.html');
        sanky(contractor.clusterAssignments(1:end-i, :), neurons, target);
    end
end