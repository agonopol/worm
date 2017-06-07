function loaddeps()
    [current, ~, ~] = fileparts(mfilename('fullpath'));
    addpath(fullfile(current, 'condense'));
    addpath(fullfile(current, 'plot'));
end