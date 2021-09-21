%% script PSAP_Session

%% Session init
% Runs one PSAP session of mometary and revenge state
sessionLength = 60*8;%120;%4*60; should be 8 minutes
waitTime = 3;
state = 'none';
one = false;
two = false;
stepsize = 20;
times = 0;
earning = 1; %how much money you earn with every full counter
provocation_deduction = 3; % how much money is deducted in the provocation
monetary_idx=0;
time_of_last_shoot = -Inf;

%% Start sessions
while GetSecs<startTime+4 %missing first TR's
    WaitSecs(0.1);
end

while GetSecs < startTime+sessionLength
    %% Single Session
    fprintf('PSAP iteration %d\n', monetary_idx);
    Screen('TextColor', window, green); %back to default color
    % If we just finished a session, log the end time
    if ii>1
        records{ii-1,5} = endtime;
    end
    state = 'cross';
    showImageNwait( CrossImage, window, windowRect, waitTime);
    state = 'none';
    centerize_amount = 50*(length(num2str(amount)));%-1); %centralize the amount
    
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    EscPressError
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    
    %%%%signal to lab chart%%%%
%    TriggerLabChart('monetary',olfactometerIP);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('Flip',window);
    Screen('TextSize', window, textSize);
    Screen('DrawText', window, num2str(amount), position(3)-centerize_amount,position(2)+300);
    Screen('FrameRect', window, [0 0 0], baseRect ); %frame for square
    Screen('FrameRect', window, [0 0 0], baseRect2 ); %frame for square 2
    Screen('Flip',window);
    
    sessionTime = GetSecs; %when we start this session
    
    if (~hardware)
        [secs,keyCode,deltaSecs] = KbWait([],[],GetSecs+4);
    else
        keyCode = 12;%'Clear', or in other words, not relevant.
    end
    
    %wait_for_provocation=State.revenge.deadline+rand*(State.monetary.deadline-State.revenge.deadline-1.5);
    
    %% Sessions (TRIALS)
    while one || two || GetSecs-sessionTime<4 || KbCheck
        %% Odor Shooting
