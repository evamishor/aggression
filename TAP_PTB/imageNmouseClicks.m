function [ x , y, RT ] = imageNmouseClicks( myimgfile, window, windowRect, screenNumber, clickRect )
%IMAGENMOUSECLICKS Summary of this function goes here
%   Detailed explanation goes here
try
        commandwindow;
        ima=imread(myimgfile, 'tiff');
        pause(.5);
        
        Screen('PutImage', window, ima, windowRect); % put image on screen
        Screen('Flip', window, 0, 1); % now visible on screen
        startTime = GetSecs;
        ShowCursor();
        while true
            [~,x,y,~] = GetClicks(screenNumber);
            if pointInRect(x, y, clickRect)
                RT = GetSecs-startTime;
                break; 
            end
        end
        HideCursor();
    catch
        %this "catch" section executes in case of an error in the "try" section
        %above.  Importantly, it closes the onscreen window if its open.
        rethrow(lasterror);
    end %try..catch..

end

