function detectSqueezeRelease(src,event,fid)
%% variables
time = event.TimeStamps;
volt1 = event.Data(:,1);
volt2 = event.Data(:,2);
PSAPSqueezeRelease(time, volt1, volt2,fid);
