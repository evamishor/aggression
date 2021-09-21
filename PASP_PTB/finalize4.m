%% finalize
fprintf('done: %s\n',mat2str(done));
allOK = false;
if (exist ('records')>0)
    records = cell2table(records);
    allOK = true;
end
%% close connection
if done
    showImageNwait( CrossImage, window, windowRect, 4);
    showImageNwait( endImage, window, windowRect, 60); %show finishing slide
    if (allOK)
    records.Properties.VariableNames = {'startTime' 'amount' 'state','round','endTime'};
    writetable(records,sprintf('%s.csv',dataDirectory),'Delimiter',',');
    end
    fprintf('close and exit\n');
    if (contains(hardware,'ni'))
        fclose(fid1);
        t.stop;
        delete(t);
        clear t;
    elseif contains(hardware,'arduino')
        %cleanup
        try 
        stop(at);
        catch
        end
        clear at;
    end
    %if ~isempty(olfactometerIP)
    %    [time, echo] = olfactometer_web_command('Abort', olfactometerIP);
    %end
    clear records
    delete temp_var.mat
    delete records
    clear all
    close all
else
    %save for future reloads
    if (allOK)
    records.Properties.VariableNames = {'startTime', 'amount', 'state','round','endTime'};
    save ('records.mat', 'records');
    save('temp_var.mat','ii','run_num','amount','index','endtime','monetary_idx');
    writetable(records,sprintf('%s_partial.csv',dataDirectory),'Delimiter',',');
    end
    if (contains(hardware,'ni'))
        fclose(fid1);
        t.stop;
    elseif contains(hardware,'arduino')
        stop(at);
        clear at;
    end
    
    %TriggerLabChart('early_termination',olfactometerIP,experimentStart);
end
sca