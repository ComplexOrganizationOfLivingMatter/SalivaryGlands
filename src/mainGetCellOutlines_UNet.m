%get cell outlines from segmented .tif images -> training set for u-net 3D

clear all; close all; addpath(genpath('lib'))

%1. Load segmented glands
pathSegmentedGlands = dir('..\Images\**\labelledImage\*.tif');

parpool(10)
parfor nGland = 1:size(pathSegmentedGlands,1)
    disp(fullfile(pathSegmentedGlands(nGland).folder,pathSegmentedGlands(nGland).name))
    folder2save = strrep(pathSegmentedGlands(nGland).folder,'labelledImage','outlineImage');
    if ~exist(folder2save,'dir')
        mkdir(folder2save)
    end
    if ~exist(fullfile(folder2save,pathSegmentedGlands(nGland).name),'file')
    
        %read tiff labelled images
        img = readStackTif(fullfile(pathSegmentedGlands(nGland).folder,pathSegmentedGlands(nGland).name));
    
        %get dilated cell outlines
        maskOutlines = getCellOutlines(img);
        
        %save tiff outlines images
        writeStackTif(maskOutlines,fullfile(folder2save,pathSegmentedGlands(nGland).name))
    end
    
   
end

