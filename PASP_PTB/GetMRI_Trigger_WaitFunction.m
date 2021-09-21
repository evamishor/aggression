function waitForTRFunction = GetMRI_Trigger_WaitFunction(useTR_FromMagnet, maxTime)
%% waitForTRFunction = GetMRI_Trigger_WaitFunction(useTR_FromMagnet)
%% Returns a function which take one parameter of max-time (in seconds) to wait.
%% This returned function will return if one of the following events happend:
%%    1. The max-time elasped
%%    2. A TR recived in the pre-defined port
%%    3. Any keyboard pressed (checked using psychtoolbox)

if useTR_FromMagnet
    MR_TTL = 160; % parallel port MR TTL
    % Create object for trigger coming through LPT port (Weizmann Magnet):
    ioObj = io64();
    status = io64(ioObj); %#ok<NASGU> %initialize the inpout32.dll system driver
    portAddress = hex2dec('C031'); % the address on "Computer 3" in FRMI room
else
    MR_TTL = 0;
    ioObj = [];
    portAddress = '';
end

if exist('maxTime', 'var')
    waitForTRFunction = @() WaitForTR(useTR_FromMagnet, ioObj, portAddress, MR_TTL, maxTime);
else
    waitForTRFunction = @(maxTime) WaitForTR(useTR_FromMagnet, ioObj, portAddress, MR_TTL, maxTime);
end
end

function WaitForTR(useTR_FromMagnet, ioObj, address, TR_TTL, maxTime)
if ~useTR_FromMagnet
    return;
end

% all is ready, wait for trigger
gotTR = false;
if ~exist('maxTime', 'var')
    maxTime = 30; % seconds
end
waitingStartTime = tic;
lastPrintedSec = 0;
clear KbCheck;
while ~gotTR && toc(waitingStartTime) < maxTime
    ioValue = io64(ioObj,address);
    gotTR = ioValue == TR_TTL; % wait for TTL, which has the value of 127 for 25ms
    if lastPrintedSec + 1 < toc(waitingStartTime) || gotTR
        lastPrintedSec = toc(waitingStartTime);
        fprintf('After %3.2f seconds, got value %d in address %d\n', lastPrintedSec, ioValue, address);
    end
    
%     if KbCheck
%         fprintf('Exiting "Waiting-For-TR" since keyboard pressed.\n');
%         return;
%     end
end
if ~gotTR
    fprintf('Exiting "Waiting-For-TR" since timeout ends.\n');
end

end