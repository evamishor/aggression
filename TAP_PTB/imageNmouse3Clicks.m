function [ x , y, RT ] = imageNmouse3Clicks( myimgfile, window, windowRect, screenNumber, clickRects, texts, ii, waitBetweenSmells )
%IMAGENMOUSECLICKS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 8
    waitBetweenSmells = 20;
end

try
        commandwindow;
        pause(.5);
        
        ima=imread(myimgfile{1}, 'tiff');
       
        
        %ima=imread(myimgfile, 'tiff');
        startSlideTime = GetSecs;
        % Screen('PutImage', window, 255, windowRect); % put image on screen
        Screen('PutImage', window, ima, windowRect);
        Screen('TextSize', window, 50);
        Screen('DrawText', window, texts{1}, windowRect(3) * .47, windowRect(4)*.05 );%upper center
        Screen('DrawText', window, texts{2}, windowRect(3) * .83, windowRect(4)*.05 );%upper right
        Screen('Flip', window, 0, 1); % now visible on screen
        if ii>1
            pause(waitBetweenSmells);
        end
        %playAudio('stimuli/prepare_to_sniff_cut.aiff');
        %playAudio('stimuli/beep2secs.aiff');
        
        for jj = 1:3
            startSessionTime = GetSecs;
            
            ima=imread(myimgfile{jj+1}, 'tiff');
            Screen('PutImage', window, ima, windowRect); % put image on screen
            Screen('Flip', window, 0, 1); % now visible on screen
            
            Screen('TextSize', window, 50);
            Screen('DrawText', window, texts{1}, windowRect(3) * .47, windowRect(4)*.05 );%upper center
            Screen('DrawText', window, texts{2}, windowRect(3) * .83, windowRect(4)*.05 );%upper right
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
            pause(.2);
        end
    catch
        %this "catch" section executes in case of an error in the "try" section
        %above.  Importantly, it closes the onscreen window if its open.
        rethrow(lasterror);
    end %try..catch..
 %wait for 20 secs   


end

