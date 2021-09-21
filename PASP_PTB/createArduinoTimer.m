function t = createArduinoTimer(com,type)
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

interval = 0.01;%100 Hz

t = timer;
%user data - stuff for reading, displaying and writing
userdata = t.UserData;
userdata.arduino = arduino(com,type);%arduino connection
userdata.fid = fopen(['test' datestr(now,'dd-mm-yy-HH-MM-SS') '.csv'],'a');%file that all data is saved to
userdata.figure = figure();%figure for plot
userdata.maxCount = 20;%number of datapoints to record before plotting and detecting
userdata.time = datetime(zeros(userdata.maxCount,1),0,0);%time of points
userdata.volt = zeros(userdata.maxCount,2);%voltage acquired from both sensors
userdata.counter = 1;%counter in time and voltage array
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
            global one two sq_thresh rel_thresh;
            try 
            v = readVoltage(mTimer.UserData.arduino,'A0');
            v2 = readVoltage(mTimer.UserData.arduino,'A1');
            %time = [time curr];
            %voltage = [voltage v];
            userdata = mTimer.UserData;
            userdata.time(userdata.counter) = datetime('now','Format','HH:mm:ss.SSS');
            userdata.volt(userdata.counter,:) = [v v2];
            userdata.counter = userdata.counter +1;
            if (userdata.counter> userdata.maxCount) %every maxCount values
                %save to file
                fprintf(userdata.fid,'%.10f,%.5f,%.5f\n',[exceltime(userdata.time),userdata.volt]');
                %plot figure
                figure(userdata.figure);
                h = plot(userdata.time,userdata.volt,'-');
                set(h,{'color'},{[0.5 0.5 0.5]; [1 0 0]});
                %reset counter
                userdata.counter = 1;
                
                %detect squeeze and release
                numSensors = 2;
                indicators = [one,two];
                %becasue the baseline changes the detection is on the diff,
                %so it depends on the speed of squeeze/release
                for i=1:numSensors
                    %squeeze
                    dataVector = diff( userdata.volt(:,i));
                    binaryVector = dataVector>sq_thresh;%vector for squeeze
                    if (~isempty(find(binaryVector,1)))
                        indicators(i) = true;
                    end
                    %release
                    binaryVector = dataVector<rel_thresh;
                    if (~isempty(find(binaryVector,1)))
                        indicators(i) = false;
                    end    
                end
                one = indicators(1);
                two = indicators(2);
            end
            catch ME %if error occurs during timer, matlab freaks and doesn't detect arduino, so important to catch errors
                fprintf('ERROR: %s. %s',ME.identifier, ME.message);
            end
            

end

function timerStop(mTimer,~)
% TIMERSTOP is called when timer stops. closes the file and deletes the
% timer.
userdata = mTimer.UserData;
fclose(userdata.fid);
delete(mTimer);
end
