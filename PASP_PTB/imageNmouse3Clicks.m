function [ x , y, RT ] = imageNmouse3Clicks( myimgfile, window, windowRect, screenNumber, clickRects, texts, ii, waitBetweenSmells,event,olfactometerIP,prepare2sniff, xPos,yPos )
%IMAGENMOUSECLICKS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 8
    waitBetweenSmells = 20;
end

try
        commandwindow;
        pause(.5);
        
        ima=imread(myimgfile{1}, 'tiff');
       
        %%olfactometer
   
    
   
        %ima=imread(myimgfile, 'tiff');
        startSlideTime = GetSecs;
        % Screen('PutImage', window, 255, windowRect); % put image on screen
        Screen('PutImage', window, ima, windowRect);
        Screen('TextSize', window, 50);
        %Screen('DrawText', window, texts{1}, windowRect(3) * .47, windowRect(4)*.05 );%upper center
        Screen('DrawText', window, texts{2}, windowRect(3) * .83, windowRect(4)*.05 );%upper right
        Screen('Flip', window, 0, 1); % now visible on screen
        if ii>1
            pause(waitBetweenSmells);
        end
        %% odors
        [time, echo] = olfactometer_web_command(event, olfactometerIP);
        showImageNwait( prepare2sniff, window, windowRect, 3) ;%cross image
        %playAudio('prepare_to_sniff.aiff');
        
        [time, echo] = olfactometer_web_command('shoot', olfactometerIP);
        for jj=1:2 %count, 1...2
            showImageTextNwait( prepare2sniff, window, windowRect, num2str(jj), 150, xPos-30, yPos-100, 1)
        end
        %playAudio('beep2secs.aiff');
        
        [time, echo] = olfactometer_web_command('Abort', olfactometerIP);
        
        %% 
        for jj = 1:3
            startSessionTime = GetSecs;
            
            ima=imread(myimgfile{jj+1}, 'tiff');
            Screen('PutImage', window, ima, windowRect); % put image on screen
            Screen('Flip', window, 0, 1); % now visible on screen
            
            Screen('TextSize', window, 50);
            %Screen('DrawText', window, texts{1}, windowRect(3) * .47, windowRect(4)*.05 );%upper center
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

