% load path
project_path
% load variables
load 'results/vars_train_skin_50x50_3_lr_rift.mat'
have_pts_test = 1;
classifier = train_classifier(cl_algo, trainMatrix, trainCat, ...
                              'trainfile', svm_tf,...
                              'paramfile', svm_pm,...
                              'regression', weighted);

% get the training error
[train_ce, train_output] = classifier(trainMatrix, trainCat, [svm_tf, '_TE'], [svm_pm, '_TE']);

precision(sign(train_output), sign(trainCat), 1, -1);
recall(sign(train_output), sign(trainCat), 1, -1);

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

[e, output, testMatrix, testCat] = test_model(classifier, pos_test, neg_test, svm_testf,...
                                              centroids, svm_pd ,...
                                              'desc', desc, 'keypt', keypt,...
                                              'threshold', threshold, ...
                                              'max_points', max_points,...
                                              'ext', test_ext,...
                                              'have_pts', have_pts_test,...
                                              'weighted', ...
                                               weighted*(sum(trainCat~=-1)/sum(trainCat==-1)));

e
precision(sign(output), sign(testCat), 1, -1);
recall(sign(output), sign(testCat), 1, -1);
extra
max_points
threshold
desc
keypt
have_pts_train
have_pts_test
cl_algo
size(centroids)

improve_dataset
