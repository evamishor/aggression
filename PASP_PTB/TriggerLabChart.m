function [endtime] = TriggerLabChart(incident,olfactometerIP,experimentStart)
%TRIGGERLABCHART sends # triggers to the labchart dependent on the incident.
%for incident of type provocation it sends 1 trigger
%for incident of type revenge it sends 2 triggers
%for incident of type monetary it sends 3 triggers
%for incident of type 'early termination' it sends 4 triggers
%for incident of type end_event it sends 1 trigger that is 200 ms.
endtime = NaN;
if ~isempty(olfactometerIP)
    incident = lower(incident);
    
    if ~strcmp(incident,'end_event')
        n=find(strcmp(incident,{'provocation','revenge','monetary', 'early_termination'}));
        for ii=1:n
            [time, echo] = olfactometer_web_command('StartTone', olfactometerIP);
            WaitSecs(0.01);
            [time, echo] = olfactometer_web_command('EndTone', olfactometerIP);
            WaitSecs(0.01);
        end
    elseif strcmp(incident,'end_event')
        [time, echo] = olfactometer_web_command('StartTone', olfactometerIP);
        WaitSecs(0.20);
        [time, echo] = olfactometer_web_command('EndTone', olfactometerIP);
        endtime = GetSecs-experimentStart;
    else
        disp('incident is unrecognized, no trigger was sent');
    end
end

