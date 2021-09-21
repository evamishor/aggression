function s = createInputSession(flag)
a = daq.getDevices();
%deviceName = 'Dev4';
deviceName = a.ID;
if nargin <1
    flag = 'one';
end
if strcmpi(flag,'none')
    s= null;
    return;
end
s = daq.createSession('ni');
if strcmpi(flag,'one')|| strcmpi(flag,'both')
    %one sensor
    addAnalogInputChannel(s,deviceName,0,'Voltage');%ai0
end
if strcmpi(flag,'both')
    addAnalogInputChannel(s,deviceName,1,'Voltage');%ai1
end
end