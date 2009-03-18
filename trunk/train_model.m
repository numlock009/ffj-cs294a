function [classifier, centroid_features, trainMatrix, trainCat] = train_model(pos_directory, neg_directory, trainfile , paramfile, varargin)
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
p.addParamValue('clusters', 2000, @(x)(x > 1));
p.addParamValue('ext', 'train', @ischar);
p.addParamValue('cl_algo', 'svm', @(x)any(strcmpi(lower(x),{'svm', 'nb', ...
                    'naive_bayes'})));
p.addParamValue('weighted', 0, @(x)((x == 1) || (x == 0)));
p.parse(pos_directory, neg_directory, trainfile , paramfile, ...
        varargin{:});
k = p.Results.clusters;
weighted = p.Results.weighted;

% get keypoints for each image
points = getKeypoints({pos_directory, neg_directory}, varargin{:});
[features, split_features] = generate_features(points, varargin{:});
assert(floor(size(features, 1)/8) > 0)

% find the features we want to cluster around
k = min(k, max(8, floor(size(features, 1)/8)))
centroid_features = kmeans(k, features);

% setup to train an svm
% bag of words on the centroids, and then global image features
posfeatures = split_features{1};  
posData = get_feature_vector(points{1}, centroid_features, posfeatures, varargin{:});
posY = ones( size(posData,1) ,1);

negfeatures = split_features{2};
negData = get_feature_vector(points{2}, centroid_features, negfeatures, varargin{:});
negY = -1*ones( size(negData,1) ,1);

% weight the positives examples
if(weighted)
  posY = (size(negY,1)/size(posY,1)) * posY;
end

% make the call to train our classifier
cl_algo = p.Results.cl_algo;
trainMatrix = [posData ; negData];
trainCat = [posY ; negY];

classifier = train_classifier(cl_algo, trainMatrix, trainCat, ...
                              'trainfile', trainfile,...
                              'paramfile', paramfile,...
                              'regression', weighted);

