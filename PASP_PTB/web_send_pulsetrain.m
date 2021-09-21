function [time, echo] = web_send_pulsetrain(IP,n)

    for ii = [1:n]
        [time(ii), echo(ii)] = olfactometer_web_command('StartTone', IP);
        pause(.005)
        [time(ii), echo(ii)] = olfactometer_web_command('EndTone', IP);
        pause(.005)
    end

end