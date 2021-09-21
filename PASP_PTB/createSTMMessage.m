function tosend = createSTMMessage(command)
commandLength = length(command) +2;
tosend = cast([0 0 0 commandLength 0 0],'int8');% strong + 0 0 = 8 bytes
command = unicode2native(command);
tosend = [tosend command];   
