function [idx_item_ERS,idx_rs,...
idx_rt_ERS,idx_rt_ln,idx_rt_mem,...
          list_wid]...
=get_idx_item(subs,remD,t)
clc;clear idx*
% for subs=setdiff([1:31],[9 13])
% clc;clear idx*;
% remD=0;
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
behavdir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
%behavdir='/Users/xiaoqian/Documents/experiment/Cicero/exp-scripts/Mol/Results_scan';
datadir=sprintf('%s/pattern/ROI_based/ref_space/raw',basedir);
zdir=sprintf('%s/pattern/ROI_based/ref_space/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero
%%%%%%%%%
rs_ln=[];rs_mem=[];rs_ERS=[];
md_ln=[];md_ERS=[];
rt_ERS=[];rt_ln=[];rt_mem=[];
item_ERS=[];
first_4subs=[1 2 4 5];
fsubs=setdiff([1:31],first_4subs);
iSub=subs;
xm=remD;%set the distance that consider as remebered in distance judgment task
TTN=30*4; %total trial number; 30 per run, 4 encoding/retrieval runs in total
% load testing data
    all_encoding=[];
    all_test=[];
    for iRun = 1:2
        encoding_filename = ls(sprintf('%s/sub%02d_encoding_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',encoding_filename));
        data_encoding=AllTrialInfos;
        data_encoding.runID=iRun*ones(30,1);
        data_encoding.phase=1*ones(30,1);
        test_filename = ls(sprintf('%s/sub%02d_testing_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',test_filename));
        data_test=AllTrialInfos;
        data_test.runID=iRun*ones(30,1);
        data_test.phase=2*ones(30,1);
        te=sortrows(data_encoding,{'WordID'});
        tt=sortrows(data_test,{'WordID'});
        te.ESeq=te.TrialNo;%encoding sequence
        tt.ESeq=te.TrialNo;%encoding sequence
        te.RSeq=tt.TrialNo;%retrieval sequence
        tt.RSeq=tt.TrialNo;%retrieval sequence
        te.RT=tt.RT;%retrieval sequence
        te.Response=tt.Response;%retrieval sequence
        te.InitPos=tt.InitPos;%retrieval sequence
        te.Distance=tt.Distance;
        if any(fsubs(:)==iSub)
           te.ASlider=tt.ASlider;
        end
        data_test=sortrows(tt,{'Onset'});
        data_encoding=sortrows(te,{'Onset'});
        all_encoding=vertcat(all_encoding,data_encoding);
        all_test=vertcat(all_test,data_test);
    end %run
    behav=vertcat(all_encoding,all_test);

    if any(fsubs(:)==iSub)
        behav.Distance(strcmp(behav.Distance,{'not sure'}))={'999'};
    else
        behav.Distance(strcmp(behav.Distance,{'Not sure'}))={999};
    end
    list_wid=behav.WordID;
    % generate pair label
    idx_item1 = []; % index of item ID for the item1 in the pair
    idx_item2 = []; % index of item ID for the item2 in the pair
    idx_run1 = []; % index of run number for the item1 in the pair: 1~2
    idx_run2 = []; % index of run number for the item2 in the pair: 1~2
    idx_phase1 = []; % index of run type for the item1 in the pair:...
        ...1=encoding; 2=retrieval
    idx_phase2 = []; % index of run type for the item2 in the pair
    idx_loc_num1 = []; % index of the location of the loc for the item1...
        ...of pair: 1~10
    idx_loc_num2 = []; % index of the location of the loc for the item2...
        ...of pair: 1~10
    idx_ESeq1 = []; % index of the location in encoding sequence for...
        ...the item1 of pair: 1~30
    idx_ESeq2 = []; % index of the location in encoding sequence for...
        ...the item2 of pair: 1~30
    idx_RSeq1 = []; % index of the location in retrieval sequence for...
        ...the item1 of pair: 1~30
    idx_RSeq2 = []; % index of the location in retrieval sequence for...
        ...the item2 of pair: 1~30
    idx_itemCat1 = []; % index of category for the item1 in the pair:...
        ...1=living;2=nonliviing
    idx_itemCat2 = []; % index of category for the item2 in the pair:...
        ...1=living;2=nonliving
    idx_lociCat1 = []; % index of category for the loci for item1 in the ...
        ...pair:1=living;2=nonliviing
    idx_lociCat2 = []; % index of category for the loci the item2 in the ...
        ...pair:1=living;2=nonliving
    dis_loci = []; % distance between loci
    dis_ESeq = []; % distance in encoding sequence
    dis_RSeq = []; % distance in retrieval sequence
    check_item = []; % 1=same item; 0=diff item
    check_run = []; % 1=same run; 0=diff run
    check_phase = []; % 1=same run type; 0=diff run type
    check_itemCate = []; % 1=same item category; 0=diff item category
    check_lociCate = []; % 1=same loci category; 0=diff loci category
    check_mem1 = []; % 1=same loci category; 0=diff loci category
    check_mem2 = []; % 1=same loci category; 0=diff loci category
    for k = 2:TTN
        idx_item1 = [idx_item1, (behav.WordID(k-1)*ones(1,TTN-k+1))];
        idx_item2 = [idx_item2, behav.WordID(k:TTN)'];
        idx_run1 = [idx_run1, (behav.runID(k-1)*ones(1,TTN-k+1))];
        idx_run2 = [idx_run2, behav.runID(k:TTN)'];
        idx_phase1 = [idx_phase1, (behav.phase(k-1)*ones(1,TTN-k+1))];
        idx_phase2 = [idx_phase2, behav.phase(k:TTN)'];
        idx_loc_num1 = [idx_loc_num1, (behav.Loci(k-1)*ones(1,TTN-k+1))];
        idx_loc_num2 = [idx_loc_num2, behav.Loci(k:TTN)'];
        idx_ESeq1 = [idx_ESeq1, (behav.ESeq(k-1)*ones(1,TTN-k+1))];
        idx_ESeq2 = [idx_ESeq2, behav.ESeq(k:TTN)'];
        idx_RSeq1 = [idx_RSeq1, (behav.RSeq(k-1)*ones(1,TTN-k+1))];
        idx_RSeq2 = [idx_RSeq2, behav.RSeq(k:TTN)'];
        %idx_itemCat1 = [idx_itemCat1, (behav.Cate(k-1)*ones(1,TTN-k+1))];
        %idx_itemCat2 = [idx_itemCat2, behav.Cate(k:TTN)'];
        idx_lociCat1 = [idx_lociCat1, (behav.Loci(k-1)*ones(1,TTN-k+1))];
        idx_lociCat2 = [idx_lociCat2, behav.Loci(k:TTN)'];

        dis_loci = [dis_loci, abs(behav.Loci(k:TTN)-behav.Loci(k-1))'];
        dis_ESeq = [dis_ESeq, abs(behav.ESeq(k:TTN)-behav.ESeq(k-1))'];
        dis_RSeq = [dis_RSeq, abs(behav.RSeq(k:TTN)-behav.RSeq(k-1))'];
        check_item = [check_item, 1-abs(behav.WordID(k:TTN)-behav.WordID(k-1))'];
        check_run = [check_run, 1-abs(behav.runID(k:TTN)-behav.runID(k-1))'];
        check_phase = [check_phase, 1-abs(behav.phase(k:TTN)-behav.phase(k-1))'];
        %check_itemCate = [check_itemCate, abs(behav.itemCate(k:TTN)-behav.itemCate(k-1))'];
        check_lociCate = [check_lociCate, ismember(behav.LociCate(k:TTN),behav.LociCate(k-1))'];
        if any(fsubs(:)==iSub)
            check_mem1 = [check_mem1, abs(str2double(behav.Distance(k-1))*ones(1,TTN-k+1))];
            check_mem2 = [check_mem2, (str2double(behav.Distance(k:TTN)))'];
        else
            check_mem1 = [check_mem1, abs(cell2mat(behav.Distance(k-1))*ones(1,TTN-k+1))];
            check_mem2 = [check_mem2, (cell2mat(behav.Distance(k:TTN)))'];
        end
    end

    %%% get indexes
    %%1. %item-specific ERS
    idx_item_ERS{1}=find(idx_item1==t & idx_item1==idx_item2 & idx_phase1==1 & check_phase==0 & check_run==1 & ...
    check_item==1 & check_mem2<=xm);
    idx_item_ERS{2}=find(idx_item1==t & idx_item1~=idx_item2 & idx_phase1==1 & check_phase==0 & check_run==1 & ...
    check_item==0 & check_mem2<=xm);

    %%2. Neural representation of spatial context:Within Loci > Across Loci
    %idx_rs{cate,wr/cr,wl/bl};cate:1=encoding;2=retrieval;3=ERS
    for c=1:2 %1=within run;2=cross runs
        %encoding
        idx_rs{1,c,1}=find(idx_item1==t & idx_phase1==1 & check_phase==1 & ...
        check_run==2-c & dis_loci==0);
        idx_rs{1,c,2}=find(idx_item1==t & idx_phase1==1 & check_phase==1 & ...
        check_run==2-c & check_lociCate==1 & ...
        dis_loci~=0 & ...
        ((dis_ESeq >= 8 & dis_ESeq <= 12) | (dis_ESeq >= 18 & dis_ESeq <= 22)));
        %retrieval
        idx_rs{2,c,1}=find(idx_item1==t & idx_phase1==2 & check_phase==1 & ...
        check_run==2-c & dis_loci==0 & ...
        check_mem1<=xm & check_mem2<=xm);
        idx_rs{2,c,2}=find(idx_item1==t & idx_phase1==2 & check_phase==1 & ...
        check_run==2-c & check_lociCate==1 & ...
        dis_loci~=0 & ...
        check_mem1<=xm & check_mem2<=xm & ...
        ((dis_ESeq >= 8 & dis_ESeq <= 12) | (dis_ESeq >= 18 & dis_ESeq <= 22)));
        idx_rs{2,c,3}=find(idx_item1==t & idx_phase1==2 & check_phase==1 & ...
        check_run==2-c & dis_loci==0 & ...
        check_mem1==10 & check_mem2<=xm);
        %ERS
        idx_rs{3,c,1}=find(idx_item1==t & idx_phase1==1 & check_phase==0 & ...
        check_run==2-c & dis_loci==0 & ...
        check_mem2<=xm);
        idx_rs{3,c,2}=find(idx_item1==t & idx_phase1==1 & check_phase==0 & ...
        check_run==2-c & check_lociCate==1 & ...
        dis_loci~=0 & ...
        check_mem2<=xm & ...
        ((dis_ESeq >= 8 & dis_ESeq <= 12) | (dis_ESeq >= 18 & dis_ESeq <= 22)));
        idx_rs{3,c,3}=find(idx_item1==t & idx_phase1==1 & check_phase==0 & ...
        check_run==2-c & dis_loci==0 & ...
        check_mem2==10);
    end
                          
    %%3. Neural representation of temporal context:...
        ...Sequential Neighbors > Long Distance Pairs
    for d=1:2 %1:distance = 10;2:distance=20
        idx_rt_ln{d}=find(idx_item1==t & idx_phase1==1 & check_phase==1 & check_run==1 & dis_loci==0 & dis_ESeq==10*d);
        idx_rt_mem{d}=find(idx_item1==t & idx_phase1==2 & check_phase==1 & check_run==1 & dis_loci==0 & dis_ESeq==10*d & check_mem1<=xm);
        idx_rt_ERS{d}=find(idx_item1==t & idx_phase1==1 & check_phase==0 & check_run==1 & dis_loci==0 & dis_ESeq==10*d & check_mem2<=xm);
    end                     
%end %for
end %end func
