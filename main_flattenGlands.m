clear all
close all
addpath(genpath(fullfile('..','Processing3DSegmentation')))

%1. Load final segmented glands
pathKindPhenotype = uigetdir();
pathGlands = dir(fullfile(pathKindPhenotype,'**','\layersTissue.mat'));
for nGland = 1:size(pathGlands,1)

    allImages = load(fullfile(pathGlands(nGland).folder, '\layersTissue.mat'),'lateralLayer','lumenImage','labelledImage','lumenImage','lumenSkeleton','apicalLayer');
    labelledImage = allImages.labelledImage;lumenImage = allImages.lumenImage;lateralLayer = allImages.lateralLayer;apicalLayer = allImages.apicalLayer;lumenSkeleton=allImages.lumenSkeleton;

    flattenImage = convertLabelledImage2Flatten(labelledImage, lateralLayer, apicalLayer);

%     volumeSegmenter(labelledImage,flattenImage);
    
    path2saveLayers = [pathKindPhenotype '_flatten'];
    path2save = fullfile(strrep(pathGlands(nGland).folder,pathKindPhenotype,[pathKindPhenotype '_flatten']));
    mkdir(path2save)
    [apicalLayer,basalLayer,lateralLayer,~] = getApicalBasalLateralFromGlands(flattenImage,lumenImage,fullfile(path2save,'layersTissue.mat'));

    save(fullfile(path2save, 'layersTissue.mat'),'-append','lumenSkeleton');

end