Hi all!

here is our texture detection package up to now.

to train a model on data you should do the following:
create a directory containing the following sub-directories.
directory named test containing test examples , a directory named train
containing training examples. each of these dierctories should have
a directory called positive and negative . positive should contain positive
examples and negative should negative examples.

to train an SVM you should call something like:
train_model('images/T01_bark1', 'images/T16_glass1', 'svm_train_bg', 'svm_param_bg', 'centroid_file', 'images/centroid_features_bg', 'desc', 'rift', 'keypt', 'hl', 'threshold', 0.005)
             pos_directory       neg_directory        trainfile       paramfile    -  options

A full list of the possible options

'desc' : 'rift' 'sift' or 'spin' descriptors are currently availabel
'keypt' : 'harris_laplace', 'harris_corner', 'sift' keypoints
'cell size': is the size of region selected around each key point, spin and rift and sift
'ori_binsize' : for RIFT the number of orientation bins
'intens_binsize' : for spin image and RIFT descriptors
'dist_binsize'  : for spin image descriptors
'centroid_features' : which features became our centroids for
'max_points'        : the maximum number of keypoints we are willing
                      to consider.

'k' : represents the k value for harris corner detector, if you want
      to change it from the default of 0.04
'threshold' : represents the threshold value for harris corner detector or
              whatever keypoint  detector needs a threshold
'sigma' : represents the sigma value for the harris corner detector using
          the gaussian window              
'width' : window width for harris corner detector (not harris laplace)
'dx'    : the gradient mask being used for harris corner (not harris laplace)

not used in process but in other functions
'pt' : represents a given keypoint (100, 223) for example.
'ext' : the extension we want to use for some of our files
        should never have to touch this.

and to test your model you should call 
test_model(....., centroid_features)
centroid_features are necessary so that we can 
