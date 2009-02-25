% features is a { {[]} } type structure
% features{i} represents the image file
% features{i} represents each keypoint's descriptor

function [data] = make_feature_vector_(centroid_features, features)
data = zeros(size(features, 2), size(centroid_features, 1));
for i = 1:size(features, 2)
  feature = cluster_features(centroid_features, features{i});
  data(i, :) = feature;
end