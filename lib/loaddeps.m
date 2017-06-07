function loaddeps()
    [current, ~, ~] = fileparts(mfilename('fullpath'));
    addpath(fullfile(current, 'condense'));
    addpath(fullfile(current, 'sanky'));
    addpath(fullfile(current, 'sanky', 'template'));
end