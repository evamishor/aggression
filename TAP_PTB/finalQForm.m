function [ x , y, RT ] = finalQForm( myimgfile, window, windowRect, screenNumber, clickRects, waitBetweenSlides )
%IMAGENMOUSECLICKS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 6
    waitBetweenSlides = .3;
end

try
        commandwindow;
        pause(.5);
        
        ima=imread(myimgfile{1}, 'tiff');
       
        
        %ima=imread(myimgfile, 'tiff');
        startSlideTime = GetSecs;
        % Screen('PutImage', window, 255, windowRect); % put image on screen
        Screen('PutImage', window, ima, windowRect);
        Screen('Flip', window, 0, 1); % now visible on screen
        
        pause(waitBetweenSlides);
        
        for jj = 1:3
            startSessionTime = GetSecs;
            
            ima=imread(myimgfile{jj}, 'tiff');
            Screen('PutImage', window, ima, windowRect); % put image on screen
            Screen('Flip', window, 0, 1); % now visible on screen
            
            ShowCursor('Arrow');
            while true
                [~,x(jj), y(jj),~] = GetClicks(screenNumber);
                if pointInRect(x(jj), y(jj), clickRects(jj, :))
                    RT(jj) = GetSecs-startSessionTime;
                    break;
                end
            end
            HideCursor();
            pause(waitBetweenSlides);
        end
    catch
        %this "catch" section executes in case of an error in the "try" section
        %above.  Importantly, it closes the onscreen window if its open.
        rethrow(lasterror);
    end %try..catch..
 %wait for 20 secs   


end

