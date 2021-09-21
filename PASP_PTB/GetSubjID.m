function [subjID] = GetSubjID(filename)
%This function gets a full path file 
%   Detailed explanation goes here


 namename = strsplit(filename,'/');%first split according to path to filename
    namename1 = namename{8};
    finalname = strsplit(namename1,'.'); %second split
    subjID = finalname{1};
end

