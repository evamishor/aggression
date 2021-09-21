function detectSqueezeRelease1(src,event,fid)
%% globals
global one two state leftOK rightOK sq_thresh rel_thresh baseline1 baseline2 rightIndex leftIndex;
persistent recording startTime data;
if (isempty(startTime))
recording = false;
data = [];
startTime = 0;
end
%% variables
time = event.TimeStamps;
volt = event.Data;
volt1 = event.Data(:,1);
volt2 = event.Data(:,2);
recording_time = 8;%in seconds;
minimum_threshold = 0.05;%minimum threshold reached by user to update squeeze release parameters
threshold_percentage = 0.50;%percent of max/min to take as threshold.number between 0 and 1.
%plot(time,volt,'-k');
%hold on;
%% write to file
for i=1:length(time)
    fprintf( fid, '%.4f,%.4f,%.4f,%s\n', time(i),volt1(i),volt2(i),state );
end
%% record data if necessary
% turn on recording if data empty and correct state and not already set
if ((strcmpi(state,'lightR')&&(~rightOK))||(strcmpi(state,'lightL')&&(~leftOK))||(strcmpi(state,'nopress'))) && isempty(data)%||(strcmpi(state,'cross'))
    startTime=GetSecs;
    recording = true;
end
%if recording, add new data to persistent data
if (recording)
    data = [data; volt];
end
% if recording for more than 5 seconds, stop recording, reset data, and set
% thresholds.
%fprintf('size of data: %d recording: %s GetSecs-startTime:
%%.5f\n',length(data),mat2str(recording),GetSecs-startTime);
if (strcmpi(state,'cross'))
    recording_time = 4;
else
    recording_time = 8;
end  
if recording && ((GetSecs-startTime)>recording_time )
   
    recording = false;
    %size(data)
    if (strcmpi(state,'nopress')|| strcmpi(state,'cross'))
        baseline1 = mean(data(:,1));
        baseline2 = mean(data(:,2));
    else
    
    %data = diff(data);
    data = data-[baseline1 baseline2];
    %figure(1);plot(data);
    %hold on; plot (data);hold off
    b = false;%was threshold updated?
    tmp_sq_thresh = threshold_percentage*max(max(data));
    tmp_rel_thresh = threshold_percentage*min(min(data));
    %figure(1);plot(data);line([1,length(data)],[tmp_sq_thresh tmp_sq_thresh]);
    if (tmp_sq_thresh>minimum_threshold)
        sq_thresh = sq_thresh+tmp_sq_thresh;
        b = true;
    end
    if (tmp_rel_thresh<-minimum_threshold)
        rel_thresh = rel_thresh  +tmp_rel_thresh;
        b = true;
    end
    if strcmpi(state,'lightR') && b
        rightOK = true;
        %fprintf('rightIndex: %d\n',rightIndex);
        %if (rightIndex>=2)
        %    sq_thresh = sq_thresh/3;
        %    fprintf('sq_thresh: %d\n',sq_thresh);
        %end
          
    end
    if strcmpi(state,'lightL') && b
        leftOK = true;
        fprintf('leftIndex: %d\n',leftIndex);
        if (leftIndex>=2)
            sq_thresh = sq_thresh/6;
            fprintf('sq_thresh: %d\n',sq_thresh);
        end
    end
    end
    data = [];
end
%% update baseline
% if (strcmpi(state,'cross'))
%     baseline1 = mean(volt(:,1));
%     baseline2 = mean(volt(:,2));
% end
%% detect squeeze and release
numSensors = 2;
%size(volt)
indicators = [one,two];
toSubtract = [baseline1 baseline2];
%size(toSubtract)
%figure(2);plot(volt-toSubtract);line([1,length(volt)],[sq_thresh sq_thresh]);
for i=1:numSensors
    %dataVector = diff(volt(:,i));
    %dataVector = diff(volt(:,i));
    dataVector = volt(:,i)-toSubtract(i);
    %plot(time(1:end-1),dataVector,'-r');
    binaryVector = dataVector>sq_thresh;%vector for squeeze
    %if (~isempty(find(binaryVector)))
    %    indicators(i) = true;
    %end
    %plot(binaryVector);
    [labeledVector, numRegions] = bwlabel(binaryVector);
    measurements = regionprops(labeledVector,binaryVector, 'Area', 'PixelValues');
    for k = 1 : numRegions
        if measurements(k).Area >= 4 %checks if 10 consecutive values are above sq_thresh
            indicators(i) = true;
        end
    end
    binaryVector = dataVector<sq_thresh;
    [labeledVector, numRegions] = bwlabel(binaryVector);
    measurements = regionprops(labeledVector, binaryVector, 'Area', 'PixelValues');
    for k = 1 : numRegions
        if measurements(k).Area >= 6 %checks if 10 consecutive values are below rel_thresh
            indicators(i) = false;
        end
    end
end
one = indicators(1);
two = indicators(2);
%fprintf('logic: %s %s. thresh: %d baseline1: %.2f baseline2: %.2f recording: %s state: %s\n.',mat2str(one),mat2str(two),sq_thresh,baseline1,baseline2,mat2str(recording),state);
%result of squeezes;
    % if strcmp(state,'lightL') && contains(command,'OK')
    %     leftOK = true;
    % end
    % if strcmp(state,'lightR') && contains(command,'OK')
    %     rightOK = true;
    % end
    % %update globals
    % if (contains(command,'s1')) % squeeze 1
    %     one=true;
    % end
    % if (contains(command,'s2')) % squeeze 2
    %     two = true;
    % end
    % if (contains(command,'r1')) % release 1
    %     one = false;
    % end
    % if (contains(command,'r2')) % release 2
    %     two = false;
    % end
    % if length(command)>1
    %     fprintf('command is %s. one = %s, two = %s\n',command,mat2str(one),mat2str(two));
    % end