% load the path 
project_path % this is all relative to the main project directory

% this should be called before this script is run.
% training

have_pts_test = false;
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
% save(['images', image_folder, '/vars', '_all', extra]);