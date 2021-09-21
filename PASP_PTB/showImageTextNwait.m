function output = showImageTextNwait( myimgfile, window, windowRect, text, textSize, xPos, yPos, waitTime)
%SHOWIMAGENSPACE Summary of this function goes here
%   Detailed explanation goes here
%tic
try
    commandwindow;
    %fprintf('commandwindow '); toc
    
    ima=imread(myimgfile, 'png');
    %fprintf('imread ');toc
    Screen('PutImage', window, ima, windowRect); % put image on screen
    %fprintf('PutImage ');toc
    Screen('TextSize', window, textSize);
    %fprintf('TextSize ');toc
    Screen('DrawText', window, text, xPos, yPos );
    %fprintf('DrawText ');toc
    Screen('Flip', window,0,0,2); % now visible on screen
    %fprintf('Flip ');toc
    startTime = GetSecs;
    while GetSecs-startTime<waitTime
        pause(0.1); % i added this to try to contain your farouche!
    end
    %fprintf('pause ');toc
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    rethrow(lasterror);
end %try..catch..

end

