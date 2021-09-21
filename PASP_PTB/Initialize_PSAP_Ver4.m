global one two subjectID leftOK rightOK state;
one = false;
two = false;
leftOK = false;
rightOK = false;
subjectID = '';
Screen('Preference', 'SkipSyncTests', 1)
PsychDebugWindowConfiguration
%clear Screen %to disable

%setting up escape
%****
%devices=PsychHID('Devices', 2); %detecting devices
%keyboard_idx = find(strcmp({devices.usageName},'Keyboard')); %detecting idx of keyboard
KbName('UnifyKeyNames');
KeysOfInterest = zeros(1,256); KeysOfInterest(KbName('ESCAPE'))=1;
%KbQueueCreate(keyboard_idx, KeysOfInterest); %opening a queue for escape key
KbQueueCreate(-1, KeysOfInterest);%listen to all keyboards
%KbQueueStart(keyboard_idx);
KbQueueStart(-1);
%****

done = false; %change to true if you want this to start from the beggiung every time
%% Say hello to olfactometer
% olfactometerIP = '132.77.68.251:8002';
% olfactometer_ping = olfactometer_web_command('hello', olfactometerIP);
% if olfactometer_ping > 2
%     warning('Olfactometer ping is more than 2 seconds')
% end
%% User Initialization

% insert subject number
    prompt={'Subject ID:';'Session number:'};
     formats(1) = struct('type','edit','format','text','limits',[0 1]);
  formats(2) = struct('type','edit','format','integer','limits',[0 3]);
  
      answer = inputsdlg(prompt, 'Subject information',formats); %opens dialog

    subject = lower(answer{1,:}); %Gets Subject Name
    session = answer{2,:}
    
%% Psychtoolbox initializtion

fprintf('initializing psychtoolbox...\n');
%Screen('Preference', 'SkipSyncTests', 1);  %IMPORTANT: for debug only! needs to be removed
%Screen('Preference', 'ConserveVRAM', 64); %IMPORTANT: for debug only! needs to be removed
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(1);  
screens = Screen('Screens'); % Get the screen numbers
screenNumber = max(screens); % Draw to the external screen if avaliable
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = [217 217 217]; %floor((white + black) / 2);
RedColor = [255 0 0];
green = [0 112 192]; %which is actually blue, but let's call it green

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray); %open a gray screen
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % Get the size of the on screen window

 %% General Initalization
formatOut = 'yyyymmdd';
date = datestr(now,formatOut);
timeofExp = datestr(now,'HHMM');
%
HomeDir = pwd;
baseDir = './data/'; 
subj = sprintf('%s_%s_PSAP_Eva_%s',date,timeofExp,subject);
mkdir(baseDir, subj);
dataDirectory = sprintf('data/%s',subj);

%loading images
CrossImage = 'cross.png';
beginImage = 'begin.png';
endImage = 'end.png';
PressAgainImage = 'no_press_input.png';
LastPart = 'last_part.png';
prepare2sniff = 'prepare_2_sniff.png';

xPos = windowRect(3)*.5; yPos = windowRect(4)*.73;
fprintf('loading functions...\n');
Screen('DrawText', window, 'initializing', xPos,yPos);

load('wait_for_provocation.mat');

%% open hardware session
if ~contains(hardware,'none')
    fid1 = fopen([dataDirectory '/data.csv'],'w');
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
    at = createArduinoExperimentTimer('/dev/tty.usbserial-A400eLBq','nano3',fid1);  
    start(at);
end

%% load previous session, if it was stopped

if exist('temp_var.mat')==2 %checking if the run stopped before
    load 'records.mat'
    load 'temp_var.mat'
    index = 1;
    monetary_idx = monetary_idx-1; 
    fprintf('loading previous session\n')

else %run over all previous...
    records = table;
    ii = 1;
    run_num = 0;
    amount = 5; %amount of money in PSAP
    index = 1; %index for presses
    endtime = NaN;
    monetary_idx = 0;
    fprintf('loading new session\n')
    %% odor initialization
    %randomize conditions
%     odors = {'Hex1', 'Hex2', 'control1','control2'};
%     odor_idx = 0;
%     try
%         rng(str2num(subject(end-2:end)))
%     catch
%     end
%     
%     if round(rand())
%         odors = {'control1','control2','Hex1', 'Hex2'};
%     end
%     odor_event = NaN;
%     general_file =sprintf('%s%s_general_data.csv',baseDir,subject);
%     general_data = table({subject},{date},{timeofExp},odors(1),odors(2),odors(3),odors(4),...
%         'VariableNames',{'subjectID','date','timeofExp','odor1','odor2','odor3','odor4'});
%     writetable(general_data,general_file,'Delimiter',',');
end

experimentStart = GetSecs;
