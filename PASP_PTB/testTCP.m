global one two;
%% open tcp connection
clear t;
id ='MATLAB:serial:instrcb:invalidcallback';
warning('off',id)
id2 ='instrument:fscanf:unsuccessfulRead';
warning('off',id2)
t = tcpip('localhost',55555);
t.Terminator = 'CR';
t.BytesAvailableFcnCount = 7;
t.BytesAvailableFcn = @gotTCP;
t.Timeout=0.3;
t.BytesAvailableFcnMode = 'byte';
fopen(t);
%% weak command
% Command = 0 0 in meta data so add to each command
tosend = cast([0 0 0 6 0 0],'int8');% weak + 0 0 = 6 bytes
command = unicode2native('weak');
tosend = [tosend command];   
fwrite(t,tosend);
%% strong command
tosend = cast([0 0 0 8 0 0],'int8');% strong + 0 0 = 8 bytes
command = unicode2native('strong');
tosend = [tosend command];   
fwrite(t,tosend);
%% state command
tosend = cast([0 0 0 16 0 0],'int8'); %state monetary + 0 0 = 16 bytes
command = unicode2native('state monetary');
tosend = [tosend command];   
fwrite(t,tosend);
%% test createSTMMessage
tosend = createSTMMessage('start');
fwrite(t,tosend);
%% display
fprintf ('one is %s and two is %s',one,two);
%% while 
counter = 0;
while (counter<100)
    while (one|| two ) 
       if one&& two 
           fprintf('one and two\n'); 
       elseif xor(one,two)
           fprintf('one or two\n');
       end

       counter = counter+1;
       fprintf('counter is: %d',counter);
    end
pause(0.5);
end
%% close connection
tosend = createSTMMessage('stop');
fwrite(t,tosend);
fclose(t);
delete(t);
clear t;