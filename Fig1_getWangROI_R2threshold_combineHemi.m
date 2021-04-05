%% open mrloadRet

%% under 'GLM_all' in the faceLoc concatenation 
rois = loadROITSeries(getMLRView, []); % load all 50 lh+rh.Wang2015atlas ROIs

for i=1:length(rois)
scanCoords{i} = rois{1,i}.scanCoords;
end

%size=[160,160,42]; % scan dim for 7T BOLD
size=[64,64,30]; % scan dim for 3T BOLD

d1 = viewGet(getMLRView, 'd');
R2_data = viewGet(getMLRView, 'overlay')
R2 = R2_data.data{1}; % dim = [160,160,42] for 7T, or [64,64,30] for 3T

max(R2(:))
nanmean(R2(:))

for roi=1:numel(scanCoords)
if ~isempty(scanCoords{roi})
roi2{roi}=scanCoords{roi};
linearInd{roi} = sub2ind(size,roi2{roi}(1,:),roi2{roi}(2,:),roi2{roi}(3,:));
r2_roi2{roi}=R2(linearInd{roi});
roi2_threshold{roi}=roi2{roi}(:,r2_roi2{roi}>0.1);
end
end

for j=1:25
    roi2_threshold_hemi{j}=[roi2_threshold{j},roi2_threshold{j+25}];
end

% FEF, hV4, IPS0
for k=1:3
roi2_threshold_combinedROI2{k}=roi2_threshold_hemi{k};
end

% IPS1-5
roi2_threshold_combinedROI2{4}=[roi2_threshold_hemi{4},roi2_threshold_hemi{5},roi2_threshold_hemi{6},roi2_threshold_hemi{7},roi2_threshold_hemi{8}];
% LO = LO1+LO2
roi2_threshold_combinedROI2{5}=[roi2_threshold_hemi{9},roi2_threshold_hemi{10}];
% PHC = PHC1+PHC2
roi2_threshold_combinedROI2{6}=[roi2_threshold_hemi{11},roi2_threshold_hemi{12}];
% SPL
roi2_threshold_combinedROI2{7}=[roi2_threshold_hemi{13}];
% TO = TO1+TO2
roi2_threshold_combinedROI2{8}=[roi2_threshold_hemi{14},roi2_threshold_hemi{15}];
% V1 = V1d+V1v
roi2_threshold_combinedROI2{9}=[roi2_threshold_hemi{16},roi2_threshold_hemi{17}];
% V2 = V2d+V2v
roi2_threshold_combinedROI2{10}=[roi2_threshold_hemi{18},roi2_threshold_hemi{19}];
% V3AB = V3A+V3v
roi2_threshold_combinedROI2{11}=[roi2_threshold_hemi{20},roi2_threshold_hemi{21}];
% V3 = V3d+V3v
roi2_threshold_combinedROI2{12}=[roi2_threshold_hemi{22},roi2_threshold_hemi{23}];
% VO = VO1+VO2
roi2_threshold_combinedROI2{13}=[roi2_threshold_hemi{24},roi2_threshold_hemi{25}];


%% under 'GLM_F-N' in the amyV1 task
d2 = viewGet(getMLRView, 'd');
rois_AmyV1 = loadROITSeries(getMLRView, []); % load all 50 lh and rh.Wang2015atlas ROIs (same order!)
%rois_AmyV1 = rois

%% for hemi combined
for j=1:25
   rois_AmyV1_hemi{j}.tSeries=[rois_AmyV1{j}.tSeries; rois_AmyV1{j+25}.tSeries];
   rois_AmyV1_hemi{j}.scanCoords=[rois_AmyV1{j}.scanCoords, rois_AmyV1{j+25}.scanCoords];
end

for k=1:3
rois_AmyV1_hemi_combinedROI2{k}.tSeries = rois_AmyV1_hemi{k}.tSeries;
rois_AmyV1_hemi_combinedROI2{k}.scanCoords=rois_AmyV1_hemi{k}.scanCoords;
end

