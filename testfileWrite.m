%script test file
states = {'monetary','revenge'};
fid = fopen('state.txt','w');
for i = 1:10
    tic
    
    fwrite(fid,states{(mod(i,2)+1)});
    fseek(fid,0,-1);
    
    toc
    pause(3);
end
fclose(fid);