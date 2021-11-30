
% mole_Names = {'E-cad'};%'Sqh-GFP';%'E-cad','Dlg+Phal\Dlg','Dlg+Phal\Phal'};
function fluorescencePlot(organFolderName,markerName)
%organFolderName = 'DrosophilaEmbryo_Carmen\';
% organFolderName = '*SalivaryGlandEcadhi*';
% markerName='E-cad';
fixedStepsHeight = 0:0.0125:1;


% for nMol = mole_Names
%     foldDir = dir(fullfile(organFolderName, nMol{1}));
foldDir = dir(fullfile(organFolderName));
totalIntensities={};
h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
for nFold=1:size(foldDir,1)
    dataDir = dir(fullfile(foldDir(nFold).folder,foldDir(nFold).name));
    dataDir(1:2,:)=[];
    cellIntensities = cell(size(dataDir,1)*10,1);
    for nFiles = 1 : size(dataDir,1)
        
        if dataDir(nFiles).isdir
            fullPath = fullfile(dataDir(nFiles).folder,dataDir(nFiles).name);
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
                %                  plot(cellHeight,intensity,'LineWidth',0.5)
                %                  hold on
                
                %interpolate cell height to fixed cell height step ->
                %0.0125
                intensityInterpoled = interp1(cellHeight,intensity,fixedStepsHeight);
                
                cellIntensities{1,10*(nFiles-1) + nCSVFile} = intensityInterpoled;
            end
        end
    end
    totalIntensities{nFold} = vertcat(cellIntensities{1,:});
    if contains(string(foldDir(nFold).name),'Control')
        shadedErrorBar(fixedStepsHeight,totalIntensities{1,nFold},{@mean,@std},'lineProps','g');
    else
        shadedErrorBar(fixedStepsHeight,totalIntensities{1,nFold},{@mean,@std},'lineProps','m');
    end
    hold on
end
% h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     totalIntensities = vertcat(cellIntensities{1,:});
%     meanIntensities = mean(totalIntensities);
%     stdIntensities = std(totalIntensities{1,nFold});
%     errorbar(fixedStepsHeight,meanIntensities,stdIntensities,'LineWidth',2,'Color',[0 0 0])



%     plot(fixedStepsHeight,,'.','color',ylim([0.5,0.5,0.95]))
xlabel('edge length (normalized)')
ylabel('fluorescence intensity')
legend('shg-RNAi','Wild type')
title('E-cad repression Vs Wild type Salivary Glands Fluorescence intensity')

set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
savefig(h,[foldDir(1).folder '\' markerName '_intensity_' date])
print(h,[foldDir(1).folder '\' markerName '_intensity_' date],'-dtiff','-r300')
end

