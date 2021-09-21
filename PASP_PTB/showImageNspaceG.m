function output = showImageNspaceG( mode, myimgfile, window, windowRect, subject )
%SHOWIMAGENSPACE show the image and contineous when the space key is pressed
%this code adds the possibility to have the images displayed according to
%the gender of the participant. useful for instructions. in case of
%different letters :) it shows the female option.
global one two;

commandwindow;
try
    ima=imread(sprintf('%s_%s',myimgfile,subject(1)), 'png');
catch
    ima=imread(sprintf('%s_w',myimgfile), 'png');
end
Screen('PutImage', window, ima, windowRect); % put image on screen
Screen('Flip', window, 0, 2); % now visible on screen
if contains(mode,'NL')
    waitForSpaceKey();
else
    startTime = GetSecs;
    while (GetSecs-startTime<5)
        %disp('waiting');
        pause(0.1);
    end
    one = false;
    two = false;
    while ~(one||two)&&(GetSecs-startTime<20)
        %disp('detecting');
        pause(0.1);
    end
    one= false;
    two = false;
end
pause(0.07); % i added this to try to contain your farouche!
end

