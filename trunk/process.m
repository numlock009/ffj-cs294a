function process(pos_directory, neg_directory, trainfile , paramfile, varargin)
% run this like
% process('images/pos', 'images/neg', 'svm_train_file', 'svm_param_file',...
%         'desc', 'rift', 'keypt', 'hl', 'threshold', 0.005), and so on
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
% why isn't this working?
% p.addOptional('centroid_file', 'centroid_features', @ischar);
p.parse(pos_directory, neg_directory, trainfile , paramfile, ...
        varargin{:});
centroid_file = p.Unmatched.centroid_file;
assert(ischar(centroid_file));

[min1 min2 points_files] = findAllKeypoints( {pos_directory, neg_directory}, ...
                                             varargin{:}, 'ext', '_train');
% points_files = {'images/pos_points', 'images/neg_points'}; % manually
% set the points_files if you don't need to generate them using findAllKeypoints

k = 2000;
min(k, max(8, floor(size(features, 1)/8)))
[features, split_features] = generate_features( points_files, varargin{:});

% find the features we want to cluster around
centroid_features = kmeans(min(k, max(8, floor(size(features, 1)/8))), ...
                           features);
save(centroid_file, 'centroid_features');

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

% make the call to our classifier
% make the call to svmlight using the matlab wrapper
option = svmlopt('ExecPath', 'classifiers/svm/');
svmlwrite( trainfile , [posData ; negData] , [posY ; negY]  );
svm_learn( option, trainfile, paramfile );
