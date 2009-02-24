% load the path 
project_path % this is all relative to the main project directory


experiment_number = '1'
texture = 'bark_glass'
image_folder = '/bark_glass' % for a default pos neg folder just
                                       % make this the empty char
script_type = 'hr' % stands for high res or low res
extra = ['_', texture, '_', experiment_number, '_', script_type];

% image directory for positive examples or
%    if we have points this is the file that tells us where the keypoints 
%    are for each image
pos_train = ['images', image_folder, '/pos']
neg_train = ['images', image_folder, '/neg']
ext = ['train', extra]

pos_test = ['images', image_folder, '/pos_test']
neg_test = ['images', image_folder, '/neg_test']
test_ext = ['test', extra]

% if you are using the svm this is what your files will be named.  They
% will be outputted directly into the main project directory
svm_tf = ['svm_files/svm_train', extra]
svm_pm = ['svm_files/svm_param', extra]
svm_pd = ['svm_files/svm_predict', extra]
svm_testf = ['svm_files/svm_test', extra]

% some other parameters, see the readme.txt for what is available
max_points = 1000
threshold = 0.2
desc = 'rift'
keypt = 'hl'
have_pts = false;
cl_algo = 'svm'

[classifier centroids] = train_model(pos_train, neg_train, svm_tf, svm_pm,...
                                     'ext', ext, ...
                                     'desc', desc, 'keypt', keypt, ...
                                     'threshold', threshold, ...
                                     'max_points', max_points,...
                                     'have_pts', have_pts,...
                                     'cl_algo', cl_algo);
classifier

have_pts = false;
[e, output] = test_model(classifier, pos_test, neg_test, svm_testf,...
                         centroids, svm_pd ,...
                         'desc', desc, 'keypt', keypt,...
                         'threshold', threshold, ...
                         'max_points', max_points,...
                         'ext', test_ext,...
                         'have_pts', have_pts);
e
