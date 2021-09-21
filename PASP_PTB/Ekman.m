clickRect = [minX, minY, maxX, maxY];

path(path, ekmanDirectory);
Ekman_order_vec = randperm(17);

imagesInFolder = dir(ekmanDirectory);
EkmanImages = {imagesInFolder(4:end,1).name};
EkmanImagesExample = ('Slide01.tiff');

ShowCursor('Arrow');
[x, y, RT] = imageNmouseClicks(EkmanImagesExample, window, windowRect, screenNumber, clickRect);
Xs = [x]; Ys = [y]; RTs = [RT];
for ii=1:17
    %Show image
    myimgfile=EkmanImages{Ekman_order_vec(ii)};
    [x, y, RT] = imageNmouseClicks(myimgfile, window, windowRect, screenNumber, clickRect);
    Xs = [Xs x]; Ys = [Ys y]; RTs = [RTs RT];
end
%%
% differentiate ekman 1 and 2
%time stamp in the start 
EkmanNumber = EkmanNumber +1;
fileName = sprintf('/%s_Ekman%d.csv', subj, EkmanNumber); 

fileTitle = {'subjectID', 'TrialNumber', 'StimuliOrder', 'X', 'RT'};
fileID = fopen([baseDir subj fileName], 'w');
fprintf(fileID, '%s,%s,%s,%s,%s\n', fileTitle{1, :});


formatSpec = '%s,%d,%d,%2.4f,%2.4f\n';
Ekman_order_vec = [0 Ekman_order_vec];
assert(length(Xs) == 18);

for ii = 1:length(Xs)
    EkmanMat{ii, 1} = subj;
    EkmanMat{ii, 2} = ii;
    EkmanMat{ii, 3} = Ekman_order_vec(ii);
    EkmanMat{ii, 4} = Xs(ii);
    EkmanMat{ii, 5} = RTs(ii);
end
[nrows,ncols] = size(EkmanMat);
for row = 1:nrows
    fprintf(fileID, formatSpec, EkmanMat{row,:});
end

fclose(fileID);

Ekman_order_vec(1) = [];
rmpath(ekmanDirectory);