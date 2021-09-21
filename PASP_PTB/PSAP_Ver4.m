sca
clear all
close all
%% globals
global one two subjectID leftOK rightOK state sq_thresh rel_thresh leftIndex rightIndex baseline1 baseline2  ;
one = false;
two = false;
leftOK = true;
rightOK = true;
sq_thresh = [0 0];
rel_thresh = [-0.05 -0.05];
leftIndex = 0;
rightIndex = 0;
baseline1 = 0;
baseline2 = 0;
subjectID = '';

%% init
%clear all % in case i want to get out of this mode
fprintf('Initializing...\n');
% modes: 
% short - only one PSAP session, no presses. 
% long - one PSAP session, with presses. 
% double_short - two PSAP sessions, no presses, no movie. 
% double_long - two PSAP sessions, with presses, no movie. 
% all - presses+ two PSAP sessions with movie. 
% movie -  only movie. 
% short_NL - short without labview. 
% long_NL - long without labview. 
% double_short_NL - double short without labview
% double_long_NL - double long without labview.
% all_NL - all without labview
% movie_NL - movie without labview.
mode = 'short';
hardware = 'arduino';% none | ni | arduino
if (contains(mode,'NL'))
    hardware = 'none';
    t = 'nohardware';
end
useTR_FromMagnet = false;

%% INTIALIZER
Initialize_PSAP_Ver4
session
HideCursor
%% part 1 PSAP - initialize variables

fprintf('Initializing variables...\n');
waitTime = 1.2; textSize = 150;
xPos = windowRect(3)*.5; yPos = windowRect(4)*.32;
Screen('TextColor', window, green);
Screen('TextSize', window, 100);
records = {};

records{ii,1} = experimentStart;
records{ii,2} = NaN;
records{ii,3}= string('experiment start');
records{ii,4}= run_num;
records{ii,5}= NaN;

ii=ii+1; save ('records.mat', 'records');
% get all presses

stateArr = {'strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL','strongR','strongL','lightR','lightL'};
imgArr = {'strong_press_right.png','strong_press_left.png','light_press_right.png','light_press_left.png'...
    'strong_press_right.png','strong_press_left.png','light_press_right.png','light_press_left.png'...
    'strong_press_right.png','strong_press_left.png','light_press_right.png','light_press_left.png'};

%% CALIBRATION Get squeeze strengths
showImageNwait( CrossImage, window, windowRect, 4) ;%cross image

if contains(mode,'long')||contains(mode,'double_long')||contains(mode,'all')
    fprintf('preparing for squeeze strengths...\n');
    records{ii,1} = GetSecs-experimentStart; 
    records{ii,2} = NaN;
    records{ii,3}= string('calibration');
    showImageNwait( CrossImage, window, windowRect, 4) %cross image
    showImageNwait( beginImage, window, windowRect, 4) %begin image
    
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    EscPressError
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    
    state = 'nopress'; %no press
    records  = getSqueeze(records, ii,state, 'no_press.png',window,windowRect,textSize,xPos,yPos,waitTime,experimentStart);
    ii=ii+1; save ('records.mat', 'records');
    showImageNwait( CrossImage, window, windowRect, 4) %cross image
    
    while index<=length(stateArr)
        state = stateArr{index};
        leftOK = false;
        rightOK = false;
        records  = getSqueeze(records, ii,state, imgArr{index},window,windowRect,textSize,xPos,yPos,waitTime,experimentStart);
        ii=ii+1; save ('records.mat', 'records');
        showImageNwait( CrossImage, window, windowRect, 4) %cross image
        index = index+1;
        
        %*%*%*%*%*%*%%*%*%*%*%*%*%
        EscPressError
        %*%*%*%*%*%*%%*%*%*%*%*%*%
        
        if (strcmp(state,'lightL')) 
            if ~leftOK
                fprintf('press again left %s %d\n',state,index);
                showImageNwait( PressAgainImage, window, windowRect, 4)
                index = index - 1;
            else
                leftIndex = leftIndex+1;
                fprintf('leftindex+1: %d\n',leftIndex);
            end
        end
        if (strcmp(state,'lightR')) 
            if ~rightOK
                fprintf('press again right %s %d\n',state,index);
            showImageNwait( PressAgainImage, window, windowRect, 4)
            index = index - 1;
            else
                rightIndex = rightIndex+1;
            end
        end
    end
