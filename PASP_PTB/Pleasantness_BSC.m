% Initialize_BSC
% 
% PleasantnessStartTime = GetSecs;
% Pleasantness_BSC
% PleasantnessTotalTime = GetSecs - PleasantnessStartTime;
% sca
% PsychDefaultSetup(1);
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray); %open a gray screen
LastPart = 'last_part.png';
prepare2sniff = 'prepare_2_sniff.png';


InitializePsychSound;
pleasantnessDirectory = 'stimuli/scales';
EkmanNumber = 0;
num_of_odors = 5;
%Pleasentness Parameters
waitBetweenSmells = 20;
minX = (253/1440)*(windowRect(3)-windowRect(1));
maxX = (1188/1440)*(windowRect(3)-windowRect(1));
minY = (472/900)*(windowRect(4)-windowRect(2));
maxY = (522/900)*(windowRect(4)-windowRect(2));

experimentStart = GetSecs;

path(path, pleasantnessDirectory);
imagesInFolder = dir(pleasantnessDirectory);
JarsImage = {imagesInFolder(3:end,1).name};

Pleasentness_order_vec = randperm(num_of_odors); %randomization of smells

minY1 = (266/900)*(windowRect(4)-windowRect(2));
maxY1 = (316/900)*(windowRect(4)-windowRect(2));
minY2 = (531/900)*(windowRect(4)-windowRect(2));
maxY2 = (581/900)*(windowRect(4)-windowRect(2));
minY3 = (786/900)*(windowRect(4)-windowRect(2));
maxY3 = (836/900)*(windowRect(4)-windowRect(2));

clickRect1 = [minX, minY1, maxX, maxY1];
clickRect2 = [minX, minY2, maxX, maxY2];
clickRect3 = [minX, minY3, maxX, maxY3];

clickRects = [clickRect1; clickRect2; clickRect3];

X1 = []; X2 = []; X3 = [];
RT1 = []; RT2 = []; RT3 = [];

for ii = 1:num_of_odors
    %text = num2str(Pleasentness_order_vec(ii));
    
    text2 = sprintf('%d/%d', ii, num_of_odors);
    
    texts = {text; text2};
    event = sprintf('event%d',Pleasentness_order_vec(ii));
    
    [x, y, RT] = imageNmouse3Clicks(JarsImage, window, windowRect, screenNumber, clickRects, texts, ii, waitBetweenSmells, event, olfactometerIP,prepare2sniff, xPos,yPos);  
    X1 = [X1 x(1)]; X2 = [X2 x(2)]; X3 = [X3 x(3)];
    RT1 = [RT1 RT(1)]; RT2 = [RT2 RT(2)]; RT3 = [RT3 RT(3)];
end

fileName = sprintf('/%s_Pleasantness.csv', subj); 

fileTitle = {'subjectID', 'TrialNumber', 'StimuliOrder', 'X1',...
    'X2', 'X3', 'RT1', 'RT2', 'RT3'};

fileID = fopen([baseDir subj fileName], 'w');

fprintf(fileID, '%s,%s,%s,%s,%s,%s,%s,%s,%s\n', fileTitle{1, :});


formatSpec = '%s,%d,%d,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f\n';

%assert(length(X1) == num_of_odors);
for ii = 1:length(X1)
    pleasentnessMat{ii, 1} = subj;
    pleasentnessMat{ii, 2} = ii;
    pleasentnessMat{ii, 3} = Pleasentness_order_vec(ii);
    pleasentnessMat{ii, 4} = X1(ii);
    pleasentnessMat{ii, 5} = X2(ii);
    pleasentnessMat{ii, 6} = X3(ii);
    pleasentnessMat{ii, 7} = RT1(ii);
    pleasentnessMat{ii, 8} = RT2(ii);
    pleasentnessMat{ii, 9} = RT3(ii);
end
[nrows,ncols] = size(pleasentnessMat);
for row = 1:nrows
    fprintf(fileID,formatSpec, pleasentnessMat{row,:});
end

fclose(fileID);


rmpath(pleasantnessDirectory);