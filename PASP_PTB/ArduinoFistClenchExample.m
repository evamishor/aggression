%script ArduinoAggressionExample
% shows an example of using the Arduino timer in order to detect squeeze in
% first sensor, second sensor or both.

% INSTRUCTIONS:
% Before running for the first time (Windows): 
% 1. download and install the support package for arduino from
% https://www.mathworks.com/hardware-support/arduino-matlab.html. No servers
% are necessary.
% 2. Check which port the sensors are connected to using the device
% manager->Ports(COM & LPT)->USB Serial Port
% 3. Change 'COM7' port below to your port.

% Date: March 18, 2019
% Version: 1.0
% Author: Danielle Honigstein and Eva Mishor, Noam Sobel's Olfaction Lab, Weizmann
% Institute of Science
% Contact: eva.mishor@weizmann.ac.il, danielle.honigstein@weizmann.ac.il

% If you find this code useful please credit us in any papers/software
% published


%% initialize
close all; %close open windows if any
global ONE TWO SQUEEZE_THRESH RELEASE_THRESH;
%threshold to detect squeeze and release - change this as necessary. note
%that the thresholds are on the slope of the voltage and not on the voltage
%itself as the baseline changes alot.
SQUEEZE_THRESH = 0.5; 
RELEASE_THRESH = -0.5;
at = createArduinoTimer('/dev/cu.usbserial-14P02957','nano3'); 
start(at);
%in this example we run for a fixed time
startTime = now;
timeToRun = 30;%seconds

mult = 100000;%convert timestamp from days to seconds
%% detect squeeze or release

while ((now-startTime)*mult)<timeToRun
    myWait(1);%poll every second
    % disp(((now-startTime)*mult)); % how much time passed
    if (ONE && TWO)
        disp('both');
        %here react to squeeze of both

    else
        if ONE
            disp('one');
            %here react to squeeze of one etc.
        else
            if TWO
                disp('two');
            else
                disp('none');
            end
        end
    end
end

%cleanup
stop(at);
clear at;




function myWait(n)
% MYWAIT function to wait n seconds in a non-blocking manner. matlab pause
% stops execution of all threads. this delays the execution of this one and
% allows other threads to work in parallel, if a bit slower.
    t = tic();
    while toc(t) < n
        pause(0.1);
    end
end