%% 13 ROIs
rois_AmyV1_hemi_combinedROI2{4}.scanCoords =[rois_AmyV1_hemi{4}.scanCoords,rois_AmyV1_hemi{5}.scanCoords,rois_AmyV1_hemi{6}.scanCoords,rois_AmyV1_hemi{7}.scanCoords,rois_AmyV1_hemi{8}.scanCoords];
rois_AmyV1_hemi_combinedROI2{5}.scanCoords =[rois_AmyV1_hemi{9}.scanCoords,rois_AmyV1_hemi{10}.scanCoords];
rois_AmyV1_hemi_combinedROI2{6}.scanCoords =[rois_AmyV1_hemi{11}.scanCoords,rois_AmyV1_hemi{12}.scanCoords];
rois_AmyV1_hemi_combinedROI2{7}.scanCoords =[rois_AmyV1_hemi{13}.scanCoords];
rois_AmyV1_hemi_combinedROI2{8}.scanCoords =[rois_AmyV1_hemi{14}.scanCoords,rois_AmyV1_hemi{15}.scanCoords];
rois_AmyV1_hemi_combinedROI2{9}.scanCoords =[rois_AmyV1_hemi{16}.scanCoords,rois_AmyV1_hemi{17}.scanCoords];
rois_AmyV1_hemi_combinedROI2{10}.scanCoords=[rois_AmyV1_hemi{18}.scanCoords,rois_AmyV1_hemi{19}.scanCoords];
rois_AmyV1_hemi_combinedROI2{11}.scanCoords=[rois_AmyV1_hemi{20}.scanCoords,rois_AmyV1_hemi{21}.scanCoords];
rois_AmyV1_hemi_combinedROI2{12}.scanCoords=[rois_AmyV1_hemi{22}.scanCoords,rois_AmyV1_hemi{23}.scanCoords];
rois_AmyV1_hemi_combinedROI2{13}.scanCoords=[rois_AmyV1_hemi{24}.scanCoords,rois_AmyV1_hemi{25}.scanCoords];

rois_AmyV1_hemi_combinedROI2{4}.tSeries =[rois_AmyV1_hemi{4}.tSeries;rois_AmyV1_hemi{5}.tSeries;rois_AmyV1_hemi{6}.tSeries;rois_AmyV1_hemi{7}.tSeries;rois_AmyV1_hemi{8}.tSeries];
rois_AmyV1_hemi_combinedROI2{5}.tSeries =[rois_AmyV1_hemi{9}.tSeries;rois_AmyV1_hemi{10}.tSeries];
rois_AmyV1_hemi_combinedROI2{6}.tSeries =[rois_AmyV1_hemi{11}.tSeries;rois_AmyV1_hemi{12}.tSeries];
rois_AmyV1_hemi_combinedROI2{7}.tSeries =[rois_AmyV1_hemi{13}.tSeries];
rois_AmyV1_hemi_combinedROI2{8}.tSeries =[rois_AmyV1_hemi{14}.tSeries;rois_AmyV1_hemi{15}.tSeries];
rois_AmyV1_hemi_combinedROI2{9}.tSeries =[rois_AmyV1_hemi{16}.tSeries;rois_AmyV1_hemi{17}.tSeries];
rois_AmyV1_hemi_combinedROI2{10}.tSeries=[rois_AmyV1_hemi{18}.tSeries;rois_AmyV1_hemi{19}.tSeries];
rois_AmyV1_hemi_combinedROI2{11}.tSeries=[rois_AmyV1_hemi{20}.tSeries;rois_AmyV1_hemi{21}.tSeries];
rois_AmyV1_hemi_combinedROI2{12}.tSeries=[rois_AmyV1_hemi{22}.tSeries;rois_AmyV1_hemi{23}.tSeries];
rois_AmyV1_hemi_combinedROI2{13}.tSeries=[rois_AmyV1_hemi{24}.tSeries;rois_AmyV1_hemi{25}.tSeries];



