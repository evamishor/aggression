function [outputArg1,outputArg2] = write2subjFolders(subj,events_temp,protocolsOutputFolder,scans)
%This function writes protocols (3 columns) to subjects subfolders, so each
%subject gets its own folder for all the requested output.
%   In the case that the events that should be written are empty, the
%   script inserts 0 0 0.
%protocolsOutputFolder - the output folder
%subj - the subject's identifier
%scans - which run is this? deal with left empty
%event_types - the types of events we want to protocol
%events_temp - the matrix we write to file
if isempty(events_temp)
    events_temp = [0 0 0];
end
if ii==1 & jj==1 %only create a folder for the first time
    mkdir(sprintf('%s/%s',protocolsOutputFolder,upper(subj)))
end
fileID = fopen(sprintf('%s/%s/%s_%s.txt',protocolsOutputFolder, upper(subj),scans{ii},event_types{jj}),'w');
%fileID = fopen(sprintf('/Users/eva/Desktop/PSAP_fMRI/protocols/%s/run11_%s.txt',upper(subj),event_types{jj}),'w');

if fileID==-1
    error('Cannot open file for writing: %s', sprintf('/Users/eva/Desktop/%s/%s_%s.txt',upper(subj),scans{ii},event_types{jj}));
end

fprintf(fileID, '%0.2f %0.2f %.0f\r\n',events_temp');
fclose(fileID);
clear events_temp
end

