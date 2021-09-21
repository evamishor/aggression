clickRect = [minX, minY, maxX, maxY];

path(path, finalQDirectory);

imagesInFolder = dir(finalQDirectory);
QImage{1} = {imagesInFolder(3:5,1).name};
QImage{2} = {imagesInFolder(6:8,1).name};

minY1 = (266/900)*(windowRect(4)-windowRect(2));
maxY1 = (316/900)*(windowRect(4)-windowRect(2));
minY2 = (531/900)*(windowRect(4)-windowRect(2));
maxY2 = (581/900)*(windowRect(4)-windowRect(2));
minY3 = (786/900)*(windowRect(4)-windowRect(2));
maxY3 = (836/900)*(windowRect(4)-windowRect(2));

clickRect1 = [minX, minY1, maxX, maxY1];
clickRect2 = [minX, minY2, maxX, maxY2];
clickRect3 = [minX, minY3, maxX, maxY3];

clickRects = [clickRect1; clickRect2; clickRect3];

X1 = []; X2 = []; X3 = [];
RT1 = []; RT2 = []; RT3 = [];

for ii = 1:2
    [x, y, RT] = finalQForm(QImage{ii}, window, windowRect, screenNumber, clickRects, 0.2);  
    X1 = [X1 x(1)]; X2 = [X2 x(2)]; X3 = [X3 x(3)];
    RT1 = [RT1 RT(1)]; RT2 = [RT2 RT(2)]; RT3 = [RT3 RT(3)];
end

fileName = sprintf('/%s_FinalQ.csv', subj); 

fileTitle = {'subjectID', 'SlideNumber', 'X1',...
    'X2', 'X3', 'RT1', 'RT2', 'RT3'};

fileID = fopen([baseDir subj fileName], 'w');

fprintf(fileID, '%s,%s,%s,%s,%s,%s,%s,%s\n', fileTitle{1, :});


formatSpec = '%s,%d,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f\n';

assert(length(X1) == 2);
for ii = 1:length(X1)
    finalQMat{ii, 1} = subj;
    finalQMat{ii, 2} = ii;
    finalQMat{ii, 3} = X1(ii);
    finalQMat{ii, 4} = X2(ii);
    finalQMat{ii, 5} = X3(ii);
    finalQMat{ii, 6} = RT1(ii);
    finalQMat{ii, 7} = RT2(ii);
    finalQMat{ii, 8} = RT3(ii);
end
[nrows,ncols] = size(finalQMat);
for row = 1:nrows
    fprintf(fileID,formatSpec, finalQMat{row,:});
end

fclose(fileID);

rmpath(finalQDirectory);