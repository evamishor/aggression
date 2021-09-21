function isKeyboardPressed = DisplayMovie(win, movieName, waitUntilEventFunction, olfactometerIP)
%% DisplayMovie
%%   This function displayes on the given psychtoolbox-window the given
%%   movie. The movie will start once the waitUntilEventFunction returned,
%%   with a max-time of 10 seconds. If olfactometerIP is not empty, a 
%%   "StartTone" and "EndTone" messages will be sent to the olfactometer 
%%   when the movie will start and end.
%%   The displaying of the movie will stop if any key is pressed or after
%%   12 seconds.
tic
% Open movie file:
movie = Screen('OpenMovie', win, movieName);

if isempty(waitUntilEventFunction)
    waitUntilEventFunction = @(timeout) true;
end
% Start playback engine:
waitUntilEventFunction(10); % wait for 10 seconds or TR before displaying movie
fprintf('Playing movie in time %3.2f for movie %s\n', toc, movieName);
Screen('PlayMovie', movie, 1);
startTime = tic;

% notify Olfactometer
if ~isempty(olfactometerIP)
    fprintf('Notifying olfactometer on starting of movie in time %3.2f\n', toc);
    olfactometer_web_command('StartTone', olfactometerIP);
    fprintf('End notifying olfactometer on starting of movie in time %3.2f\n', toc);
end

% Playback loop: Runs until end of movie or keypress:
tex = 1;
maxMovieDuration = inf;
while ~KbCheck && toc(startTime) <= maxMovieDuration
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);
    
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    
    % Update display:
    Screen('Flip', win);
    
    % Release texture:
    Screen('Close', tex);
end

if tex > 0 && toc(startTime) <= maxMovieDuration
    isKeyboardPressed = true;
else
    
    % Stop playback:
    Screen('PlayMovie', movie, 0);
    fprintf('Stopping movie in time %3.2f for movie %s\n', toc, movieName);
    
    % Close movie:
    Screen('CloseMovie', movie);
    isKeyboardPressed = false;
end
% notify Olfactometer
if ~isempty(olfactometerIP)
    olfactometer_web_command('EndTone', olfactometerIP);
end
end