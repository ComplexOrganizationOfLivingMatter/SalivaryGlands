mole_Names = {'E-cad'};%'Sqh-GFP';%'E-cad','Dlg+Phal\Dlg','Dlg+Phal\Phal'};
%organFolderName = 'DrosophilaEmbryo_Carmen\';
organFolderName = 'SalivaryGlandWT';

fixedStepsHeight = 0:0.0125:1;


for nMol = mole_Names
    foldDir = dir(fullfile(organFolderName, nMol{1}));
    foldDir(1:2,:)=[];
    cellIntensities = cell(size(foldDir,1)*10,1);
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    for nFiles = 1 : size(foldDir,1)
        if foldDir(nFiles).isdir
             fullPath = fullfile(foldDir(nFiles).folder,foldDir(nFiles).name);
             csvDir = dir(fullfile(fullPath,'*csv'));
             for nCSVFile = 1:size(csvDir,1)
                 cvsName = fullfile(csvDir(nCSVFile).folder,csvDir(nCSVFile).name);
                 tableIntensities = readtable(cvsName);
                 cellHeight = tableIntensities.Distance__microns_;
                 intensity = tableIntensities.Gray_Value;
                 %normalize edge intensity between 0 and 1
%                  intensity = (intensity-min(intensity))/max(intensity-min(intensity));
                 %normalize edge distance between 0 and 1
                 cellHeight = cellHeight/max(cellHeight);
                 if contains(lower(csvDir(nCSVFile).name),'invert')
                     intensity = flip(intensity);
                 end
                 plot(cellHeight,intensity,'LineWidth',0.5)
                 hold on
                 
                 %interpolate cell height to fixed cell height step ->
                 %0.0125
                 intensityInterpoled = interp1(cellHeight,intensity,fixedStepsHeight);
                 
                 cellIntensities{10*(nFiles-1) + nCSVFile} = intensityInterpoled;
             end     
        end
    end
    
    %h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    totalIntensities = vertcat(cellIntensities{:});
    meanIntensities = mean(totalIntensities);
    stdIntensities = std(totalIntensities);
    errorbar(fixedStepsHeight,meanIntensities,stdIntensities,'LineWidth',2,'Color',[0 0 0])
    xlabel('edge length (normalized)')
    ylabel('intensity (normalized)')
    title(strrep(nMol{1},'Dlg+Phal\',''))

    set(gca,'FontSize', 12,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    savefig(h,[foldDir(1).folder '\' strrep(nMol{1},'Dlg+Phal\','') '_intensity_' date])
    print(h,[foldDir(1).folder '\' strrep(nMol{1},'Dlg+Phal\','') '_intensity_' date],'-dtiff','-r300')
end