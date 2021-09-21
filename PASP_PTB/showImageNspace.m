function output = showImageNspace( myimgfile, window, windowRect )
%SHOWIMAGENSPACE show the image and contineou when the space key is pressed
try
    commandwindow;
    
    ima=imread(myimgfile);
    
    Screen('PutImage', window, ima, windowRect); % put image on screen
    Screen('Flip', window, 0, 2); % now visible on screen
    %waitForSpaceKey();
    pause(0.7); % i added this to try to contain your farouche!
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    rethrow(lasterror);
end %try..catch..

end

