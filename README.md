# SalivaryGlands
 
This repository calls to https://github.com/ComplexOrganizationOfLivingMatter/Processing3DSegmentation in order to extract geometrical and connectivity features from segmented 3D *Drosophila* salivary glands.

**1 - Extract features from whole glands** ->    mainFeaturesExtraction.m

**2 - Subdivide glands in different surface ratios (concentrical sections from apical to basal)** ->  main_divideGlandSR.m

**3 - Extract features from concentrical sections** -> mainFeaturesExtraction_dividedGlandsBySR.m

In case you want to process your 3D images of salivary glands to remove the cell-height larger than the height of contacting cellular walls ->  main_flattenGlands.m 

