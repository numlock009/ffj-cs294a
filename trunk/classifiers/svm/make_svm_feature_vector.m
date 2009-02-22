function [data] = make_svm_feature_vector(centroid_features, features)
data = zeros(0 , size(centroid_features, 1));
good = 0;
for i = 1:size(features, 2)
  feature = cluster_features(centroid_features, features{i});
  if(norm(feature) ~= 0)
    good = good + 1;
    data(good, :) = feature;
  end
end