end

%% round 1 PSAP
%if run_num==0 %%% needs to be tested!
    run_num = 1;
    %odor_event = odors(1:2);
%end
%%
if ~contains(mode,'movie')
    
    fprintf('round 1...\n');
    % instructions, only in the first time
    if ~(exist('temp_var.mat')==2)
        showImageNspaceG(mode,'instructions1', window, windowRect, subject)%file should be named instructions1_w.png
        pause(0.3);
        showImageNspaceG(mode,'instructions2', window, windowRect, subject)
        pause(0.3);
        showImageNspaceG(mode,'instructions3', window, windowRect, subject)
        pause(0.3);
        showImageNwait( 'wait.png', window, windowRect, 5)
        showImageNwait( 'condition.png', window, windowRect, 5)
    end
    showImageNwait( 'begin_now.png', window, windowRect, 4)
    %% screen
    [xCenter, yCenter] = RectCenter(windowRect);
    position = [0 0 xCenter yCenter*2];
    % Get the centre coordinate of the window
    % Make a base Rect of 200 by 200 pixels
    frameSize = 200;
    x1 = xCenter/2-frameSize/1.5;
    baseRect = [x1 yCenter-300 x1+frameSize yCenter+frameSize/2];
    baseRect2 = baseRect+[xCenter 0 xCenter 0];
    %% states init
    counter=0;
    State.monetary.deadline = 10; %%12; %10 secs per round
    State.revenge.deadline = 4; %% 6; %4 secs per
    State.none.deadline = 12;
    full = 20;
    State.monetary.steptime = State.monetary.deadline/(2.5*full);
    State.none.steptime = State.monetary.steptime;
    State.revenge.steptime = State.revenge.deadline/full;
           
    %% PSAP run #1
%showImageNspace( CrossImage, window, windowRect )%waiting for participant

%waitForTRFunction = GetMRI_Trigger_WaitFunction(useTR_FromMagnet, 1000);

    if run_num==1 %only runs in case this it the right run
        
        %waitForTRFunction();
        timing = GetSecs;
        records(ii,:) = WriteRecoeds(experimentStart,timing,run_num, amount, '1st_TR');
        records{ii-1,5} = NaN; ii=ii+1;
        if (session==1)
            load('provocation_vec1.mat'); wait_for_provocation = wait_for_provocation1; %load the prerandomized provocation vecs
        else
            load('provocation_vec3.mat'); wait_for_provocation = wait_for_provocation3; %load the prerandomized provocation vecs
        end
        startTime = GetSecs;
        PSAP_Session_Ver4
        records{ii-1,5} = endtime;
        ii=ii+1;
        run_num = 2;
    end
end
%% PSAP run #2
% pause between runs
    showImageNspace(CrossImage, window, windowRect )
if run_num==2
    %waitForTRFunction();
    timing = GetSecs;
    records(ii,:) = WriteRecoeds(experimentStart,timing,run_num, amount, '2nd_TR');
    records{ii-1,5} = NaN;ii=ii+1;
    if (session==1)
        load('provocation_vec2.mat'); wait_for_provocation = wait_for_provocation2;
    else
        load('provocation_vec4.mat'); wait_for_provocation = wait_for_provocation4; %load the prerandomized provocation vecs
    end
    startTime = GetSecs;
    PSAP_Session_Ver4
    records{ii-1,5} = endtime;
    run_num = 3;
end

