function []=MakeDataDirectory(opts)
% makes a directory in 'opts.datapath' descriptors containing 
% a directory for all images in the dataset

% /data
if exist([opts.datapath],'dir')~=7
    mkdir(opts.datapath)
end



%/data/global
if exist([opts.datapath,'/global'],'dir')~=7
    mkdir(opts.datapath,'global')
end

%/data/local
%EXIST('A','dir') checks only for directories.
%7 if A is a directory
%这个公式的意思就是检查是否存在这个目录
if exist([opts.datapath,'/local'],'dir')~=7 % if the dir is not exist, then create it
    mkdir(opts.datapath,'local')    
end

for ii=1:opts.nimages
    if exist(sprintf('%s/local/%s',opts.datapath,num2string(ii,8)),'dir')~=7
        %MKDIR(PARENTDIR,NEWDIR) makes a new directory, NEWDIR, under the parent, PARENTDIR.
        mkdir(sprintf('%s/local',opts.datapath),num2string(ii,8))
    end
end
end



        