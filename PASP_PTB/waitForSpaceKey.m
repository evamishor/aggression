function respTime = waitForSpaceKey(maxTimeToWait)
%WAITFORSPACEKEY waits for maxTimeToWait for space key press. 

if nargin < 1
    maxTimeToWait = 2000;
end

spaceKey = KbName('SPACE');
Starttime = GetSecs;
respToBeMade = true;
while respToBeMade
    [~, secs, keyCode] = KbCheck;
    %[secs, keyCode, ~] = KbWait;
    if keyCode(spaceKey)
        respTime = secs - Starttime;
        return
    end
    if GetSecs - Starttime > maxTimeToWait
        respTime = NaN;
        return
    end
end
end

