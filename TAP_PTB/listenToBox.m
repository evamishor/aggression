function [ RT, button, interrupted ] = listenToBox(timeOut )
%LISTENTOBOX Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    timeOut = 120;
end

disp 'Begin Listening to Box'

button = 0;
processed = false;
startTime = GetSecs;

newEvents = 0;
lastEvent = 0;

RT = -1; interrupted = false;
hudpr = dsp.UDPReceiver('LocalIPPort', 5005, 'RemoteIPAddress', '127.0.0.1');
while GetSecs - startTime < timeOut
    try
       interrupted = step(hudpr);
       
       if ~isempty(interrupted)
           recievedMessage = sprintf('%s ', char(interrupted));
           p = sscanf(recievedMessage, '%d,%d,%d,%s')
           newEvents = newEvents + 1;
       end
    catch
        pause(.01)
    end
    for ii = lastEvent+1:newEvents
        if p(2) == 68 %KETDN
            button = p(1);
            startTime = p(3);
        end
        if p(2) == 85
            if p(1) == button
                endTime = p(3);
                processed = true;
            end
        end
    end
    if processed
        RT = endTime - startTime;
        interrupted = (newEvents - lastEvent ~= 1);
        break;
    end
    lastEvent = newEvents;
    pause(.06);
end

end

