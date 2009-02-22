function test_model( pos_directory , neg_directory, testfile, centroid_file , paramfile, ...
                     predictfile, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('pos_directory', @ischar);
p.addRequired('neg_directory', @ischar);
p.addRequired('testfile', @ischar);
p.addRequired('centroid_file', @ischar);
p.addRequired('paramfile', @ischar);
p.addRequired('predictfile', @ischar);
p.parse(pos_directory , neg_directory, testfile, centroid_file, paramfile, predictfile, varargin{:});

[min1 min2 points_files] = findAllKeypoints( {pos_directory, neg_directory}, ...
                                             varargin{:}, 'ext', '_test');
% points_files = {'images/pos_points', 'images/neg_points'}; % manually
% set the points_files if you don't need to generate them using findAllKeypoints

k = 2000;
centroid_data = load(centroid_file);
centroid_features = centroid_data.centroid_features;

posfeatures = get_features(points_files{1}, varargin{:});
posData = make_svm_feature_vector(centroid_features, posfeatures);
posY = ones( size(posData,1) ,1);

negfeatures = get_features(points_files{2}, varargin{:});
negData = make_svm_feature_vector(centroid_features, negfeatures);
negY = -1 * ones( size(negData,1) ,1);

% make the call to our classifier, decompose this out later.
% make the call to svmlight using the matlab wrapper
option = svmlopt('ExecPath', 'classifiers/svm/');
svmlwrite( testfile , [posData ; negData] , [posY ; negY]  );
svm_classify(option, testfile , paramfile , predictfile );