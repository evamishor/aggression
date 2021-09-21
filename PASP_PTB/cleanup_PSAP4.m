 
try
    PSAP_Ver4
catch ME
    fprintf('ERROR: %s` %s\n',ME.identifier,ME.message);
    finalize4
    disp('Clean me up function has been executed');
    rethrow(ME)
end