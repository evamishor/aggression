%testSqueezeRelease
global one two subjectID leftOK rightOK state sq_thresh rel_thresh leftIndex rightIndex baseline1 baseline2  ;

one = false;
two = false;
leftOK = false;
rightOK = false;
sq_thresh = 0.3;
rel_thresh = -0.3;
subjectID = '';
leftIndex = 0;
rightIndex = 0;
baseline1 = 0;
baseline2 = 0;
state = 'noPress';
hardware = 'arduino';
%% prepare for break on keypress
FlushEvents
ListenChar
%% open hardware session
dataDirectory = sprintf('data/%s','test');
if ~contains(hardware,'none')
    fid1 = fopen([dataDirectory '_data.csv'],'w');
    fprintf('opening connection...\n');
end
if (contains(hardware,'ni'))
    clear t;
    t = createInputSession('both');
    lh = addlistener(t,'DataAvailable', @(src, event)detectSqueezeRelease1(src, event, fid1)); %create listener
    t.IsContinuous = true;
    t.Rate=100;
    t.NotifyWhenDataAvailableExceeds = 20;
    t.startBackground();
elseif (contains(hardware,'arduino'))
    at = createArduinoExperimentTimer('/dev/tty.usbserial-A400eLBq','nano',fid1);
    start(at);
end



stateArr = {'nopress','strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL'};
index = 1;

%showImageNwait( CrossImage, window, windowRect, 4) %cross image
fprintf('cross image 4 seconds\n');
waitForSecs(4)

fprintf('preparing for squeeze strengths...\n');
while index<=length(stateArr)
    state = stateArr{index};
    leftOK = false;
    rightOK = false;
    %showImageNwait( CrossImage, window, windowRect, 4) %cross image
    fprintf('beginning squeezes + %s + %d\n',state,index);
    fprintf('cross image 4 seconds\n');
    waitForSecs(4)
    fprintf('squeeze 3 seconds\n');
    waitForSecs(3)
    fprintf('cross image 4 seconds\n');
    waitForSecs(4)
    %showImageNwait( beginImage, window, windowRect, 4) %begin image
    %showImageNwait( CrossImage, window, windowRect, 4)
    %showImageNwait( CrossImage, window, windowRect, 4) %cross image
    index = index+1;
    
    if CharAvail()% break on keypress
        fprintf('******* keypress detected. will quit at the end of this iteration\n');
        break
    end
    if (strcmp(state,'lightL'))
        if ~leftOK
            fprintf('press again left %s %d\n',state,index);
            %showImageNwait( PressAgainImage, window, windowRect, 4)
            index = index - 1;
        else
            leftIndex = leftIndex+1;
        end
    end
    if (strcmp(state,'lightR'))
        if ~rightOK
            fprintf('press again right %s %d\n',state,index);
            %showImageNwait( PressAgainImage, window, windowRect, 4)
            index = index - 1;
        else
            rightIndex = rightIndex+1;
        end
    end
    
end

one = false;
two = false;

waitForSecs(60);


%%
if (contains(hardware,'ni'))
    fclose(fid1);
    t.stop;
    delete(t);
    clear t;
elseif contains(hardware,'arduino')
    %cleanup
    stop(at);
    clear at;
    %clear all;
end

%%

function waitForSecs(secs)
start = GetSecs;
while(GetSecs-start<secs)
    pause(0.1)
end
end
