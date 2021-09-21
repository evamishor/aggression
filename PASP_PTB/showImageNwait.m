function output = showImageNwait( myimgfile, window, windowRect, waitTime)
%SHOWIMAGENSPACE Summary of this function goes here
%   Detailed explanation goes here
try
    timing = GetSecs; %time now
    commandwindow;
    
    ima=imread(myimgfile);
    
    Screen('PutImage', window, ima, windowRect); % put image on screen
    Screen('Flip', window, 0, 1); % now visible on screen
    while (GetSecs<timing+waitTime)
        pause(0.1);
    end
    %WaitSecs(waitTime);
    
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    rethrow(lasterror);
end %try..catch..

end

