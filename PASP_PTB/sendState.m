function sendState(hardware,t,state)
if (hardware)
    tosend = createSTMMessage(['state ' state]);
    fwrite(t,tosend,'async');
end