%% 13 ROIs
for i=1:length(rois_AmyV1_hemi_combinedROI2)
    if ~isempty(rois_AmyV1_hemi_combinedROI2{i}.tSeries())& ~isempty(roi2_threshold_combinedROI2{i}')
rois_AmyV1_hemi_combinedROI2_tS{i} = rois_AmyV1_hemi_combinedROI2{i}.tSeries();
rois_AmyV1_hemi_combinedROI2_tS_tr{i}=rois_AmyV1_hemi_combinedROI2_tS{i}(ismember(rois_AmyV1_hemi_combinedROI2{i}.scanCoords',roi2_threshold_combinedROI2{i}','rows'),:);
resps_combinedROI2{i} = getr2timecourse(mean(rois_AmyV1_hemi_combinedROI2_tS_tr{i}), d2.nhdr, 1, d2.scm);
    end
end

for i=1:length(rois_AmyV1_hemi_combinedROI2)
%model{i} = resps{i}.scm .* resps{i}.ehdr';
 if ~isempty(resps_combinedROI2{i})
data_13ROI(i,:)= resps_combinedROI2{i}.ehdr';
errlow_13ROI(i,:) = resps_combinedROI2{i}.ehdrste';
errhigh_13ROi(i,:) = resps_combinedROI2{i}.ehdrste';
end
end

figure %
name={'FEF','hV4','IPS0','IPS1-5','LO','PHC','SPL','TO','V1','V2','V3AB','V3','VO'}
mybar(data_13ROI,'groupLabels',name,'withinGroupLabels',{'Fearful','Happy','Neutral'},'yAxisMin=-3','yAxisMax=5','yError',errlow_13ROI)
mybar(data_13ROI,'groupLabels',name,'withinGroupLabels',{'Fearful','Happy','Neutral'},'yAxisMin=-1','yAxisMax=2.5','yError',errlow_13ROI)
ylabel('fMRI Response (% sigal change)','FontSize',20,'Color','k') 


% do this for each scan (11 scans at 3T BOLD + 12 scans at 7T BOLD)
% saved as raw_7T_3T_13ROIs_uniqueSubj
% 15 unique subject in 7T & 3T who had face localizer
for i=1:15
Wang_7T_3T_results_uniqueSubj(:,:,i)=raw_7T_3T_13ROIs_uniqueSubj((i-1)*13+1:13*i,:);
Wang_7T_3T_ValenceEffect_uniqueSubj(:,i)= Wang_7T_3T_results_uniqueSubj(:,1,i)-Wang_7T_3T_results_uniqueSubj(:,3,i);
end

Wang_7T_3T_results_uniqueSubj(Wang_7T_3T_results_uniqueSubj==0)=nan;
Wang_7T_3T_ValenceEffect_uniqueSubj(Wang_7T_3T_ValenceEffect_uniqueSubj==0)=nan;
Wang_7T_3T_ValenceEffect_uniqueSubj=Wang_7T_3T_ValenceEffect_uniqueSubj'

Average_Wang_7T_3T_results_uniqueSubj=nanmean(Wang_7T_3T_results_uniqueSubj,3);
Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj=Average_Wang_7T_3T_results_uniqueSubj(:,1)-Average_Wang_7T_3T_results_uniqueSubj(:,3)
STD_Wang_7T_3T_results_uniqueSubj=nanstd(Wang_7T_3T_results_uniqueSubj,[],3);
se_Wang_7T_3T_results_uniqueSubj=STD_Wang_7T_3T_results_uniqueSubj/sqrt(15);


FFA_7T_3T_ValenceEffect_uniqueSubj=FFA_7T_3T_uniqueSubj_R2(:,1)-FFA_7T_3T_uniqueSubj_R2(:,3);
Average_FFA_7T_3T_uniqueSubj=nanmean(FFA_7T_3T_uniqueSubj_R2)
sd_FFA_7T_3T_uniqueSubj=nanstd(FFA_7T_3T_uniqueSubj_R2)
se_FFA_7T_3T_uniqueSubj=sd_FFA_7T_3T_uniqueSubj/sqrt(15)

AMG_7T_3T_ValenceEffect_uniqueSubj=AMG_7T_3T_uniqueSubj_R2(:,1)-AMG_7T_3T_uniqueSubj_R2(:,3);

Average_AMG_7T_3T_uniqueSubj=nanmean(AMG_7T_3T_uniqueSubj_R2)
sd_AMG_7T_3T_uniqueSubj=nanstd(AMG_7T_3T_uniqueSubj_R2)
se_AMG_7T_3T_uniqueSubj=sd_AMG_7T_3T_uniqueSubj/sqrt(15)


%% Fig 1 negative valence (fearful-neutral)
FigHandle = figure('Position', [100, 100, 1700, 800]);
markerSize = 400;

for i=1:15
scatter(x_coor(i,:),Wang_7T_3T_ValenceEffect_uniqueSubj_fromExcel(i,:), markerSize,'o','LineWidth',3);
hold on
end

xlim([0 16])
set(gca, 'tickdir', 'out');
ylim([-.6 1.8]) % for para
yticks([-.6 0 0.6 1.2 1.8])
%yticklabels({'-0.5' '0' '0.5' '1'});

for i = 1:15 
plot([x_coord(i,1), x_coord(i,2)],[Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i), Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i)], 'Color', 'r', 'LineStyle', '-','LineWidth',6); hold on
end

