function [clusters] = cluster(centroids, image_features)
clusters = zeros(size(features, 1), size(centroids, 2));
for i = 1:size(features,1)
  min = norm(centroids(1, :) - features(i,:));
  index = 1;
  for k = 2:size(centroids, 1)
    temp = norm(centroids(k, :) - features(i,:));
    if( min > temp )
      min = temp;
      index = k;
    end
  end
  clusters(i, :) = centroids(index, :);
end