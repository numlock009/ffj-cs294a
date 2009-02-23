% load the path 
project_path

% image directory for positive examples
pos_train = 'images/T01_bark1'
neg_train = 'images/T16_glass1'

pos_test = 'images/bark1_test'
neg_test = 'images/glass1_test'

svm_tf = 'svm_train_bg_2'
svm_pm = 'svm_param_bg_2'
svm_pd = 'svm_predict_bg_2'
max_points = 1000
threshold = 0.2
desc = 'rift'
keypt = 'hl'

[classifier centroids] = train_model(pos_train, neg_train , svm_tf,...
                                     svm_pm, 'ext', 'train_bg1', ...
                                     'desc', desc, 'keypt', keypt, ...
                                     'threshold', threshold, 'max_points', max_points);
classifier

test_model(pos_test, neg_test, 'svm_test_bg',...
           centroids, svm_pm, svm_pd ,...
           'desc', desc, 'keypt', keypt, 'threshold', threshold, ...
           'max_points', max_points, 'ext', 'test_bg2')

% % the above generates a keypoint file and so I'll use those and input
% % what they should be in the things running below
% process('images/T01_bark1', 'images/T16_glass1', 'svm_train_bg_spin',...
%         'svm_param_bg_spin', 'centroid_file', 'images/centroid_features_bg_spin',...
%         'desc', 'spin',...
%         'keypt_file', 'ASDFASDFASDF')
% test_model('images/T02_bark2/', 'images/T17_glass2/', 'svm_test_bg_spin',...
%            'images/centroid_features_bg_spin.mat', 'svm_param_bg_spin', 'svm_predict_bg_spin',...
%            'desc', 'spin',...
%            'keypt_file', 'ASDFASDFASDFASDF')

