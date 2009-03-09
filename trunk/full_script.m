function full_script(experiment_number, texture, width, height,...
 		     image_folder, script_type, have_pts_train, ...
                     have_pts_test, max_points, threshold, desc, ...
                     keypt, cl_algo)
% load the path
project_path

extra = ['_', texture, '_', experiment_number, '_', script_type];
vars_file = ['results', '/vars', '_train', extra];

% empty if don't have points other wise 
if(have_pts_train)
  have_pts_str_train = ['_points', '_train', extra]
else
  have_pts_str_train = ''; 
end

% image directory for positive examples or
%    if we have points this is the file that tells us where the keypoints 
%    are for each image
pos_train = ['images', image_folder, '/pos', have_pts_str_train]
neg_train = ['images', image_folder, '/neg', have_pts_str_train]
ext = ['train', extra]

% if you are using the svm this is what your files will be named.  They
% will be outputted directly into the main project directory
svm_tf = ['svm_files/svm_train', extra, '_', desc]
svm_pm = ['svm_files/svm_param', extra, '_', desc]

% calling the trainer and tester
[classifier centroids trainMatrix trainCat] = train_model(pos_train, neg_train, svm_tf, svm_pm,...
                                                  'ext', ext, ...
                                                  'desc', desc, 'keypt', keypt, ...
                                                  'threshold', threshold, ...
                                                  'max_points', max_points,...
                                                  'have_pts', have_pts_train,...
                                                  'cl_algo', cl_algo);
classifier

% if we want to save the variables to be used later we call this
save(vars_file);

% get the training error
[train_ce, train_output] = classifier(trainMatrix, trainCat, [svm_tf, '_TE'], [svm_pm, '_TE']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run script for classifying the testing set.
if(have_pts_test)
  have_pts_str_test = ['_points', '_test', extra]
else
  have_pts_str_test = ''; 
end

pos_test = ['images', image_folder, '/pos_test', have_pts_str_test]
neg_test = ['images', image_folder, '/neg_test', have_pts_str_test]
test_ext = ['test', extra]

svm_pd = ['svm_files/svm_predict', extra, '_', desc]
svm_testf = ['svm_files/svm_test', extra, '_', desc]

[e, output] = test_model(classifier, pos_test, neg_test, svm_testf,...
                         centroids, svm_pd ,...
                         'desc', desc, 'keypt', keypt,...
                         'threshold', threshold, ...
                         'max_points', max_points,...
                         'ext', test_ext,...
                         'have_pts', have_pts_test);
e
extra
max_points
threshold
desc
keypt
have_pts_train
have_pts_test
cl_algo
size(centroids)
% if we want to save the variables to be used later we call this
save(['results', '/vars', '_all', extra]);

width = 50
height = 50
improve_dataset
