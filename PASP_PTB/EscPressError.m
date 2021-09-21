%% ESC Press Error
%
% Throws an error if an escape key was pressed since the last time the
% script was run.

if KbQueueCheck
        sca
        error('ESC was pressed.')
        stop(at);
end