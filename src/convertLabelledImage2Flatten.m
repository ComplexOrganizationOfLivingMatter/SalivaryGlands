function flattenImage = convertLabelledImage2Flatten(labelledImage, lateralLayer, apicalLayer)

    flattenImage=uint8(zeros(size(labelledImage)));

    unqCells = unique(labelledImage(:));
    unqCells(unqCells==0)=[];
    for nCell=1:length(unqCells)
        [row,col,z]=ind2sub(size(lateralLayer),find(lateralLayer==unqCells(nCell) | apicalLayer==unqCells(nCell)));
        shp = alphaShape(col,row,z); 
        shp.Alpha = 120;
        %     pc = criticalAlpha(shp,'one-region');

        idsCell = find(labelledImage==unqCells(nCell));
        [qRow,qCol,qZ]=ind2sub(size(labelledImage),idsCell);
        
        tf = inShape(shp,qCol,qRow,qZ);
        idsCellIn = idsCell(tf);
        
        flattenImage(idsCellIn)=labelledImage(idsCellIn);

    end
   
end