%% pause between runs
%showImageNspace( CrossImage, window, windowRect )
%% ANATOMICAL SCAN + MOVIE
% ii=ii+1;
% movieTime = GetSecs;
% %olfactometer_web_command('StartTone', olfactometerIP);
% records(ii,:) = WriteRecoeds(experimentStart,movieTime,run_num, amount, 'AnatomicalScan'); 
% %showImageNspace( CrossImage, window, windowRect )
% 
% % if contains(mode,'movie') || contains(mode,'all')
% %     fprintf('movie\n');
% %     state = 'movie';
% %     showImageNwait('now_movie.png', window, windowRect,10) %wait for 10 secs before movie
% %     %*%*%*%*%*%*%%*%*%*%*%*%*%
% %     EscPressError
% %     %*%*%*%*%*%*%%*%*%*%*%*%*%
% %     fprintf('sentstate\n');
% %     % Open movie file:
% %     moviename = [cd '/TV for Cats - Birds on Bluebell Log.mp4'];
% %     
% %     waitUntilEventFunction = [];
% %     %olfactometerIP = '';
% %     isKeyboardPressed = DisplayMovie(window, moviename, waitUntilEventFunction, olfactometerIP);
% %     
% %     fprintf('open movie\n');
% %     %*%*%*%*%*%*%%*%*%*%*%*%*%
% %     EscPressError
% %     %*%*%*%*%*%*%%*%*%*%*%*%*%
% % end   
% olfactometer_web_command('EndTone', olfactometerIP);
% movieTime = GetSecs;
% records{ii,5} = movieTime-experimentStart;
% ii=ii+1;
% 
% %% pause between runs
% showImageNspace( CrossImage, window, windowRect )
% 
% %% PSAP run #3
% %only for long modes
% if contains(mode,'double_short') || contains(mode,'double_long') || contains(mode,'all')
%     if run_num==3
%         amount=5; %start from the start
%         fprintf('round 3\n');
%         odor_event = odors(3:4);
%         waitForTRFunction();
%         timing = GetSecs;
%         records(ii,:) = WriteRecoeds(experimentStart,timing,run_num, amount, '3rd_TR');
%         records{ii-1,5} = NaN;ii=ii+1;
%         load('provocation_vec3.mat'); wait_for_provocation = wait_for_provocation3;
%         startTime = GetSecs;
%         PSAP_Session_Ver4
%         records{ii-1,5} = endtime;
%         run_num = 4;
%     end
% end
% %wait between runs
% showImageNspace( CrossImage, window, windowRect )
% %% PSAP run #4
% 
% if run_num==4
%     waitForTRFunction();
%     timing = GetSecs;
%     records(ii,:) = WriteRecoeds(experimentStart,timing,run_num, amount, '4th_TR');
%     records{ii-1,5} = NaN;ii=ii+1;
%     load('provocation_vec4.mat'); wait_for_provocation = wait_for_provocation4;
%     startTime = GetSecs;
%     PSAP_Session_Ver4
%     records{ii-1,5} = endtime;
% end

%%
done = true;
showImageNwait( CrossImage, window, windowRect, 5) %cross image while gre field map %%%% originally 30 seconds
%showImageNspace(LastPart, window, windowRect)
%Pleasantness_BSC
finalize4
%showImageNwait(endImage, window, windowRect, 180)
%%

function records =  getSqueeze(records, ii,stateName, filename,window,windowRect,textSize,xPos,yPos,waitTime,experimentStart)
state = stateName;

showImageNwait( filename, window, windowRect, 4)
squeezeTime = GetSecs;
%olfactometer_web_command('StartTone', olfactometerIP);
for jj=1:3 %count, 1...2...3  
    showImageTextNwait( filename, window, windowRect, num2str(jj), textSize, xPos-30, yPos+24, waitTime)
end
%olfactometer_web_command('EndTone', olfactometerIP);

records{ii,1} = squeezeTime-experimentStart;
records{ii,2} = NaN;
records{ii,3}= string(state);
records{ii,4}= NaN;
records{ii,5}= GetSecs-experimentStart;

end

