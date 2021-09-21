function gotTCP(obj,event)
global one two subjectID state leftOK rightOK;
%disp(event.Data);
%read data
command = fscanf(obj);
%parse
command = command(7:end);
command = strtrim(command);

%if subject ID
if contains(command,'SID')
    subjectID = command(end-3:end);% 4 digits of subject Id
end
%result of squeezes
if strcmp(state,'lightL') && contains(command,'OK')
        leftOK = true;
end
if strcmp(state,'lightR') && contains(command,'OK')
        rightOK = true;
end
%update globals
if (contains(command,'s1')) % squeeze 1
    one=true;
end
if (contains(command,'s2')) % squeeze 2
    two = true;
end
if (contains(command,'r1')) % release 1
    one = false;
end
if (contains(command,'r2')) % release 2
    two = false;
end
if length(command)>1
    fprintf('command is %s. one = %s, two = %s\n',command,mat2str(one),mat2str(two));
end



