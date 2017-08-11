function loaddeps()
    [current, ~, ~] = fileparts(mfilename('fullpath'));
    addpath(fullfile(current, 'condense'));
    addpath(fullfile(current, 'condense/emd/matlab'));
    addpath(fullfile(current, 'centrality'));
    addpath(fullfile(current, 'sanky'));
    addpath(fullfile(current, 'sanky', 'template'));
    addpath(fullfile(current, 'rindex'));
end