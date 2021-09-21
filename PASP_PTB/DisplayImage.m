function DisplayImage(win, image, windowRect, displayingLength)
%% DisplayImage
%%   This function displayed on the given psychtoolbox-window the given
%%   image, within the given window-rect. The image is displayed for the
%%   given-length
fprintf('Image is displayed in time %3.2f\n', toc);
Screen('PutImage', win, image, windowRect); % put image on screen
Screen('Flip', win, 0, 1); % now visible on screen
pause(displayingLength); % wait for given length
fprintf('Image is ended in time %3.2f\n', toc);
end
