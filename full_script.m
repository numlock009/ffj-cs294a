function full_script(experiment_number, texture, width, height,...
 		     image_folder, neg_folder, script_type, ...
                     max_points, threshold, desc, feature_type, ...
                     keypt, cl_algo, img_dir, final_directory, weighted)
% load the path
project_path

extra = ['_', texture, '_', experiment_number, '_', script_type];
pts_ext = ['_', keypt, '_', num2str(max_points), '_', num2str(threshold)]
svm_ext = [extra, '_', desc, '_', feature_type,'_', int2str(weighted), pts_ext]

% image directory for positive examples or
%    if we have points this is the file that tells us where the keypoints 
%    are for each image
train_pts_ext = ['_points', '_train', pts_ext]
pos_train = ['images', image_folder, '/pos']
neg_train = ['images', neg_folder, '/neg']
if(exist([pos_train, train_pts_ext]) == 2)
  pos_train = [pos_train, train_pts_ext]
end
if(exist([neg_train, train_pts_ext]) == 2)
  neg_train = [neg_train, train_pts_ext]
end
ext = ['train', pts_ext]

% if you are using the svm this is what your files will be named.  They
% will be outputted directly into the main project directory

svm_tf = ['svm_files/svm_train', svm_ext]
svm_pm = ['svm_files/svm_param', svm_ext]

% calling the trainer and tester
[classifier centroids trainMatrix trainCat] = train_model(pos_train, neg_train, svm_tf, svm_pm,...
                                                  'ext', ext, ...
                                                  'desc', desc, 'keypt', keypt, ...
                                                  'threshold', threshold, ...
                                                  'max_points', max_points,...
                                                  'cl_algo', cl_algo,...
                                                  'weighted', weighted,...
                                                  'feature_type', feature_type);
classifier

vars_file = ['results', '/vars', '_train', svm_ext]
% if we want to save the variables to be used later we call this
save(vars_file,...
     'centroids', 'extra', 'desc', 'cl_algo', 'trainMatrix', 'trainCat',...
     'pos_train', 'neg_train', 'ext', 'image_folder',...
     'width', 'height', 'script_type', 'texture', 'experiment_number', 'pts_ext', ...
     'threshold', 'max_points', 'img_dir', 'final_directory', 'weighted', 'svm_tf', 'svm_pm');
save([vars_file, '_centroids'], 'centroids');

% get the training error
[train_ce, train_output] = classifier(trainMatrix, trainCat, [svm_tf, '_TE'], [svm_pm, '_TE']);

te_pr = precision(sign(train_output), sign(trainCat), 1, -1);
te_re = recall(sign(train_output), sign(trainCat), 1, -1);

save([vars_file, '_train_res'], 'train_ce', 'te_pr', 'te_re');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run script for classifying the testing set.

test_pts_ext = ['_points', '_test', pts_ext]
pos_test = ['images', image_folder, '/pos_test']
neg_test = ['images', neg_folder, '/neg_test']
if(exist([pos_test, test_pts_ext]) == 2)
  pos_test = [pos_test, test_pts_ext]
end
if(exist([neg_test, test_pts_ext]) == 2)
  neg_test = [neg_test, test_pts_ext]
end
test_ext = ['test', pts_ext]

svm_pd = ['svm_files/svm_predict', svm_ext]
svm_testf = ['svm_files/svm_test', svm_ext]

[e, output, testMatrix, testCat] = test_model(classifier, pos_test, neg_test, svm_testf,...
                                              centroids, svm_pd ,...
                                              'desc', desc, 'keypt', keypt,...
                                              'feature_type', feature_type,...
                                              'threshold', threshold, ...
                                              'max_points', max_points,...
                                              'ext', test_ext,...
                                              'weighted', ...
                                              weighted*(sum(sign(trainCat)~=-1)/sum(sign(trainCat)==-1)));
e
pr = precision(sign(output), sign(testCat), 1, -1);
re = recall(sign(output), sign(testCat), 1, -1);
extra
max_points
threshold
desc
keypt
cl_algo
size(centroids)

% if we want to save the variables to be used later we call this
save([vars_file, '_res'], 'e', 'pr', 're');
save([vars_file, '_all']);

improve_dataset
