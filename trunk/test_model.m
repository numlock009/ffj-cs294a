function test_model( pos_directory , neg_directory, testfile, centroid_features , paramfile, ...
                     predictfile, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('pos_directory', @ischar);
p.addRequired('neg_directory', @ischar);
p.addRequired('testfile', @ischar);
p.addRequired('centroid_features', @(x)true);
p.addRequired('paramfile', @ischar);
p.addRequired('predictfile', @ischar);
p.addParamValue('have_pts', false, @(x)(x == true || x == false));
p.addParamValue('exts', 'test', @ischar);
p.parse(pos_directory , neg_directory, testfile, centroid_features, paramfile, predictfile, varargin{:});
have_pts = p.Results.have_pts;

if(have_pts)
  points_files = {pos_directory, neg_directory}; % manually
  points = read_points_from_file( points_files );
else
  points = findAllKeypoints( {pos_directory, neg_directory}, varargin{:});
  write_points_to_file({pos_directory, neg_directory}, points, varargin{:});
end

[features, split_features] = generate_features(points, varargin{:});

% setup the feature vectors for testing
posfeatures = split_features{1};
posData = make_feature_vector(centroid_features, posfeatures);
posY = ones( size(posData,1) ,1);
size(posData)

negfeatures = split_features{2};
negData = make_feature_vector(centroid_features, negfeatures);
negY = -1 * ones( size(negData,1) ,1);
size(negData)
% make the call to our classifier, decompose this out later.
% make the call to svmlight using the matlab wrapper
option = svmlopt('ExecPath', 'classifiers/svm/');
svmlwrite( testfile , [posData ; negData] , [posY ; negY]  );
svm_classify(option, testfile , paramfile , predictfile );
