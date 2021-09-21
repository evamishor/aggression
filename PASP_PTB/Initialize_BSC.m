% close all
% clear all

%% User Initialization

% insert subject number
prompt = {'Enter subject number:'}; %description of fields

answer = inputdlg(prompt, 'Subject Number'); %opens dialog
subject = answer{1,:}; %Gets Subject Name
try
    seed = str2num(subject(2:end));
catch
end
%rng(seed);
%Movie_vec = rand(;

%%
sca

%shuold we add this for running the code faster?
%Priority(prio);
%prio = MaxPriority(...)

%% Psychtoolbox initializtion

Screen('Preference', 'SkipSyncTests', 1); 
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(1);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = floor((white + black) / 2);

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
InitializePsychSound;

RedColor = [255 0 0];

%% General Initalization
formatOut = 'ddmmyy';
date = datestr(now,formatOut);

baseDir = './data/'; 
subj = sprintf('%s_%s',subject,date);
mkdir(baseDir, subj);

imagesDirectory = 'stimuli/';
%ekmanDirectory = 'stimuli/ekman_VAS';
%MovieDirectory = 'stimuli/movies';
pleasantnessDirectory = 'stimuli/scales';


%rmpath(ekmanDirectory); rmpath(finalQDirectory); rmpath(MovieDirectory); 
rmpath(pleasantnessDirectory); %rmpath(ultimatumDirectory);

path(path, imagesDirectory);

PleaseWaitImage = 'wait.tiff';


minX = (253/1440)*(windowRect(3)-windowRect(1));
maxX = (1188/1440)*(windowRect(3)-windowRect(1));
minY = (472/900)*(windowRect(4)-windowRect(2));
maxY = (522/900)*(windowRect(4)-windowRect(2));

%Ekman Parameters
EkmanNumber = 0;

%NBG Parameters
%maxNBGAudioVolume = 1.5; %Currently assumes linear influence of buttons

%Pleasentness Parameters
waitBetweenSmells = 1;

experimentStart = GetSecs;
