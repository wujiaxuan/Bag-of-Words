%% Script to perform BOW-based image classification demo
% ========================================================================
% Image Classification using Bag of Words and Spatial Pyramid BoW
% Created by Piji Li (pagelee.sd@gmail.com)  
% Blog: http://www.zhizhihu.com
% Weibo: http://www.weibo.com/pagecn
% IRLab. : http://ir.sdu.edu.cn     
% Shandong University,Jinan,China
% 10/24/2011

%% 这份整理后的代码需要说明的地方 by Glory 20170114
% 1.目前我整理的这份代码，如果main函数直接跑，会出现out of memory的现象
%   造成这个问题的原因是do_p_classification_rbf_svm会造成大量的内存占用
%   第四个，do_p_classification_inter_svm也同理造成大量内存占用
%   在数据集比较大时会出现这个问题。解决的方法就是分开跑，别同时跑3、4两项
% 2.每次加入新测试集之前，需要改动的地方。
%   第一个是label文件夹需要替换出相应的labels文件
%   第二个是图片库文件夹放在当前文件夹（PG_BOW_DEMO-master2）下
%   第三个是main.m，path_opts.images在当前文件夹（PG_BOW_DEMO-master2）下
%   改为相应的图片库名字；
%   注意label和相应的图片库必须一致

%% initialize the settings
display('*********** start *********')
clc;
clear;


%% 为不同图片库设计路径
% 图片库文件夹的名字
path_opts.images = 'images_activity';
% 图片库labels文件
path_opts.labels = 'labels_activity.txt';


%% 
prepare_training;
prepare_testing;
ini;
detect_opts=[];descriptor_opts=[];dictionary_opts=[];assignment_opts=[];ada_opts=[];

%% Descriptors
descriptor_opts.type='sift';                                                     % name descripto
descriptor_opts.name=['des',descriptor_opts.type]; % output name (combines detector and descrtiptor name)
descriptor_opts.patchSize=16;                                                   % normalized patch size
descriptor_opts.gridSpacing=8;
descriptor_opts.maxImageSize=1000;
GenerateSiftDescriptors(pg_opts,descriptor_opts);

%% Create the texton dictionary
dictionary_opts.dictionarySize = 300;
dictionary_opts.name='sift_features';
dictionary_opts.type='sift_dictionary';
CalculateDictionary(pg_opts, dictionary_opts);

%% assignment
assignment_opts.type='1nn';                                 % name of assignment method
assignment_opts.descriptor_name=descriptor_opts.name;       % name of descriptor (input)
assignment_opts.dictionary_name=dictionary_opts.name;       % name of dictionary
assignment_opts.name=['BOW_',descriptor_opts.type];         % name of assignment output
assignment_opts.dictionary_type=dictionary_opts.type;
assignment_opts.featuretype=dictionary_opts.name;
assignment_opts.texton_name='texton_ind';
do_assignment(pg_opts,assignment_opts);

%% CompilePyramid
pyramid_opts.name='spatial_pyramid';
pyramid_opts.dictionarySize=dictionary_opts.dictionarySize;
pyramid_opts.pyramidLevels=3;
pyramid_opts.texton_name=assignment_opts.texton_name;
CompilePyramid(pg_opts,pyramid_opts);

%% Classification
do_classification_rbf_svm

%% histogram intersection kernel
do_classification_inter_svm

%% pyramid bow rbf
do_p_classification_rbf_svm   

%% pyramid bow histogram intersection kernel
do_p_classification_inter_svm
%show_results_script
