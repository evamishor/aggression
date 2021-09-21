HideCursor();
path(path, NBGDirectory)
% fetching the shapes pics
imagesInFolder = dir(NBGDirectory);
ShapesSet1Images = {imagesInFolder(10:17,1).name};
ShapesSet2Images = {imagesInFolder(18:end,1).name};
waitTime = 6; %6 secs for countdown

Screen('TextSize', window, 120);

showImageNspace('Slide01.tiff', window, windowRect); %explanation
ima=imread('Slide02.tiff', 'tiff');
pause(7);
% countdown from 5 to 1
textPos = flip(1:1:5); %5 secs
for ii = 1:5
    Screen('PutImage', window, ima, windowRect); % put image on screen
    Screen('DrawText', window, num2str(textPos(ii)), windowRect(3) * .47, windowRect(4)*.65, RedColor);
    Screen('Flip', window, 0, 1);
    pause(1);
end

respTimeGame = []; buttonPressed = []; buttonPressedDuration = [];
waitTime  = [1.5 1 1.6 0.7];
delay = 2;

% win
showImageNwait('Slide08.tiff', window, windowRect, waitTime(1)); 
showImageNwait('Slide18.tiff', window, windowRect, 0); 
% get responseTime
respTime = waitForSpaceKey();

pause(max(delay - respTime, 0.2));
respTimeGame(end+1) = respTime;

showImageNwait('Slide03.tiff', window, windowRect, 0); %explanation
%recieve input from bbox
[RT, button, int] = listenToBox('out.mat');
buttonPressed(end+1) = button;
buttonPressedDuration(end+1) = RT;

pause(2)

% lose
showImageNwait('Slide09.tiff', window, windowRect, waitTime(3)); 
showImageNwait('Slide19.tiff', window, windowRect, 0);

respTime = waitForSpaceKey()
pause(max(delay - respTime, 0.2));
respTimeGame(end+1) = respTime;


showImageNwait('Slide04.tiff', window, windowRect, 0);

cuteSounds = {'funk.wav', 'phaser.wav'};

maxSoundLength = 2.5 * rand() + 1.5;

playAudio(cuteSounds{randi(2)}, maxSoundLength)
pause(2)

buttonPressed(end+1) = 0;
buttonPressedDuration(end+1) = 0;

%% NBG GAME
ima=imread('Slide05.tiff', 'tiff');
pause(2);
% Game on, countdown from 5 to 1
textPos = flip(1:1:5); %5 secs
for ii = 1:5
    Screen('PutImage', window, ima, windowRect); % put image on screen
    Screen('DrawText', window, num2str(textPos(ii)), windowRect(3) * .49, windowRect(4)*.65, RedColor);
    Screen('Flip', window, 0, 1);
    pause(1);
end

% ~ 3 6 9 += insert : keys of buttons.
TOTAL_TRIALS = 25;

counterRatio = @(soundsSoFar, trialsSoFar)( (10 - soundsSoFar) / (25 - trialsSoFar));
userTookSoLong = @(userRespTime)(userRespTime > 1.5);
mustGive10Shocks = @(soundsSoFar, trialsSoFar)((10 - soundsSoFar) > (TOTAL_TRIALS - trialsSoFar));

respTimesComputer = zeros(1, 25);
shocks = zeros(1, 25);

meanUserResponseTime = .35; %(respTimeGame(1) + respTimeGame(2)) /2; 

step = .7*meanUserResponseTime / 24;
timeFactor = [1.5*meanUserResponseTime: -step :.8*meanUserResponseTime]
counter = 0;

NBG_order_vec = [randperm(8) randperm(8) randperm(8) randperm(8,1)];
NBG_order_vec2 = [randperm(8) randperm(8) randperm(8) randperm(8,1)];

for ii=1:25;
    %how to define wheights: 2:1 in sound blasts. (give:receive)
    %how to depend it on the user but still keep ratio?
    showImageNwait(ShapesSet1Images{NBG_order_vec(ii)}, window, windowRect, waitTime(3));
    showImageNwait(ShapesSet2Images{NBG_order_vec2(ii)}, window, windowRect, 0);
    
    respTime = waitForSpaceKey(2);
    
    pause(max(delay - respTime, 0.2)); %rule?
    respTimeGame(end+1) = respTime;

    if respTime == -1
        respTime = 100;
    end
    
    %Simulate Game
    %[(.5 / counterRatio(counter, ii - 1)) counterRatio(counter, ii - 1) ]
    respTimeComputer = ( (.5 / counterRatio(counter, ii - 1)) * timeFactor(ii))  * rand();
    if respTimeComputer < 0, respTimeComputer = 3; end;
    respTimesComputer(ii) = respTimeComputer;

    if respTimeComputer < respTime || userTookSoLong(respTime) || mustGive10Shocks(counter, ii - 1)
        counter = counter + 1;
        shocks(ii) = 1;
    end    
    wonGame = ~shocks(ii);
    [respTime respTimeComputer wonGame]
    %if % something something somehow
    %    win
    if wonGame
    % get responseTime         
        showImageNwait('Slide06.tiff', window, windowRect, 0); %explanation
        %              recieve input from bbox
        %pause(2)
        
        [RT, button, int] = listenToBox('out.mat');
        buttonPressed(end+1) = button;
        buttonPressedDuration(end+1) = RT;
    else %lose

        showImageNwait('Slide07.tiff', window, windowRect, 0);
        cuteSounds = {'funk.wav', 'phaser.wav'};
        maxSoundLength = 2.5 * rand() + 1.5;
        soundVolume = randi(6) / 6 * maxNBGAudioVolume;

        playAudio(cuteSounds{randi(2)}, maxSoundLength, soundVolume)

        pause(2)

        buttonPressed(end+1) = 0;
        buttonPressedDuration(end+1) = 0;
    end
end

%% save to file
% Write the trial information to the text file
NBG_order_vec = [1 2 NBG_order_vec];
NBG_order_vec2 = [3 4 NBG_order_vec2];

fileName = sprintf('/%s_NBG.csv', subj);

fileTitle = {'subjectID', 'TrialNumber', 'Shapes1order', 'Shapes2order',...
    'RT', 'BBoxPress', 'BBoxDuration'};


fileID = fopen([baseDir subj fileName], 'w');
fprintf(fileID, '%s,%s,%s,%s,%s,%s,%s\n', fileTitle{1, :});

formatSpec = '%s,%d,%d,%d,%2.4f,%d,%2.4f\n';

%assert(length(respTimeGame) == 27);
for ii = 1:length(respTimeGame)
    NBGMat{ii, 1} = subj;
    NBGMat{ii, 2} = ii;
    NBGMat{ii, 3} = NBG_order_vec(ii);
    NBGMat{ii, 4} = NBG_order_vec2(ii);
    NBGMat{ii, 5} = respTimeGame(ii);
    NBGMat{ii, 6} = buttonPressed(ii);
    NBGMat{ii, 7} = buttonPressedDuration(ii);
end
[nrows,ncols] = size(NBGMat);
for row = 1:nrows
    fprintf(fileID,formatSpec, NBGMat{row,:});
end

fclose(fileID);

NBG_order_vec(1:2) = [];
NBG_order_vec2(1:2) = [];

rmpath(NBGDirectory);
