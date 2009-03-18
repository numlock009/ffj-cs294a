function [data] = get_feature_vector(points, centroid_features, features, ...
                                             varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points', @(x)true); 
p.addRequired('centroid_features', @(x)true);
p.addRequired('features', @(x)true); 
p.addParamValue('feature_type', 'keypt', @ischar)
p.parse(points, centroid_features, features, varargin{:});
feature_type = p.Results.feature_type;

% keypoint features
data = make_feature_vector_(centroid_features, features);

% whole image features
feature_type = regexp(feature_type, '_', 'split');
feature_type = sort(feature_type);
data_pts = [];
for pt = 1:size(points, 2)
  data_pt = [];
  for i = 1:size(feature_type,2)
    data_val = whole_features(feature_type{i}, imread(points{pt}{1}),...
                              varargin{:});
    data_pt = [data_pt, data_val(:)'];
  end
  data_pts = [data_pts; data_pt];
end

data = [data, data_pts];
data_good = zeros(0, size(data, 2));
good = 0;
for j = 1:size(data,1)
  if(norm(data(j, :)) ~= 0)
    good = good + 1;
    data_good(good, :) = data(j, :);
  end
end
data = data_good;
