function output = playAudio( file_name, maxPlayLength, masterVolume)
%PLAYAUDIO Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    masterVolume = 1.0;
end

if nargin < 2
    maxPlayLength = 1000;
end
[y, freq] = audioread(file_name);
wavedata = y';
nrchannels = size(wavedata,1); % Number of rows == number of channels.
autioLength = size(wavedata, 2); % Number of rows == number of channels.

try
    % Try with the 'freq'uency we wanted:
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
catch
    % Failed. Retry with default frequency as suggested by device:
    fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
    fprintf('Sound may sound a bit out of tune, ...\n\n');
    
    psychlasterror('reset');
    pahandle = PsychPortAudio('Open', [], [], 0, [], nrchannels);
end
PsychPortAudio('FillBuffer', pahandle, wavedata);

PsychPortAudio('Volume', pahandle, masterVolume);

% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);

pause(min(length(y)/freq, maxPlayLength));

PsychPortAudio('Stop', pahandle);

% Close the audio device:
PsychPortAudio('Close', pahandle);


end

