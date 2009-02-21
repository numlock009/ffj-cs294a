function [centroids] = kmeans(k, trainingSet)
dimension = size(trainingSet, 2);
random_pixels = randperm(size(trainingSet, 1));
centroids = trainingSet(random_pixels(1:k), :);

prev = zeros(k, dimension);

c = zeros(size(trainingSet, 1), 1);

while( true )
  
  for i=1:size(trainingSet,1)
    min = norm( trainingSet(i, :) - centroids(1,:) );
    argmin_j = 1;
    for j=2:size(centroids,1)
      temp = norm( trainingSet(i, :) - centroids(j,:) );
      if( min > temp )
        argmin_j = j;
        min = temp;
      end
    end
    c(i) = argmin_j;
  end
  
  for j=1:size(centroids, 1)
    i = find(c == j);
    u(j,:) = sum(trainingSet(i))/ size(i,1);
  end
  if( norm(centroids - prev) < 0.00001 )
    break;
  end
  prev = centroids;
end
