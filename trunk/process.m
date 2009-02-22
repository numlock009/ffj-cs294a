function process(pos_directory , neg_directory, trainfile , paramfile, varargin)
%train an SVM on training data, inputs are:
% pos_directory : the path of directory containing positive tarining examples
% neg_directory : the path of directory containing negative tarining
%      examples
% posfile : when positive example key points are computed using a key point detector
%      they are saved in the file named posfile -- this is useful when you want to 
%      test different descriptors with one ke point detector , so once you
%      computed key points they are saved and you can use them from then
% negfile : use it the same as posfile for negative examples
% tarinfile: the file in which the training data descriptors will be saved
% paramfile: the file in which parameters of the trained SVM will be saved
% cell size: is the size of region selected around each key point
% ori_binsize : along with RIFT can be used to determine number of
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
p.addOptional('centroid_file', [pos_directory,'/../','centroid_',trainfile], ...
              @ischar);
p.parse(pos_directory , neg_directory, trainfile , paramfile, varargin{:});
centroid_file = p.Results.centroid_file;

[min1 min2 points_files] = findAllKeypoints( {pos_directory, neg_directory}, ...
                                              varargin{:});
% points_files = {'images/pos_points', 'images/neg_points'}; % manually
% set the points_files if you don't need to generate them using findAllKeypoints

k = 2000;
features = generate_features( points_files, varargin{:});
centroid_features = kmeans(min(k, max(8, floor(size(features, 1)/8))), ...
                           features);
save(centroid_file, 'centroid_features');

% setup to train an svm
% reads all the key points from file and generates descriptors for each
% keypoint
% 
posfeatures = get_features(points_files{1}, varargin{:});
posData = make_svm_feature_vector(centroid_features, posfeatures);
posY = ones( size(posData,1) ,1);

negfeatures = get_features(points_files{2}, varargin{:});
negData = make_svm_feature_vector(centroid_features, negfeatures);
negY =-1 * ones( size(negData,1) ,1);

% make the call to svmlight using the matlab wrapper
option = svmlopt('ExecPath', 'classifiers/svm/');
svmlwrite( trainfile , [posData ; negData] , [posY ; negY]  );
svm_learn( option, trainfile, paramfile );
