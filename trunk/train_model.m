function [classifier, centroid_features] = train_model(pos_directory, neg_directory, trainfile , paramfile, varargin)
% run this like
% process('images/pos', 'images/neg', 'svm_train_file', 'svm_param_file',...
%         'desc', 'rift', 'keypt', 'hl', 'threshold', 0.2), and so on
% adding some options mentioned below if necessary
% 
% train an SVM on training data, inputs are:
% pos_directory : the path of directory containing positive tarining examples
% neg_directory : the path of directory containing negative tarining
%      examples
% tarinfile: the file in which the training data descriptors will be saved
% paramfile: the file in which parameters of the trained SVM will be
% saved
%
% these other options will also be needed
% 'desc' : rift sift or spin
% 'keypt' : harris laplace, harris corner, sift
% 'cell size': is the size of region selected around each key point
% 'ori_binsize' : along with RIFT can be used to determine number of
% 'intens_binsize' :
% orientation bins and along with spin images it is used to determine
% number of intensity bins
% dist_binsize: determine the number of circular rings that we're
% considering aroung the key point
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('pos_directory', @ischar);
p.addRequired('neg_directory', @ischar);
p.addRequired('trainfile', @ischar);
p.addRequired('paramfile', @ischar);
p.addParamValue('have_pts', false, @(x)(x == true || x == false));
p.addParamValue('clusters', 2000, @(x)(x > 1));
p.addParamValue('ext', 'train', @ischar);
p.addParamValue('cl_algo', 'svm', @(x)any(strcmpi(lower(x),{'svm', 'nb', ...
                    'naive_bayes'})));
p.parse(pos_directory, neg_directory, trainfile , paramfile, ...
        varargin{:});
have_pts = p.Results.have_pts;
k = p.Results.clusters;

% get keypoints for each image
if(have_pts)
  % if we already have points then 
  % pos_directory is actually a points file, and similarly for neg_directory
  points_files = { pos_directory, neg_directory};
  points = read_points_from_file( points_files );
else
  points = findAllKeypoints( {pos_directory, neg_directory}, varargin{:});
  write_points_to_file({pos_directory, neg_directory}, points, varargin{:});
end

[features, split_features] = generate_features( points, varargin{:});                                                  

% find the features we want to cluster around
k = min(k, max(8, floor(size(features, 1)/8)))
centroid_features = kmeans(k, features);

% setup to train an svm
% reads all the key points from file and generates descriptors for each
% keypoint
% 
posfeatures = split_features{1};  
posData = make_feature_vector(centroid_features, posfeatures);
posY = ones( size(posData,1) ,1);

negfeatures = split_features{2};
negData = make_feature_vector(centroid_features, negfeatures);
negY = -1*ones( size(negData,1) ,1);

% make the call to train our classifier
cl_algo = p.Results.cl_algo;
classifier = train_classifier(cl_algo, [posData ; negData], [posY ; negY], ...
                              'trainfile', trainfile, 'paramfile', paramfile);
