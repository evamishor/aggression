%testSqueezeRelease
global one two subjectID leftOK rightOK state sq_thresh rel_thresh leftIndex rightIndex baseline1 baseline2  ;

one = false;
two = false;
leftOK = false;
rightOK = false;
sq_thresh = 1.7;
rel_thresh = 1.7;
subjectID = '';
leftIndex = 0;
rightIndex = 0;
baseline1 = 0;
baseline2 = 0;
state = 'noPress';

 fid1 = fopen(['data' '\data.csv'],'w');
    fprintf('opening connection...\n');
    if (exist('at')>0)
    clear('at')
    end
    at = createArduinoExperimentTimer('/dev/tty.usbserial-A400eLBq','nano3',fid1);  
    start(at);
    % Get squeeze strengths
    % get all presses

stateArr = {'nopress','strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL'};
index = 1;

%showImageNwait( CrossImage, window, windowRect, 4) %cross image
fprintf('cross image 4 seconds');
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
        fprintf('cross image 3 seconds\n');
        waitForSecs(3)
        fprintf('cross image 4 seconds\n');
        waitForSecs(4)
        %showImageNwait( beginImage, window, windowRect, 4) %begin image
        %showImageNwait( CrossImage, window, windowRect, 4)
        %showImageNwait( CrossImage, window, windowRect, 4) %cross image
        index = index+1;
        
             
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
    
     %%
     waitForSecs(60);


    %%
    stop(at);
    %fclose(fid1);
    
    %%
    
    function waitForSecs(secs)
    start = GetSecs;
    while(GetSecs-start<secs)
        pause(0.1)
    end
    end
    