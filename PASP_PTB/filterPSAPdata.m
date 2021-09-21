lpFilt = [];
fs = 1000; fpass = 10;
tickRateInPart = 1000;
passbandFreq = 1; % Hz
stopbandFreq = passbandFreq*2; % Hz

for fileLoop=1:length(Subject_info)      
    %% filter the data
    if FilterData
        if isempty(lpFilt) || lpFilt.PassbandFrequency ~= passbandFreq || lpFilt.StopbandFrequency ~= stopbandFreq || lpFilt.SampleRate ~= tickRateInPart
            lpFilt = designfilt('lowpassfir', 'PassbandFrequency', passbandFreq,...
                'StopbandFrequency', stopbandFreq, ...
                'PassbandRipple', 0.2, ...
                'SampleRate',tickRateInPart);
        end
        %% Use filter on the data
        currentPressChannelFiltered = filter(lpFilt, Subject_info(fileLoop).PressureDATA.rawLC(:,1));
        filterLength = numel(lpFilt.Coefficients);
        filterLengthDelay = round(filterLength/2);
        currentPressChannelFiltered = currentPressChannelFiltered(filterLengthDelay:end);
        
        currentPressChannelFiltered1 = filter(lpFilt, Subject_info(fileLoop).PressureDATA.rawLC(:,2));
        filterLength = numel(lpFilt.Coefficients);
        filterLengthDelay = round(filterLength/2);
        currentPressChannelFiltered1 = currentPressChannelFiltered1(filterLengthDelay:end);
        
        Subject_info(fileLoop).PressureDATA.filtered(:,1) = currentPressChannelFiltered;
        Subject_info(fileLoop).PressureDATA.filtered(:,2) = currentPressChannelFiltered1;
    end
    window_size = 50; %why? how do I determine this?
    Subject_info(fileLoop).PressureDATA.movmean(:,1) = movmean(Subject_info(fileLoop).PressureDATA.rawLC(:,1),window_size);
    Subject_info(fileLoop).PressureDATA.movmean(:,2) = movmean(Subject_info(fileLoop).PressureDATA.rawLC(:,2),window_size);
    fprintf('filter for subject %s completed (fileLoop = %d)\n',Subject_info(fileLoop).subjectID,fileLoop)
end