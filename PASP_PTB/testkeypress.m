%script testkeypress
FlushEvents
ListenChar
counter = 0;
while (counter<10)
    fprintf('hi! %d\n',counter);
    waitForSecs(2)
    if CharAvail()
        break
    end
    counter = counter+1;
end

function waitForSecs(secs)
    start = GetSecs;
    while(GetSecs-start<secs)
        pause(0.1)
    end
    end