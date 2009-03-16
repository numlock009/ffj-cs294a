function [error, output, testMatrix, testCat] = test_model(classifier, pos_directory , neg_directory, testfile, centroid_features, ...
                                                  predictfile, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('pos_directory', @ischar);
p.addRequired('neg_directory', @ischar);
p.addRequired('testfile', @ischar);
p.addRequired('centroid_features', @(x)true);
p.addRequired('predictfile', @ischar);
p.addParamValue('exts', 'test', @ischar);
p.addParamValue('weighted', 0, @(x)true);
p.parse(pos_directory , neg_directory, testfile, centroid_features, predictfile, varargin{:});
weighted = p.Results.weighted;

points = getKeypoints({pos_directory, neg_directory}, varargin{:});
[features, split_features] = generate_features(points, varargin{:});

% setup the feature vectors for testing
posfeatures = split_features{1};
posData = get_feature_vector(points{1}, centroid_features, posfeatures, varargin{:});
posY = ones( size(posData,1) ,1);
size(posData)
if(weighted)
  posY = weighted * posY;
end

negfeatures = split_features{2};
negData = get_feature_vector(points{2}, centroid_features, negfeatures, varargin{:});
negY = -1 * ones( size(negData,1) ,1);
size(negData)

% make the call to our classifier
testMatrix = [posData ; negData];
testCat = [posY ; negY];

[error, output] = classifier(testMatrix, testCat, testfile, predictfile);
