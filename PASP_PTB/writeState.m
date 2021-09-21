%writes state to file state.txt. Discards previuos contents of file
% it takes less time to open the fid in advance, and write to it each time, fseek to beginning,
% and close at the end, but that leaves the previous contents if longer.
% currently time is less than 0.002 s, so good enough.
function writeState(state)
    fid = fopen('state.txt','w');
    fwrite(fid,state);
    fclose(fid);
end