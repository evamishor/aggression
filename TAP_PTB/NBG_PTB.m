%%before start
Initialize
%%
% ekman
% Ekman1StartTime = GetSecs;
% Ekman
% Ekman1TotalTime = GetSecs - Ekman1StartTime;
% % wait and space   
% showImageNspace(PleaseWaitImage, window, windowRect);
% 
% % pleasentness smell
% PleasantnessStartTime = GetSecs;
% Pleasantness
% PleasantnessTotalTime = GetSecs - PleasantnessStartTime;
% 
% %% wait and space
% showImageNspace(PleaseWaitImage, window, windowRect)
% 
%% ultimatum
HideCursor()
UltimatumStartTime = GetSecs;
Ultimatum
UltimamtumTotalTime = GetSecs - UltimatumStartTime;

%% wait and space
showImageNwait(PleaseWaitImage, window, windowRect, 15)

%% NBG 
NBGStartTime = GetSecs;
NBG
NBGTotalTime = GetSecs - NBGStartTime;

%% wait and space
showImageNwait(PleaseWaitImage, window, windowRect,15)

%% ekman 2
Ekman2StartTime = GetSecs;
Ekman
Ekman2TotalTime = GetSecs - Ekman2StartTime;

%% wait and space
showImageNwait(PleaseWaitImage, window, windowRect, 15)

%% Final Q
FinalQStartTime = GetSecs;
FinalQ
FinalQTotalTime = GetSecs - FinalQStartTime;

%% wait and space
showImageNspace(PleaseWaitImage, window, windowRect)
ShowCursor();
sca;

%% Finalize
ExperimentTotalTime = GetSecs - experimentStart;
%add general times....
%write into a file: stats.
%%
fileName = sprintf('/%s_Stats.csv', subj);
fileTitle = {'subjectID', 'ExperimentPart', 'TotalTime'};
fileID = fopen([baseDir subj fileName], 'w');

fprintf(fileID, '%s,%s,%s,%s\n', fileTitle{1, :});
fprintf(fileID, '%s,%s,%4.4f', subj, 'Ekman1', Ekman1TotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'Pleasantness', PleasantnessTotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'Ultimatum', UltimamtumTotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'NBG', NBGTotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'Ekman2', Ekman2TotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'Ekman2', FinalQTotalTime);
fprintf(fileID, '%s,%s,%4.4f', subj, 'Total', ExperimentTotalTime);

fclose(fileID);
rmpath('stimuli/');