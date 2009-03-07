% load the path 
project_path % this is all relative to the main project directory

experiment_number = '5' % '5' % '2'
texture = 'skin_50x50' % 'skin_640x480' % 'skin_50x50' % 'skin_640x480'
width = 50
height = 50
% for a default pos neg folder just make the following the empty char
image_folder = '/skin' % '/face_segments640x480' % '/skin' 
script_type = 'lr' % 'hr' % stands for high res or low res
extra = ['_', texture, '_', experiment_number, '_', script_type];

vars_file = ['images', image_folder, '/vars', '_train', extra, '_2'];
have_pts_train = true;
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

% some other parameters, see the readme.txt for what is available
max_points = 1000
threshold = 0.005
desc = 'rift'
keypt = 'hl'
cl_algo = 'svm'

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
