function secondLevelRegression3PredictorsFameEffect_NoCov(isCovariate,memType)
% List of open inputs
% Factorial design specification: Directory - cfg_files
% Factorial design specification: Scans - cfg_files
% Factorial design specification: Vector - cfg_entry
% Factorial design specification: Name - cfg_entry
% Factorial design specification: Vector - cfg_entry
% Factorial design specification: Name - cfg_entry
% Factorial design specification: Vector - cfg_entry
% Factorial design specification: Name - cfg_entry
% Factorial design specification: Vector - cfg_entry
% Factorial design specification: Name - cfg_entry
% Factorial design specification: Vector - cfg_entry
% Factorial design specification: Name - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
contrastNum = 2;
rootDir = 'C:\Users\Zhongxu\Documents\myStudy\picpairfMRI\';
nrun = 1; % enter the number of runs here
subjDir=dir([rootDir,'s0*.*']);
jobfile = {[rootDir,'matlabFunctions\secondLevelRegressionAnalysisNoCovariates_job.m']};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(14, nrun);
load([rootDir,'matlabFunctions\performanceDataConcatenated.mat']);

faceFam_NFam = faceMem.totalFam - faceMem.totalNFam;
houseFam_NFam = houseMem.totalFam - houseMem.totalNFam;
pairFam_NFam = pairMem.avgFam - pairMem.avgNFam;

if nargin==2 && memType == 1 % 1, precise memory, using recollection face, hous and intact pair memory
faceFam_NFam = faceMem.firstRecFam - faceMem.firstRecNFam;
houseFam_NFam = houseMem.firstRecFam - houseMem.firstRecNFam;
pairFam_NFam = pairMem.intactFam - pairMem.intactNFam;
end
    
    
if isCovariate ==1
faceFam_NFam = covariMemData(faceFam_NFam);
houseFam_NFam = covariMemData(houseFam_NFam);
pairFam_NFam = covariMemData(pairFam_NFam);
end

[subjInfo a]=xlsread([rootDir,'matlabFunctions\picpairSubjInfo.xlsx']);
fameOrder = zeros(size(subjInfo,1),1);
fameOrder(1:2:end,1) = 1;
for crun = 1:nrun
    inputs{1, crun} = {[rootDir,'secondLevelReg\multiReg\fameEffect']};% Factorial design specification: Directory - cfg_files
    if ~exist([rootDir,'secondLevelReg\multiReg\fameEffect'],'dir')
        mkdir([rootDir,'secondLevelReg\multiReg\fameEffect']);
    end
        for n = 1:length(subjDir)
        inputs{2, crun}(n) = {[rootDir,subjDir(n).name,'\encoding\analysis\con_',sprintf('%04d',contrastNum),'.img']};
        % Factorial design specification: Scans - cfg_files
    end
    inputs{3, crun} = faceFam_NFam; % Factorial design specification: Vector - cfg_entry
    inputs{4, crun} = 'faceFam-NFam'; % Factorial design specification: Name - cfg_entry
    inputs{5, crun} = houseFam_NFam; % Factorial design specification: Vector - cfg_entry
    inputs{6, crun} = 'houseFam-NFam'; % Factorial design specification: Name - cfg_entry
    inputs{7, crun} = pairFam_NFam; % Factorial design specification: Vector - cfg_entry
    inputs{8, crun} = 'pairFam_NFam'; % Factorial design specification: Name - cfg_entry
   inputs{9, crun} = 'faceFame';
    inputs{10, crun} = [0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{11, crun} = 'houseFame'; % Contrast Manager: Name - cfg_entry
    inputs{12, crun} = [0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{13, crun} = 'pairFame'; % Contrast Manager: Name - cfg_entry
    inputs{14, crun} = [0 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});


function memData = covariMemData(memData)
rootDir = 'C:\Users\Zhongxu\Documents\myStudy\picpairfMRI\';
[subjInfo a]=xlsread([rootDir,'matlabFunctions\picpairSubjInfo.xlsx']);
fameOrder = zeros(size(subjInfo,1),1);
fameOrder(1:2:end,1) = 1;
age = subjInfo(:,2);
gender  = subjInfo(:,3);
[a b memData]=regress(memData,[ones(size(subjInfo,1),1),...
    fameOrder]);
