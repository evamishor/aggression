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



state = 'nopress';
index = 1;

%showImageNwait( CrossImage, window, windowRect, 4) %cross image
fprintf('cross image 4 seconds\n');
waitForSecs(4)

%fprintf('preparing for squeeze strengths...\n');
sq_thresh = 1;
rel_thresh = -1;

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
