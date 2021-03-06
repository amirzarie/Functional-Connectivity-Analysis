function firstlevelPmodAsCovariates(subID,dataName,isFamOnly,isBinarized)
if nargin <4
    isBinarized =[];
end
% List of open inputs
% fMRI model specification: Directory - cfg_files
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Multiple conditions - cfg_files
% fMRI model specification: Multiple regressors - cfg_files
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
% Contrast Manager: Name - cfg_entry
% Contrast Manager: T contrast vector - cfg_entry
rootDir = 'C:\Users\Zhongxu\Documents\myStudy\picpairfMRI\';
codeDir= [rootDir,'matlabFunctions\'];
dataRootDir = 'D:\myStudy\picpairfMRI\';
subDir = [dataRootDir, 's',sprintf('%03d',subID),'\'];

behavDataDir = [subDir,'performanceData\'];
nrun = 1; % enter the number of runs here
jobfile = {'C:\Users\Zhongxu\Documents\myStudy\picpairfMRI\matlabFunctions\firstlevelPmodBothFamNFam_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(26, nrun);
for crun = 1:nrun
    FUNCDIR = [dataRootDir ,'s',sprintf('%03d',subID(crun)),'\encoding'];
    inputs{1, crun} = {[FUNCDIR,'\analysis-',dataName,'PmodEmotionAsCov-',num2str(isFamOnly),num2str(isBinarized),'\']}; % fMRI model specification: Directory - cfg_files
    if ~exist([FUNCDIR,'\analysis-',dataName,'PmodEmotionAsCov-',num2str(isFamOnly),num2str(isBinarized),'\'],'dir')
        mkdir([FUNCDIR,'\analysis-',dataName,'PmodEmotionAsCov-',num2str(isFamOnly),num2str(isBinarized),'\']);
    end
    
    inputs{2, crun} = GetImageList4D([FUNCDIR,'\taskRunsConcatenate'], WildcardFilename('*.img')); % fMRI model specification: Scans - cfg_files    
    inputs{3, crun} = {[behavDataDir,dataName,'multiCondPmod-AsCovariateUsingRawRating-',num2str(isFamOnly),'.mat']}; % fMRI model specification: Multiple conditions - cfg_files
    inputs{4, crun} = {[FUNCDIR,'\taskRunsConcatenate\motionParameter.txt']}; % fMRI model specification: Multiple regressors - cfg_files

    inputs{5, crun} = 'fam1'; % Contrast Manager: Name - cfg_entry
    inputs{6, crun} = [0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{7, crun} = 'fam2'; % Contrast Manager: Name - cfg_entry
    inputs{8, crun} = [0 0 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{9, crun} = 'fam12'; % Contrast Manager: Name - cfg_entry
    inputs{10, crun} = [0 1 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{11, crun} = 'fam1_2'; % Contrast Manager: Name - cfg_entry
    inputs{12, crun} = [0 1 0 0 -1]; % Contrast Manager: T contrast vector - cfg_entry
      
    inputs{13, crun} = 'nfam1'; % Contrast Manager: Name - cfg_entry
    inputs{14, crun} = [0 0 0 0 0 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{15, crun} = 'nfam2'; % Contrast Manager: Name - cfg_entry
    inputs{16, crun} = [0 0 0 0 0 0 0 0 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{17, crun} = 'nfam12'; % Contrast Manager: Name - cfg_entry
    inputs{18, crun} = [0 0 0 0 0 0 0 1 0 0 1]; % Contrast Manager: T contrast vector - cfg_entry
    inputs{19, crun} = 'nfam1_2'; % Contrast Manager: Name - cfg_entry
    inputs{20, crun} = [0 0 0 0 0 0 0 1 0 0 -1]; % Contrast Manager: T contrast vector - cfg_entry
    
    inputs{21, crun} = 'fam12_nfam12'; % Contrast Manager: Name - cfg_entry    
    inputs{22, crun} = [0 1 0 0 1 0 0 -1 0 0 -1]; % Contrast Manager: T contrast vector - cfg_entry 
    
    inputs{23, crun} = 'fam1_nfam1'; % Contrast Manager: Name - cfg_entry    
    inputs{24, crun} = [0 1 0 0 0 0 0 -1]; % Contrast Manager: T contrast vector - cfg_entry 
    
    inputs{25, crun} = 'fam2_nfam2'; % Contrast Manager: Name - cfg_entry    
    inputs{26, crun} = [0 0 0 0 1 0 0 0 0 0 -1]; % Contrast Manager: T contrast vector - cfg_entry 
  
end

spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});



   
%adding contrast
spmDir=[FUNCDIR,'\analysis-',dataName,'PmodEmotionAsCov-',num2str(isFamOnly),num2str(isBinarized),'\']; % fMRI model specification: Directory - cfg_files
 
matlabbatch{1}.spm.stats.con.spmmat = {[spmDir,'SPM.mat']};

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'MainEff_fam1-scrmb';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1 0 -1 0 0 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'MainEff_fam2-scrmb';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [0 0 0 1 0 -1 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'MainEff_fam12-scrmb12';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [1 0 -1 1 0 -1 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'MainEff_fam1-nfam1';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [1 0 0 0 0 0 -1 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'MainEff_fam2-nfam2';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.convec = [0 0 0 1 0 0 0 0 0 -1 0 0];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'MainEff_fam12-nfam12';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.convec = [1 0 0 1 0 0 -1 0 0 -1 0 0];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'MainEff_fam1-nfam1_scrmble';
matlabbatch{1}.spm.stats.con.consess{7}.tcon.convec = [1 0 -1 0 0 0 -1 0 1 0 0 0];
matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'MainEff_fam2-nfam2_scrmble';
matlabbatch{1}.spm.stats.con.consess{8}.tcon.convec = [0 0 0 1 0 -1 0 0 0 -1 0 1];
matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'MainEff_fam12-nfam12_scrmble';
matlabbatch{1}.spm.stats.con.consess{9}.tcon.convec = [1 0 -1 1 0 -1 -1 0 1 -1 0 1];
matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;

spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
