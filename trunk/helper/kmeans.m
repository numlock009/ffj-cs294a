function [centroids] = kmeans(k, trainingSet)
dimension = size(trainingSet, 2);
random_pixels = randperm(size(trainingSet, 1));
centroids = trainingSet(random_pixels(1:k), :);

prev = zeros(k, dimension);

while( true )
  prev = centroids;
  nassigns = zeros(k, 1);
  nvalues = zeros(k, dimension);
  for i=1:size(trainingSet,1)
    min = norm( trainingSet(i, :) - centroids(1, :) );
    argmin_j = 1;
    for j=2:k
      temp = norm( trainingSet(i, :) - centroids(j, :) );
      if( min > temp )
        argmin_j = j;
        min = temp;
      end
    end
    nvalues(argmin_j, :) = nvalues(argmin_j, :) + trainingSet(i, :);
    nassigns(argmin_j) = nassigns(argmin_j) + 1;
  end
  
  for j=1:k
    if(nassigns(j) > 0)
      centroids(j, :) = nvalues(j, :) / nassigns(j);
    end
  end
  
  if( norm(centroids - prev, 'fro') < 0.00001 )
    break;
  end
end
