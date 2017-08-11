function scores = rindexscore(X, Y, varargin)
    scores = [];
    neurons = intersect(Y.channels, X.channels);
    xindex = getindex(X.channels, neurons);
    yindex = getindex(Y.channels, neurons);
   for step = 0:min(size(X.clusterAssignments, 1), size(Y.clusterAssignments, 1)) - 1
       score = rindex(X.clusterAssignments(end - step,xindex), Y.clusterAssignments(end - step,yindex));
       scores = [score, scores];
   end
end

function index = getindex(intersection, neurons)
    index = arrayfun(@(y) ...
        find(arrayfun(@(x) ~isempty(x{:}), strfind(intersection, y))), neurons, 'UniformOutput', false);
    index = cell2mat(index);
    index = index';
end