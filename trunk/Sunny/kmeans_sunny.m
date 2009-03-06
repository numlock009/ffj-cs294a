function centroids = kmeans_sunny(img, wholefeature)
%k-means cluster%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initial centroids: 16 centroids
%circle 16 partitions r = min(size(img)) / 2;
%assum the center is (0 0), the 16 points are (0, r), (rsinu, rcosu), (rsin2u, rcos2u), (rsin3u, rcos3u)
%r = min(size(img)) / 4;
%u = 2*pi / 16;
%u2 = u/2;
wfindex = size(wholefeature, 1);
centroids = [];
oricentroids = [];
backrd = [];
for j = 1:1000
    rd = floor(random('unif', 0, 1) * wfindex);
    if ( rd == 0 || size(find(backrd == rd), 2) > 0 ) 
        continue;
    end
    backrd = [backrd, rd];
    centroids = [centroids; wholefeature(rd, :)];
    oricentroids = [oricentroids; wholefeature(rd, :)];
    if (size(backrd, 2) == 200)
        break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find the optimum centroids%%%%%%%%%%%%%%%%%%%%%%%%%%
while(1)    
    oldcentroids = centroids;
    for i = 1:wfindex
        mindist = intmax;
        for j = 1:200
            dist = sum( (wholefeature(i, 1:128) - centroids(j, 1:128)).^2 );
            if (dist < mindist)
                mindist = dist;
                wholefeature(i, 129) = j;%set its centroids index
            end
        end
    end

    centroids = zeros(200, 129);

    for i = 1:wfindex
        centroids(wholefeature(i, 129), 1:128) = centroids(wholefeature(i, 129), 1:128) + wholefeature(i, 1:128);
        centroids(wholefeature(i, 129), 129) = centroids(wholefeature(i, 129), 129) + 1;%set add count
    end

    for j=1:200
        if centroids(j, 129) ~= 0
            centroids(j, 1:128) = centroids(j, 1:128) / centroids(j, 129);
        end
    end

    error = sum ( sum( (oldcentroids(:,1:128) - centroids(:,1:128)).^2 ) )
    if error < 1 
        break;
    end
end
%find the optimum centroids%%%%%%%%%%%%%%%%%%%%%%%%%%make the dictionary