%         if (GetSecs - time_of_last_shoot) > 20
%             time_of_last_shoot = GetSecs;
%             odor_idx = odor_idx+1;
%             if strcmp(odor_event{mod(odor_idx,2)+1},'control1')
%                 event = 'event3';
%             elseif strcmp(odor_event{mod(odor_idx,2)+1},'control2')
%                 event = 'event4';
%             elseif strcmp(odor_event{mod(odor_idx,2)+1},'Hex1')
%                 event = 'event1';
%             elseif strcmp(odor_event{mod(odor_idx,2)+1},'Hex2')
%                 event = 'event2';
%             end
%             %[time, echo] = olfactometer_web_command(event, olfactometerIP);
%             %[time, echo] = olfactometer_web_command('shoot', olfactometerIP);
%         end
        %% monetray
        if one && two && (strcmp(state,'none') || strcmp(state,'monetary')) ||(one &&two && (strcmp(state,'revenge') && GetSecs-sessionTime<2)) || strcmp(KbName(keyCode),'1!') %squeeze both
            %%
            %fprintf('entering monetary case...\n');
            counter=counter+1;
            Screen('TextSize', window, textSize);
            Screen('DrawText', window, num2str(amount), position(3)-centerize_amount,position(2)+300,green);
            Screen('FrameRect', window, [0 0 0], baseRect ); %frame for square
            Screen('FrameRect', window, [0 0 0], baseRect2 ); %frame for square2
            Screen('FillRect', window, green, baseRect+[0 frameSize+200-counter*stepsize 0 0], green); %fill dependent on the press;
            Screen('Flip',window);
            if counter>=full %start over when counter is full
                counter=0;
                amount=amount+earning;
                times = times+1;
                if (times>2)
                    break
                end
            end
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            EscPressError
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            
            %% provocation!
            if sum(monetary_idx==provocation_vec) && ((GetSecs - sessionTime) > wait_for_provocation(find(monetary_idx==provocation_vec)))
                wait_for_provocation(monetary_idx==provocation_vec) = inf; %only provoke once per session
                
                %%%%signal to lab chart%%%%
                %TriggerLabChart('provocation',olfactometerIP);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                ProvocationTime = GetSecs;
                %Provocation
                amount = amount - provocation_deduction;
                Screen('TextSize', window, textSize);
                Screen('DrawText', window, num2str(amount), position(3)-centerize_amount,position(2)+300);
                Screen('FrameRect', window, [0 0 0] , baseRect ); %frame for square
                Screen('FrameRect', window, [0 0 0], baseRect2 ); %frame for square2
                Screen('FillRect', window, RedColor, baseRect+[0 frameSize+200-counter*stepsize 0 0] ); %fill dependent on the press;
                Screen('DrawText', window, num2str(-provocation_deduction), position(3)-centerize_amount,position(2)+400,RedColor);%draw provocation
                Screen('Flip',window);
                pause(1);
                records(ii,:) = WriteRecoeds(experimentStart,ProvocationTime,run_num, amount, 'provocation');
                records{ii,5}= ProvocationTime+1-experimentStart;
                ii=ii+1;
            end
            %%
            state = 'monetary';
            
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            EscPressError
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            
            if GetSecs > sessionTime+State.(state).deadline
                fprintf('breaking one and two\n');
                break
            end
            
            %% revenge!  one ball
        elseif xor(one,two) && (strcmp(state,'none') || strcmp(state,'revenge')) || (xor(one,two) &&strcmp(state,'monetary') && GetSecs-sessionTime<2) || strcmp(KbName(keyCode),'2@')%only one, not both
            %             if (strcmp(state,'none') || strcmp(state,'monetary'))
            %                 %%%%signal to lab chart%%%%
            %                 TriggerLabChart('revenge',olfactometerIP);
            %                 %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             end
            
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            EscPressError
            %*%*%*%*%*%*%%*%*%*%*%*%*%
            %fprintf('entering revenge case...\n');
            counter=counter+2;
            Screen('TextSize', window, textSize);
            Screen('DrawText', window, num2str(amount), position(3)-centerize_amount,position(2)+300); %draw amount
            Screen('FrameRect', window, [0 0 0], baseRect ); %frame for square
            Screen('FrameRect', window, [0 0 0], baseRect2 ); %frame for square 2
            Screen('FillRect', window, [0 0 0], baseRect2+[0 frameSize+200-counter*stepsize 0 0] ); %fill dependent on the press;
            Screen('Flip',window);
            
            state = 'revenge';
            
            if counter>=full %start over when counter is full
                Screen('DrawText', window, num2str(-provocation_deduction), baseRect2(1)+10 ,position(2)+100,black); %draw subtraction
                Screen('TextSize', window, textSize);
                Screen('DrawText', window, num2str(amount), position(3)-centerize_amount,position(2)+300, green); %draw amount
                Screen('FrameRect', window, [0 0 0], baseRect ); %frame for square
                Screen('FrameRect', window, [0 0 0], baseRect2 ); %frame for square 2
                Screen('FillRect', window, [0 0 0], baseRect2+[0 frameSize+200-counter*stepsize 0 0] ); %fill dependent on the press;
                Screen('Flip',window);
                pause(0.2);
                counter=0;
                %%%%signal to lab chart%%%%
                %TriggerLabChart('revenge',olfactometerIP);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                break;
            end
            if GetSecs > sessionTime+State.(state).deadline
                fprintf('breaking one or two %f\n',GetSecs-sessionTime);
                break
            end
            
            
        end
        if GetSecs > sessionTime+State.(state).deadline
            fprintf('breaking external %f\n',GetSecs-sessionTime);
            break
        end
        
        pause(State.(state).steptime);
        times = 0;
    end
    
    %reset
    monetary_idx =  monetary_idx+1;
    counter=0;
    % endtime = TriggerLabChart('end_event',olfactometerIP,experimentStart);
    fprintf('state = %s\n',state);
    records(ii,:) = WriteRecoeds(experimentStart,sessionTime,run_num, amount, state);
    ii=ii+1;
    state = 'none';
    one = false;
    two = false;
    
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    EscPressError
    %*%*%*%*%*%*%%*%*%*%*%*%*%
    
end

save ('records.mat', 'records');

