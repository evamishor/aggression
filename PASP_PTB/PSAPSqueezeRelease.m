function PSAPSqueezeRelease(time, v1,v2,fid)
%% globals
global one two state leftOK rightOK   ;
persistent recording startTime data;
if (isempty(startTime))
recording = false;
data = [];
startTime = 0;
end
persistent sum_sq sum_rel sq_thresh rel_thresh counter;
if (isempty(counter))
   counter = [0 0];
   sum_sq = [0 0];% [left right]
   sum_rel = [0 0];
   sq_thresh = [0.05 0.05];
   rel_thresh = [-0.05 -0.05];
end
%% variables
volt1 = v1;
volt2 = v2;
volt = [volt1 volt2];
recording_time = 8;%in seconds;
minimum_threshold = 0.05;%minimum threshold reached by user to update squeeze release parameters %%% originally more
threshold_percentage = 0.5;%percent of max/min to take as threshold.number between 0 and 1. %%% originally 0.7
%plot(time,volt,'-k');
%hold on;
%% write to file
for i=1:length(time)
    fprintf( fid, '%.8f,%.4f,%.4f,%s\n', exceltime(time(i)),volt1(i),volt2(i),state );
end
%% record data if necessary
% turn on recording if data empty and correct state and not already set
if ((strcmpi(state,'lightR')&&(~rightOK))||(strcmpi(state,'lightL')&&(~leftOK))) && isempty(data)
    startTime=GetSecs;
    recording = true;
end
%if recording, add new data to persistent data
if (recording)
    data = [data; volt];
end
% if recording for more than 5 seconds, stop recording, reset data, and set
% thresholds.
%fprintf('size of data: %d recording: %s GetSecs-startTime: %.5f\n',length(data),mat2str(recording),GetSecs-startTime);
if recording && ((GetSecs-startTime)>recording_time )
    %figure(1);plot(data);
    recording = false;
    data = diff(data);
    %hold on; plot (data);hold off
    b = false;%was threshold updated?
    max(max(data));
    tmp_sq_thresh = threshold_percentage*max(max(data));
    tmp_rel_thresh = threshold_percentage*min(min(data));
    if strcmpi(state,'LightL')
        index = 1;
    end
    if (strcmpi(state,'lightR'))
        index = 2;
    end
    fprintf('tmp sq thresh: %f minimum thresh: %f',tmp_sq_thresh,minimum_threshold);
    if (tmp_sq_thresh>minimum_threshold)
        
        sq_thresh(index) = tmp_sq_thresh;
        sum_sq(index) = sum_sq(index) + tmp_sq_thresh;
        counter(index) = counter(index) + 1;
        b = true;
    end
    if (tmp_rel_thresh<-minimum_threshold)
        rel_thresh(index) = tmp_rel_thresh;
        sum_rel(index) = sum_rel(index) + tmp_rel_thresh;
        b = true;
    end
    if strcmpi(state,'lightR') && b
        rightOK = true;
    end
    if strcmpi(state,'lightL') && b
        leftOK = true;
    end
    data = [];
end

if any(counter>2)
    index = find(counter>2);
    rel_thresh(index) = sum_rel(index)/3;
    sq_thresh(index) = sum_sq(index)/3;
    counter(index) = 0;
end
%% detect squeeze and release
numSensors = 2;
indicators = [one,two];
    
for i=1:numSensors
    dataVector = diff(volt(1:3:end,i));
    %figure(10); hold on
    %plot(exceltime(time(2:3:end-1)),dataVector,'-r'); 
    binaryVector = dataVector>sq_thresh(i);%vector for squeeze
    %figure(3); hold off; plot(binaryVector,'displayname','binary'); hold on; plot(volt,'displayname','volt'); plot(dataVector,'displayname','diff'); legend
    if (~isempty(find(binaryVector)))
        indicators(i) = true;
    end
    %[labeledVector, numRegions] = bwlabel(binaryVector);
    %measurements = regionprops(labeledVector,dataVector, 'Area', 'PixelValues');
    %for k = 1 : numRegions
    %    if measurements(k).Area >= 6 %checks if 10 consecutive values are above sq_thresh
    %        one = true
    %    end
    %end
    binaryVector = dataVector<rel_thresh(i);
    %[labeledVector, numRegions] = bwlabel(binaryVector);
    %measurements = regionprops(labeledVector, dataVector, 'Area', 'PixelValues');
    %for k = 1 : numRegions
    %    if measurements(k).Area >= 6 %checks if 10 consecutive values are below rel_thresh
    %        one = false
    %    end
    %end
    if (~isempty(find(binaryVector)))
        indicators(i) = false;
    end    
end
one = indicators(1);
two = indicators(2);
fprintf('[one two]: %s sq_thresh %f %f rel_thresh %f %f max: %f\n',mat2str(indicators), sq_thresh, rel_thresh,max(diff(volt,1,2)));
