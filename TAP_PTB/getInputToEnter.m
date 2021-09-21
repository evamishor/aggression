function [ inputVal, respTime, Ponder ] = getInputToEnter(window, windowRect, ...
                                errorSlideName, insertAmountSlideName, textPos)
%GETINPUTTOENTER Summary of this function goes here
%   Detailed explanation goes here
%commandwindow;

errorSlide = imread(errorSlideName, 'tiff');
insertAmountSlide = imread(insertAmountSlideName, 'tiff');

Starttime=GetSecs;% set time 0 (for reaction time)
inputChars = '';
while KbCheck; end
while true
    [secs, keyCode, ~] = KbWait;
    
    response = KbName(keyCode); % get the key
    respTime = secs - Starttime; % calculate the response time
    while KbCheck; end

    if strcmp(response, 'Return')
        if strcmp(inputChars, '')
            continue;
        end
        inputVal = str2num(inputChars);
        if inputVal >= 0 && inputVal <=30
            break
        else 
            Screen('PutImage', window, errorSlide, windowRect); % put image on screen
            Screen('Flip', window, 0, 1); % now visible on screen
            inputChars = '';
            %Starttime=GetSecs;
            continue;
        end
    end
    Screen('PutImage', window, insertAmountSlide, windowRect); % put image on screen
    Screen('DrawText', window, textPos, windowRect(3) * .48, windowRect(4)*.05 );
    Screen('Flip', window, 0, 1); % now visible on screen
    
    if strcmp(response, 'DELETE') || strcmp(response, 'BackSpace')
        inputChars = inputChars(1:end-1);
    elseif response(1) >= '0' && response(1) <= '9'
        inputChars = [inputChars response(1)];
    end
    %[inputChars]
    Screen('DrawText', window, inputChars, windowRect(3) * .48, windowRect(4)*.7 );
    Screen('Flip', window,0 , 0); % now visible on screen
end
while KbCheck; end
%%
switch (inputVal)
    case {1 2 3 4 5 6 7 8 9 10 30}
        Ponder = rand() * 0.5 + 2;
    case {11 12 13 14 15 16 17 18 19 20}
        Ponder = rand() * 0.5 + 2.7;
    case {21 22 23 24 25}
        Ponder = rand() * 3 + 4;
    case  {26 27 28 29} 
        Ponder = rand() * 6 + 7;
end

end
