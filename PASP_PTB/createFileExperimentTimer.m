function t = createFileExperimentTimer(fidToWrite,fidToRead)
% CREATEARDUINOTIMER function that creates a connection to an arduino at
% com port 'com' of type 'type', and sets up a timer to read from it at
% 20HZ, plots and saves the data and detects squeeze and release

% Date: March 18, 2019
% Version: 1.0
% Author: Danielle Honigstein and Eva Mishor, Noam Sobel's Olfaction Lab, Weizmann
% Institute of Science
% Contact: eva.mishor@weizmann.ac.il, danielle.honigstein@weizmann.ac.il

% If you find this code useful please credit us in any papers/software
% published


global one two; %squeeze in first/second sensor

interval = 0.05;%20 Hz

t = timer;
%user data - stuff for reading, displaying and writing
userdata = t.UserData;
%userdata.arduino = arduino(com,type);%arduino connection
userdata.fid = fidToWrite;%file to write to
userdata.fidToRead = fidToRead;%file to read from
userdata.figure = figure();%figure for plot
userdata.maxCount = 10;%number of datapoints to record before plotting and detecting
userdata.time = datetime(zeros(userdata.maxCount,1),0,0);%time of points
userdata.volt = zeros(userdata.maxCount,2);%voltage acquired from both sensors
userdata.counter = 1;%counter in time and voltage array
%experiment parameters
userdata.recording = false;
userdata.startTime = 0;
userdata.data = [];
t.UserData = userdata;
hold on;%for plotting

%timer functions
t.TimerFcn = @timerGetData;%every tick
t.StopFcn = @timerStop;%when stopped
t.Period = interval;
t.TasksToExecute = Inf;%run until stopped with stop(timer)
t.ExecutionMode = 'fixedSpacing';%have the timing be excact regardless of how long the tick function takes

%initialize globals
one = false;
two = false;

end

function timerGetData(mTimer,~)
% TIMERGETDATA is called every timer tick. reads data from arduino, plots
% and detects squeeze and release
            try 
            userdata = mTimer.UserData;
            %v = readVoltage(userdata.arduino,'A0');
            %v2 = readVoltage(userdata.arduino,'A1');
            tline = fgetl(userdata.fidToRead);
            data = split(tline,',');
            v = str2double(data{2});
            v2 = str2double(data{3});
            %time = [time curr];
            %voltage = [voltage v];
            userdata.time(userdata.counter) = datetime('now','Format','HH:mm:ss.SSS');
            userdata.volt(userdata.counter,:) = [v v2];
            userdata.counter = userdata.counter +1;
            if (userdata.counter> userdata.maxCount) %every maxCount values
                PSAPSqueezeRelease(userdata.time,userdata.volt(:,1),userdata.volt(:,2),userdata.fid);
                %plot figure
                figure(userdata.figure);
                h = plot(userdata.time,userdata.volt,'-');
                set(h,{'color'},{[0.5 0.5 0.5]; [1 0 0]});
                %reset counter
                userdata.counter = 1;
                
                % record data if necessary
                
            end
            mTimer.UserData = userdata;
            catch ME %if error occurs during timer, matlab freaks and doesn't detect arduino, so important to catch errors
                fprintf('ERROR: %s. %s. function: %s. line %d\n',ME.identifier, ME.message, ME.stack(1).name, ME.stack(1).line);
                stop(mTimer);
            end
            

end

function timerStop(mTimer,~)
% TIMERSTOP is called when timer stops. closes the file and deletes the
% timer.
clear mTimer.arduino;
userdata = mTimer.UserData;
fclose(userdata.fid);
fclose(userdata.fidToRead);
delete(mTimer);
end
