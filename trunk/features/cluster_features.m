% image_features is:
%  for a given particular image descriptors extracted for each keypoint
% @return a vector listing how many times each feature mean appeared
%   in the given image
function [clusters] = cluster_features(centroids, image_features)
clusters = zeros(1, size(centroids, 1));
for i = 1:size(image_features,1)
  min = norm(centroids(1, :) - image_features(i,:));
  index = 1;
  for k = 2:size(centroids, 1)
    temp = norm(centroids(k, :) - image_features(i,:));
    if( min > temp )
      min = temp;
      index = k;
    end
  end
  clusters(1, index) = clusters(1, index) + 1;
end