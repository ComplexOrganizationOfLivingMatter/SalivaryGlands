function loadedImage = readStackTif(fileName)

    infoImage = imfinfo(fileName);
    loadedImage = zeros(infoImage(1).Width,infoImage(1).Height,size(infoImage,1));
    for nZ = 1:size(infoImage,1)
        loadedImage(:,:,nZ) = imread(fileName,nZ);
    end

end