for i = 4
plot([x_coord(i,1), x_coord(i,2)],[Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i), Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i)], 'Color', 'k', 'LineStyle', '-','LineWidth',6); hold on
end

for i = 8:13
plot([x_coord(i,1), x_coord(i,2)],[Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i), Average_ValenceEffect_Wang_7T_3T_results_uniqueSubj(i)], 'Color', 'k', 'LineStyle', '-','LineWidth',6); hold on
end
plot([0, 16],[0, 0], 'Color', [170/255 170/255 170/255], 'LineStyle', '--','LineWidth',4); hold on

xticks(1:1:15)
xticklabels({'V1','V2','V3','V3AB','hV4','LO','VO','TO','PHC','IPS0','IPS1-5','SPL','FEF','AMG', 'FFA'});
ylabel('Fearful - Neutral Faces (% change BOLD)','FontSize',24,'Color','k') 
ax = gca;
ax.FontSize = 28;
box off


%% Supp Fig 1 positive valence (happy-neutral)
FigHandle = figure('Position', [100, 100, 1700, 800]);
markerSize = 400;

for i=1:15
scatter(x_coor(i,:),Wang_7T_3T_PosiValenceEffect_uniqueSubj(i,:), markerSize,'o','LineWidth',3);
hold on
end

xlim([0 16])
set(gca, 'tickdir', 'out');
ylim([-.6 1.8]) % for para
yticks([-.6 0 0.6 1.2 1.8])

for i = 1:15
plot([x_coord(i,1), x_coord(i,2)],[Average_PosiValenceEffect_Wang_7T_3T_results_uniqueSubj(i), Average_PosiValenceEffect_Wang_7T_3T_results_uniqueSubj(i)], 'Color', 'k', 'LineStyle', '-','LineWidth',6); hold on
end

for i = 2:3
plot([x_coord(i,1), x_coord(i,2)],[Average_PosiValenceEffect_Wang_7T_3T_results_uniqueSubj(i), Average_PosiValenceEffect_Wang_7T_3T_results_uniqueSubj(i)], 'Color', 'r', 'LineStyle', '-','LineWidth',6); hold on
end
 
plot([0, 16],[0, 0], 'Color', [170/255 170/255 170/255], 'LineStyle', '--','LineWidth',4); hold on

xticks(1:1:15)
xticklabels({'V1','V2','V3','V3AB','hV4','LO','VO','TO','PHC','IPS0','IPS1-5','SPL','FEF','AMG', 'FFA'});
ylabel('Happy - Neutral Faces (% change BOLD)','FontSize',24,'Color','k') 
ax = gca;
ax.FontSize = 28;
box off
 

%% Fig 3: VE as a function of eccentricity
FigHandle = figure('Position', [100, 100, 800, 750]);
markerSize = 250;
plot([0, 6],[0, 0], 'Color', [170/255 170/255 170/255], 'LineStyle', '--','LineWidth',4); hold on

for i=1:20
scatter(x_coor_VE(i,:),VE_ecc(i,:), markerSize,'o','LineWidth',2);
hold on
end

xlim([0 6])
set(gca, 'tickdir', 'out');
ylim([-.3 .9]) % for para
yticks([-.3 0 .3 .6 .9]) % for para

for i = 1:5
plot([x_coord(i,1), x_coord(i,2)],[Average_VE_ecc(i) Average_VE_ecc(i)], 'Color', 'r', 'LineStyle', '-','LineWidth',4); hold on
end
 
xticks(1:1:5)
xticklabels({'0.5-2','2.5-6','6-15','15-36','36-88'});
ylabel('Fearful - Neutral Faces (% change BOLD)','FontSize',30,'Color','k') 
ax = gca;
ax.FontSize = 32;
box off
xlabel('visual eccentricity (deg)');
